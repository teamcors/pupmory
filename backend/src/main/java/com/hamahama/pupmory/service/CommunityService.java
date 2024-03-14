package com.hamahama.pupmory.service;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hamahama.pupmory.domain.community.Help;
import com.hamahama.pupmory.domain.community.HelpRepository;
import com.hamahama.pupmory.domain.community.WordCloud;
import com.hamahama.pupmory.domain.community.WordCloudRepository;
import com.hamahama.pupmory.domain.user.ServiceUser;
import com.hamahama.pupmory.domain.user.ServiceUserRepository;
import com.hamahama.pupmory.dto.community.HelpAnswerSaveRequestDto;
import com.hamahama.pupmory.dto.community.HelpResponseDto;
import com.hamahama.pupmory.dto.community.HelpSaveRequestDto;
import com.hamahama.pupmory.dto.community.WordCloudRequestDto;
import com.hamahama.pupmory.pojo.HelpLog;
import com.hamahama.pupmory.pojo.WordCount;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/10/11
 */

@Slf4j
@RequiredArgsConstructor
@Service
public class CommunityService {
    private final HelpRepository helpRepo;
    private final ServiceUserRepository userRepo;
    private final WordCloudRepository wCloudRepo;
    private final ObjectMapper objectMapper;

    @Autowired
    RabbitTemplate rabbitTemplate;

    @Transactional
    public void saveHelp(String uid, HelpSaveRequestDto dto) {
        helpRepo.save(dto.toEntity(uid));
    }

    @Transactional
    public Help getHelp(String uid, Long hid) {
        Help help = helpRepo.findById(hid).get();

        // 도움 내역은 요청자 또는 요청받은자만 열람 가능
        if (help.getFromUserUid().equals(uid) || help.getToUserUid().equals(uid)) {
            // 답변이 있는데 요청자가 읽으면 읽음 처리
            if (help.getFromUserUid().equals(uid) && help.getAnswer() != null) {
                help.setIsFromUserReadAnswer(2); // help answer is read by user
            }
            return help;
        } else {
            // 4xx error
        }

        return null; // refactor later
    }

    @Transactional
    public Long getHelpCount(String uid) {
        return helpRepo.countAllToUserAnswer(uid);
    }

    @Transactional
    public List<HelpResponseDto> getAllHelp(String uid, String type) {
        List<Help> helpList;
        List<HelpResponseDto> dtoList = new ArrayList<HelpResponseDto>();

        if (type.equals("req")) // 본인이 요청한 도움 내역
            helpList = helpRepo.findAllByFromUserUid(uid);
        else if (type.equals("ans")) // 본인이 요청받은 도움 내역
            helpList = helpRepo.findAllByToUserUid(uid);
        else
            return null; // ResponseEntity로 리팩토링 필요

        ServiceUser fromUser, toUser;
        for (Help help : helpList) {
            fromUser = userRepo.findById(help.getFromUserUid()).get();
            toUser = userRepo.findById(help.getToUserUid()).get();
            dtoList.add(HelpResponseDto.of(help, fromUser, toUser));
        }

        return dtoList;
    }

    @Transactional
    public List<HelpLog> getHelpLog(String uid) {
        List<String> fromUserList = helpRepo.findDistinctFromUser(uid);

        List<HelpLog> helpLog = new ArrayList<>();
        for (String fromUserUid : fromUserList) {
            ServiceUser user = userRepo.findById(fromUserUid).get();
            helpLog.add(HelpLog.of(user));
        }

        return helpLog;
    }

    @Transactional
    public void saveHelpAnswer(String uid, HelpAnswerSaveRequestDto dto) throws IOException, InterruptedException {
        Long hid = dto.getHelpId();
        Help help = helpRepo.findById(hid).get();
        if (help.getToUserUid().equals(uid)) {
            help.setAnswer(dto.getContent());
            help.setAnsweredAt(LocalDateTime.now());
            help.setIsFromUserReadAnswer(1);
            //saveWordCloudExec(uid, dto.getContent());
            publishWcGenMessage(uid, dto.getContent());
        } else {
            // 4xx 에러 핸들링
        }
    }

    // 1트 실패: status 400 - HttpClient 쪽 이슈일수도 있음
    @Transactional
    public void saveWordCloud(String uid, WordCloudRequestDto dto) {
        // FastAPI 측에 계산 요청하고 결과 받기
        try {
            HttpPost req = new HttpPost("http://localhost:9000/wordcloud"); //GET 메소드 URL 생성
            req.setHeader("Content-Type", "application/json");
            req.setHeader("Accept", "application/json");

            // serialize
            String json = objectMapper.writeValueAsString(dto);

            // set body
            StringEntity entity = new StringEntity(json);
            req.setEntity(entity);

            // request
            HttpClient client = HttpClientBuilder.create().build();
            HttpResponse res = client.execute(req);

            log.info("* * * Requested to FastAPI:\n" + json);

            //Response 출력
            if (res.getStatusLine().getStatusCode() == 200) {
                ResponseHandler<String> handler = new BasicResponseHandler();
                String result = handler.handleResponse(res);
                log.info(result);

                // DB에 결과 저장
                wCloudRepo.save(new WordCloud(uid, result));

            } else {
                log.error("* * * Wordcloud Error: " + res.getStatusLine().getStatusCode());
            }

        } catch (Exception e) {
            log.error(e.toString());
        }
    }

    // 2트 실패: status 422 - I dunno why
    @Transactional
    public void saveWordCloudLegacy(String uid, WordCloudRequestDto dto) throws IOException {
        URL url = new URL("http://127.0.0.1:9000/wordcloud");
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setRequestProperty("Accept", "application/json");
        con.setDoOutput(true);
        String jsonInputString = "{\"prev_list\":" + dto.getPrevList() + ", \"sentence\":" + dto.getSentence() + "}";

        try (OutputStream os = con.getOutputStream()) {
            byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), StandardCharsets.UTF_8))) {
            StringBuilder response = new StringBuilder();
            String responseLine = null;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            log.info(con.getResponseCode() + " " + response);
        }
    }

    // 3트 성공: 하지만 내가 안좋아하는 방식 T^T
    @Transactional
    public void saveWordCloudExec(String uid, String sentence) throws IOException, InterruptedException {
        // argument이므로 double quote가 필요하며 json double quote를 사전에 처리해야 함에 유의
        // platform에 따라 되기도 안되기도 해서 도커 환경 권장 (windows, ubuntu)
        String arg1 = "\"" + sentence + "\"";
        Optional<WordCloud> optWc = wCloudRepo.findById(uid);
        String arg2;
        if (optWc.isPresent()) arg2 = optWc.get().getWords();
        else arg2 = "[]";

        ProcessBuilder pb = new ProcessBuilder("python3", "wcloud.py", arg1, arg2);
        Process p = pb.start();
        int exitval = p.waitFor();

        BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream(), StandardCharsets.UTF_8));

        // read the stdout of the subprocess
        StringBuilder result = new StringBuilder();
        String s;
        while ((s = br.readLine()) != null) {
            result.append(s);
        }

        // logging - 서브프로세스 오류 진단에 사이다같은 역할을 해주는 녀석들
        if (exitval != 0) {
            log.error("* * * saveWordCloudExec(): 워드클라우드 생성에 실패했습니다. (exitval: " + exitval + ")");
            int len = p.getErrorStream().available();
            byte[] buf = new byte[len];
            p.getErrorStream().read(buf);
            log.error(new String(buf));
        } else {
            String data = result.toString();
            log.info("* * * saveWordCloudExec(): 워드클라우드 생성이 완료되었습니다.");
            log.info(data);

            wCloudRepo.save(new WordCloud(uid, data));
        }
    }

    // 4트: RabbitMQ 메시지 발행
    @Transactional
    public void publishWcGenMessage(String uid, String sentence) {
        Optional<WordCloud> optWCloud = wCloudRepo.findById(uid);
        String prevList;

        // 워드클라우드 DB로부터 이전 워드클라우드 데이터 가져오기
        if (optWCloud.isPresent()) prevList = optWCloud.get().getWords();
        else prevList = "[]";

        // wcloud.py에 워드클라우드 데이터 연산 요청 (rpc)
        log.info("* * * 워드클라우드 연산 요청: {}", sentence);
        rabbitTemplate.convertAndSend("pupmory.wcgen.exchange", "pupmory.wcgen", sentence);
    }

    @Transactional
    public List<WordCount> getWordCloud(String uid) throws JsonProcessingException {
        Optional<WordCloud> optWCloud = wCloudRepo.findById(uid);

        if (optWCloud.isPresent()) {
            WordCloud wCloud = optWCloud.get();
            String words = wCloud.getWords();
            ObjectMapper mapper = new ObjectMapper();
            // single quote는 json 비표준이나, 현 코드에선 python dictionary를 파싱하는 것이므로 ㄱㅊ
            mapper.configure(JsonParser.Feature.ALLOW_SINGLE_QUOTES, true);
            List<WordCount> wCList = mapper.readValue(words, new TypeReference<List<WordCount>>() {
            });

            return wCList;
        }

        return null; // refactor later
    }

}
