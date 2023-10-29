package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.user.ServiceUser;
import com.hamahama.pupmory.domain.user.ServiceUserRepository;
import com.hamahama.pupmory.dto.SetResponseDto;
import com.hamahama.pupmory.dto.auth.SignUpResponseDto;
import com.hamahama.pupmory.pojo.ErrorMessage;
import com.hamahama.pupmory.pojo.Token;
import com.hamahama.pupmory.util.auth.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/10/20
 */

@RequiredArgsConstructor
@Service
public class AuthService {
    private final ServiceUserRepository userRepo;
    private final JwtKit jwtKit;

    public Token getToken(String uid) {
        return new Token(jwtKit.generateAccessToken(uid));
    }

    public ResponseEntity<?> signIn(String uid) {
        Optional<ServiceUser> user = userRepo.findById(uid);

        if (user.isPresent())
            return new ResponseEntity<Token>(new Token(jwtKit.generateAccessToken(uid)), HttpStatus.OK);
        else
            return new ResponseEntity<ErrorMessage>(new ErrorMessage(401, "This user has not been registered."), HttpStatus.UNAUTHORIZED);
    }

    public ResponseEntity<?> signUp(String uid, String email) {
        Optional<ServiceUser> user = userRepo.findByEmail(email);

        if (user.isPresent()) { // 이미 가입된 회원
            return new ResponseEntity<ErrorMessage>(new ErrorMessage(409, "This email is already registered."), HttpStatus.CONFLICT);
        }

        ServiceUser newUser = ServiceUser.builder()
                .userUid(uid)
                .email(email)
                .build();
        // 신규 가입
        userRepo.save(newUser);
        return new ResponseEntity<Token>(new Token(jwtKit.generateAccessToken(uid)), HttpStatus.OK);
    }
}
