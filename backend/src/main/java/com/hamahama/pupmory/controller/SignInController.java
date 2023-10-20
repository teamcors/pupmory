package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.pojo.Token;
import com.hamahama.pupmory.service.SignInService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("signin")
public class SignInController {
    private final SignInService signInService;

    @GetMapping("/token")
    public Token getToken(@RequestHeader(value="X-Firebase-Token") String uid) {
        return signInService.getToken(uid);
    }
}
