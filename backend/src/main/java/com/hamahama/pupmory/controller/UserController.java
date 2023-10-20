package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.domain.user.ServiceUser;
import com.hamahama.pupmory.dto.*;
import com.hamahama.pupmory.service.ConversationService;
import com.hamahama.pupmory.service.UserService;
import com.hamahama.pupmory.util.signin.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/09/11
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("user")
public class UserController {
    private final ConversationService conversationService;
    private final UserService userService;
    private final JwtKit jwtKit;

    // deprecated (for prototype only)
    @GetMapping("/home")
    public ResponseEntity<List<SetResponseDto>> getAvailableSet(@RequestBody SetRequestDto setRequestDto) {
        return new ResponseEntity<List<SetResponseDto>>(conversationService.getAvailableSet(setRequestDto.getUuid()), HttpStatus.OK);
    }

    @GetMapping("/info")
    public ServiceUser getUserInfo(@RequestHeader("Authorization") String token){
        String uid = jwtKit.validate(token);
        return userService.getUserInfo(uid);
    }
}
