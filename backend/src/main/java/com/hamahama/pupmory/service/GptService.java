package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.conversation.data.GptAnswerDataRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@RequiredArgsConstructor
@Service
public class GptService {
    private final ChatgptService chatgptService;
    // private final GptAnswerDataRepository gptAdRepo;

    public List<String> getAnswer(Long stage, Long set, Long id, String uAns) {
//        List<GptAnswerData> gptAnswerData = gptAdRepo.findAllByStageAndSetAndLineId(stage, set, id);
//        StringBuilder emotionBuilder = new StringBuilder();
//
//        for (GptAnswerData data : gptAnswerData)
//            emotionBuilder.append(", ").append(data.getEmotion());
//        emotionBuilder.deleteCharAt(0); // remove trailing comma
//
//        String prompt1 = "아래 문장은 반려동물을 잃은 사람이 한 말이에요. "
//                + emotionBuilder.toString()
//                + " 중 가장 많이 느껴지는 감정을 하나만 골라 한글로 작성해주세요.\n\n"
//                + "\"" + content + "\"";
//
//        String emotion = chatgptService.sendMessage(prompt1).replace("\n", "");
//
//        // 해당 감정의 양식 가져오기
//        String template = "";
//        for (GptAnswerData data : gptAnswerData) {
//            if (data.getEmotion().equals(emotion)) {
//                template = data.getTemplate();
//                break;
//            }
//        }
//        System.out.println(emotion);
//        System.out.println(template);
//
//        String prompt2 = "아래 문장은 반려동물을 잃은 사람이 한 말이에요. "
//                + "이 사람에게 해줄 위로를 다음의 '위로 양식'에 맞추어 그대로 한글로 작성해주세요.\n\n"
//                + "\"" + content + "\"\n\n"
//                + "위로 양식: " + template;
//
//        String answer = chatgptService.sendMessage(prompt2).replace("\n", "");
//
//        return new String[] {answer};

        // 프로토타입 시연 예시
        // 템플릿 없이 감정 구분만 하여 정적인 답변을 한다는 점에서 레거시와 혼용 불가
        String prompt = "아래 문장은 반려동물을 잃은 사람이 반려동물과의 기억을 회상하며 한 말이에요. "
                + "긍정, 부정 중 어느쪽에 가까운지 두 글자로 말해주세요.\n\n"
                + "\"" + uAns + "\"";

        String result = chatgptService.sendMessage(prompt).replace("\n", "");

        System.out.println(prompt);
        System.out.println(result);

        List<String> responseList = new ArrayList<String>();

        if (result.equals("긍정")) {
            responseList.add("{USERNAME}님,\n{PUPNAME}와의 기억을 떠올려보니");
            responseList.add("마냥 슬프기만 하지는 않다는 것을\n느끼셨나요?");
            responseList.add("{USERNAME}님의 마음이 잠시동안은\n행복했길 바라요.");
            responseList.add("하지만, {USERNAME}님...");
            responseList.add("{PUPNAME}를 생각하다보면\n분명 슬픈 감정이 생겨날 수 있어요.");
        }
        else {
            responseList.add("{USERNAME}님,");
            responseList.add("지금 {PUPNAME}와의 기억을\n생각하며 느끼는 감정은");
            responseList.add("너무나 당연한 감정이랍니다...");
            responseList.add("충분히 감정을 느끼는 것도\n정말 중요하거든요.");
            responseList.add("하지만, 저의 도움만으로는\n부족할 수도 있어요.");
        }

        responseList.add("그럴땐 도와줄개에서\n도움을 요청하거나,");
        responseList.add("함께할개에서 더 많은 사람들과\n이야기를 나눠보는 걸 추천드릴게요.");
        responseList.add("지금 커뮤니티에서\n{USERNAME}님에게 맞는 도움을 받아보세요!");

        return responseList;
    }
}
