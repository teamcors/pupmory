package com.hamahama.pupmory.util.auth;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring5.SpringTemplateEngine;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.util.Random;

/**
 * @author Queue-ri
 * @since 2023/10/27
 */

@Slf4j
@RequiredArgsConstructor
@Component
public class MailKit {

    @Value("${spring.mail.username}")
    private String MAIL_USERNAME;

    private final JavaMailSender mailSender;
    private final SpringTemplateEngine templateEngine;

    // 6자리 인증코드 생성
    public String generateValidationCode() {
        Random rand = new Random();
        int number = rand.nextInt(999999);

        return String.format("%06d", number);
    }

    // 메일 양식 생성
    public MimeMessage createForm(String code, String email) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        message.addRecipients(MimeMessage.RecipientType.TO, email); // 받는 주소
        message.setSubject("기억할개 회원가입 인증 코드"); // 제목
        message.setFrom("기억할개 <" + MAIL_USERNAME + ">"); // 보내는 주소
        message.setText(setContext(code), "utf-8", "html");

        return message;
    }

    // 타임리프 context 설정
    public String setContext(String code) {
        Context context = new Context();
        context.setVariable("code", code);
        return templateEngine.process("auth-mail", context);
    }

    // 메일 전송
    public String sendEmail(String email) throws MessagingException {
        String validationCode = generateValidationCode();
        MimeMessage mailForm = createForm(validationCode, email);
        mailSender.send(mailForm);

        return validationCode;
    }
}