package com.hamahama.pupmory.service;

import com.hamahama.pupmory.pojo.Token;
import com.hamahama.pupmory.util.signin.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@RequiredArgsConstructor
@Service
public class SignInService {
    private final JwtKit jwtKit;

    public Token getToken(String uid) {
        return new Token(jwtKit.generateAccessToken(uid));
    }
}
