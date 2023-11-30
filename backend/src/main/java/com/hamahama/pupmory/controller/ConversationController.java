package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.conf.NoAuth;
import com.hamahama.pupmory.dto.*;
import com.hamahama.pupmory.dto.conversation.EmotionRequestDto;
import com.hamahama.pupmory.dto.user.UserInfoUpdateDto;
import com.hamahama.pupmory.service.ConversationService;
import com.hamahama.pupmory.service.GptService;
import com.hamahama.pupmory.util.auth.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("conversation")
public class ConversationController {
    private final ConversationService conversationService;
    private final GptService gptService;

    // deprecated (prototype only)
    @PostMapping("/intro/info")
    public void saveUserInfo(@RequestAttribute("uid") String uid, @RequestBody UserInfoUpdateDto dto) {
        conversationService.saveUserInfo(uid, dto);
    }

    // deprecated (prototype only)
    @PostMapping("/set")
    @NoAuth
    public ResponseEntity<List<SetResponseDto>> getAvailableSet(@RequestBody SetRequestDto setRequestDto) {
        return new ResponseEntity<List<SetResponseDto>>(conversationService.getAvailableSet(setRequestDto.getUuid()), HttpStatus.OK);
    }

    // deprecated (prototype only)
    @PostMapping("/answer")
    @NoAuth
    public ResponseEntity<AnswerResponseDto> getAnswer(@RequestBody AnswerRequestDto answerRequestDto) {
        return conversationService.getAnswer(
                answerRequestDto.getUuid(),
                answerRequestDto.getStage(),
                answerRequestDto.getSet(),
                answerRequestDto.getLineId(),
                answerRequestDto.getUserAnswer()
        );
    }

    // deprecated (prototype only)
    @PostMapping("/line")
    @NoAuth
    public ResponseEntity<List<LineResponseDto>> getAnswer(@RequestBody LineRequestDto lineRequestDto) {
        Long selected = -1L; // default
        Long userSelected = lineRequestDto.getSelected();

        if (userSelected != null) selected = userSelected;

        return conversationService.getLine(
                lineRequestDto.getStage(),
                lineRequestDto.getSet(),
                lineRequestDto.getLineId(),
                selected
        );
    }

    // stage 1 = 초기
    // 판단해야 하는 감정 목록은 GptEmotionData 엔티티 참고
    @PostMapping("/emotion/stage1/{setId}")
    @NoAuth
    public ResponseEntity<?> getEmotion(@PathVariable Long setId, @RequestBody EmotionRequestDto dto) {
        return gptService.getEmotion(1L, setId, dto.getUserAnswer());
    }
}
