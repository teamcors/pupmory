package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.dto.SetRequestDto;
import com.hamahama.pupmory.dto.SetResponseDto;
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
}
