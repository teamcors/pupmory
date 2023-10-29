package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.dto.*;
import com.hamahama.pupmory.dto.user.UserInfoUpdateDto;
import com.hamahama.pupmory.service.ConversationService;
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
    private final JwtKit jwtKit;

    @PostMapping("/intro/info")
    public void saveUserInfo(@RequestHeader("Authorization") String token, @RequestBody UserInfoUpdateDto dto) {
        String uid = jwtKit.validate(token);
        conversationService.saveUserInfo(uid, dto);
    }

    @PostMapping("/set")
    public ResponseEntity<List<SetResponseDto>> getAvailableSet(@RequestBody SetRequestDto setRequestDto) {
        return new ResponseEntity<List<SetResponseDto>>(conversationService.getAvailableSet(setRequestDto.getUuid()), HttpStatus.OK);
    }

    @PostMapping("/answer")
    public ResponseEntity<AnswerResponseDto> getAnswer(@RequestBody AnswerRequestDto answerRequestDto) {
        return conversationService.getAnswer(
                answerRequestDto.getUuid(),
                answerRequestDto.getStage(),
                answerRequestDto.getSet(),
                answerRequestDto.getLineId(),
                answerRequestDto.getUserAnswer()
        );
    }

    @PostMapping("/line")
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
}
