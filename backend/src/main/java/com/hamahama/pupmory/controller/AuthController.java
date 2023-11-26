package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.conf.NoAuth;
import com.hamahama.pupmory.dto.auth.SignUpRequestDto;
import com.hamahama.pupmory.pojo.Token;
import com.hamahama.pupmory.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;

/**
 * @author Queue-ri
 * @since 2023/10/20
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("auth")
public class AuthController {
    private final AuthService authService;

    @GetMapping("/token")
    @NoAuth
    public Token getToken(@RequestHeader(value="X-Firebase-Token") String uid) {
        return authService.getToken(uid);
    }

    @GetMapping("/signin")
    @NoAuth
    public ResponseEntity<?> signIn(@RequestHeader(value="X-Firebase-Token") String uid) {
        return authService.signIn(uid);
    }

    @PostMapping("/signup")
    @NoAuth
    public ResponseEntity<?> signUp(@RequestBody SignUpRequestDto dto) {
        return authService.signUp(dto.getUserUid(), dto.getEmail());
    }

    @PostMapping("/email")
    @NoAuth
    public ResponseEntity<?> sendValidationMail(@RequestParam String email) {
        return authService.sendValidationMail(email);
    }

    @GetMapping("/code")
    @NoAuth
    public ResponseEntity<?> checkValidationCode(@RequestParam String code, @RequestParam String issuedBy) {
        return authService.checkValidationCode(code, issuedBy);
    }
}
