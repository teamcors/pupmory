package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.dto.*;
import com.hamahama.pupmory.service.ConversationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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

    @GetMapping("/set")
    public ResponseEntity<List<SetResponseDto>> getAvailableSet(@RequestBody SetRequestDto setRequestDto) {
        return new ResponseEntity<List<SetResponseDto>>(conversationService.getAvailableSet(setRequestDto.getUuid()), HttpStatus.OK);
    }

    @GetMapping("/answer")
    public ResponseEntity<AnswerResponseDto> getAnswer(@RequestBody AnswerRequestDto answerRequestDto) {
        return conversationService.getAnswer(
                answerRequestDto.getUuid(),
                answerRequestDto.getStage(),
                answerRequestDto.getSet(),
                answerRequestDto.getLineId(),
                answerRequestDto.getUserAnswer()
        );
    }

    @GetMapping("/line")
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
