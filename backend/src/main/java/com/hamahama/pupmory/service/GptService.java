package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.conversation.data.GptAnswerData;
import com.hamahama.pupmory.domain.conversation.data.GptAnswerDataRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@RequiredArgsConstructor
@Service
public class GptService {
    private final ChatgptService chatgptService;
    private final GptAnswerDataRepository gptAdRepo;

    public String getAnswer(Long stage, Long set, Long qid, String content) {
        List<GptAnswerData> gptAnswerData = gptAdRepo.findAllByStageAndSetAndQuestionId(stage, set, qid);
        StringBuilder emotionBuilder = new StringBuilder();

        for (GptAnswerData data : gptAnswerData)
            emotionBuilder.append(", ").append(data.getEmotion());
        emotionBuilder.deleteCharAt(0); // remove trailing comma

        String prompt1 = "아래 문장은 반려동물을 잃은 사람이 한 말이에요. "
                + emotionBuilder.toString()
                + " 중 가장 많이 느껴지는 감정을 하나만 골라 한글로 작성해주세요.\n\n"
                + "\"" + content + "\"";

        String emotion = chatgptService.sendMessage(prompt1).replace("\n", "");

        // 해당 감정의 양식 가져오기
        String template = "";
        for (GptAnswerData data : gptAnswerData) {
            if (data.getEmotion().equals(emotion)) {
                template = data.getTemplate();
                break;
            }
        }
        System.out.println(emotion);
        System.out.println(template);

        String prompt2 = "아래 문장은 반려동물을 잃은 사람이 한 말이에요. "
                + "이 사람에게 해줄 위로를 다음의 '위로 양식'에 맞추어 그대로 한글로 작성해주세요.\n\n"
                + "\"" + content + "\"\n\n"
                + "위로 양식: " + template;

        String answer = chatgptService.sendMessage(prompt2).replace("\n", "");

        return answer;
    }
}
