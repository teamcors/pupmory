package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.conversation.MetaData;
import com.hamahama.pupmory.domain.conversation.MetaDataRepository;
import com.hamahama.pupmory.domain.conversation.data.AnswerData;
import com.hamahama.pupmory.domain.conversation.data.AnswerDataRepository;
import com.hamahama.pupmory.domain.conversation.result.SetResultId;
import com.hamahama.pupmory.domain.conversation.result.UserSetResult;
import com.hamahama.pupmory.domain.conversation.result.UserSetResultRepository;
import com.hamahama.pupmory.dto.AnswerResponseDto;
import com.hamahama.pupmory.dto.SetResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@RequiredArgsConstructor
@Service
public class ConversationService {
    private final UserSetResultRepository usrRepo;
    private final MetaDataRepository mdRepo;
    private final AnswerDataRepository adRepo;

    private final GptService gptService;

    @Transactional
    public List<SetResponseDto> getAvailableSet(String uuid) {
        List<UserSetResult> resList = usrRepo.getLastTwoSet(uuid);
        List<MetaData> availableMeta = new ArrayList<MetaData>();
        List<SetResponseDto> availableSet = new ArrayList<SetResponseDto>();

        if (resList.size() == 0) { // 완료 이력 없음 - 인트로 진행
            availableMeta = mdRepo.findByAllMetaDataIdStage(0L);
        }
        else if (resList.size() == 1) { // 이력 하나
            SetResultId first = resList.get(0).getResultId(); // 가장 최신 기록

            // 최근 기록의 stage가 intro일 것이므로 다음 단계 진행
            availableMeta = mdRepo.findByAllMetaDataIdStage(first.getStage() + 1);
        }
        else { // 이력 둘
            SetResultId first = resList.get(0).getResultId(); // 가장 최신 기록
            SetResultId second = resList.get(1).getResultId();

            // 두 기록의 stage가 서로 다르면 최근 기록의 단계 중 다른 세트 진행
            if (!first.getStage().equals(second.getStage()))
                availableMeta.add(mdRepo.findByMetaDataStageAndMetaDataSetNot(first.getStage(), first.getSet()));
            // 두 기록의 stage가 같으면 다음 스테이지의 모든 세트 진행
            else
                availableMeta = mdRepo.findByAllMetaDataIdStage(first.getStage() + 1);
        }

        for (MetaData meta : availableMeta)
            availableSet.add(new SetResponseDto(meta));

        return availableSet;
    }

    @Transactional
    public ResponseEntity<AnswerResponseDto> getAnswer(String uuid, Long stage, Long set, Long qid, String type, String content) {
        AnswerResponseDto dto;

        if (type.equals("select")) { // 선택형
            AnswerData answerData = adRepo.findSelectTypeAnswer(stage, set, qid, Long.parseLong(content));
            dto = new AnswerResponseDto(answerData.getAnswer());
        }
        else if (type.equals("monologue")) { // 독백형 (원래 요청 보내면 안되는 case)
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        else { // 단답형, 장문형, 미디어형
            AnswerData answerData = adRepo.findOtherTypeAnswer(stage, set, qid);
            if (answerData.getIsGptRequired())
                dto = new AnswerResponseDto(gptService.getAnswer(stage, set, qid, content));
            else
                dto = new AnswerResponseDto(answerData.getAnswer());
        }

        return new ResponseEntity<AnswerResponseDto>(dto, HttpStatus.OK);
    }
}
