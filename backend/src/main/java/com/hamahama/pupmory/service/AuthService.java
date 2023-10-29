package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.auth.ValidationCode;
import com.hamahama.pupmory.domain.auth.ValidationCodeRepository;
import com.hamahama.pupmory.domain.user.ServiceUser;
import com.hamahama.pupmory.domain.user.ServiceUserRepository;
import com.hamahama.pupmory.dto.SetResponseDto;
import com.hamahama.pupmory.dto.auth.SignUpResponseDto;
import com.hamahama.pupmory.pojo.ErrorMessage;
import com.hamahama.pupmory.pojo.Token;
import com.hamahama.pupmory.util.auth.JwtKit;
import com.hamahama.pupmory.util.auth.MailKit;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.mail.MessagingException;
import java.time.LocalDateTime;
import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/10/20
 */

@RequiredArgsConstructor
@Service
@Slf4j
public class AuthService {
    private final ServiceUserRepository userRepo;
    private final ValidationCodeRepository codeRepo;
    private final JwtKit jwtKit;
    private final MailKit mailKit;

    public Token getToken(String uid) {
        return new Token(jwtKit.generateAccessToken(uid));
    }

    @Transactional
    public ResponseEntity<?> signIn(String uid) {
        Optional<ServiceUser> user = userRepo.findById(uid);

        if (user.isPresent())
            return new ResponseEntity<Token>(new Token(jwtKit.generateAccessToken(uid)), HttpStatus.OK);
        else
            return new ResponseEntity<ErrorMessage>(new ErrorMessage(401, "This user has not been registered."), HttpStatus.UNAUTHORIZED);
    }

    @Transactional
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

    @Transactional
    public ResponseEntity<?> sendValidationMail(String email) {
        try {
            String code = mailKit.sendEmail(email);
            codeRepo.save(
                    ValidationCode.builder()
                            .code(code)
                            .issuedBy(email)
                            .build()
            );
        }
        catch (MessagingException e) {
            log.error(e.getMessage());
            return new ResponseEntity<ErrorMessage>(new ErrorMessage(409, "Cannot send email to given address."), HttpStatus.CONFLICT);
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Transactional
    public ResponseEntity<?> checkValidationCode(String code, String issuedBy) {
        Optional<ValidationCode> optCode = codeRepo.findByCodeAndIssuedBy(code, issuedBy);

        if (optCode.isPresent()){
            LocalDateTime createdAt = optCode.get().getCreatedAt();
            LocalDateTime expiration = createdAt.plusMinutes(5);
            if (LocalDateTime.now().isBefore(expiration))
                return new ResponseEntity<>(HttpStatus.OK);
        }

        return new ResponseEntity<ErrorMessage>(new ErrorMessage(400, "This code is not valid."), HttpStatus.BAD_REQUEST);
    }

}
