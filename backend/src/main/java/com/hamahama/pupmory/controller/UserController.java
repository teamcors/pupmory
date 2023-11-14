package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.domain.user.ServiceUser;
import com.hamahama.pupmory.dto.*;
import com.hamahama.pupmory.dto.memorial.PostRequestDto;
import com.hamahama.pupmory.dto.user.ConversationStatusUpdateDto;
import com.hamahama.pupmory.dto.user.UserInfoUpdateDto;
import com.hamahama.pupmory.service.ConversationService;
import com.hamahama.pupmory.service.UserService;
import com.hamahama.pupmory.util.auth.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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

    @PutMapping("/conversation-status")
    public ResponseEntity<?> setUserConversationStatus(@RequestHeader("Authorization") String token, @RequestBody ConversationStatusUpdateDto dto){
        String uid = jwtKit.validate(token);
        return userService.setUserConversationStatus(uid, dto);
    }

    // 메모리얼에서 프로필 수정
    // json: 변경되지 않은 필드도 그대로 같이 보내줘야 함
    // image: 변경되지 않았을 경우 보내지 않아야 함 (null)
    @PostMapping("/info")
    public ResponseEntity<?> updateUserInfo(@RequestHeader(value="Authorization") String token,
                                      @RequestPart("json") UserInfoUpdateDto dto,
                                      @RequestPart("image") @Nullable MultipartFile mfile) {
        String uid = jwtKit.validate(token);
        return userService.updateUserInfo(uid, dto, mfile);
    }
}
