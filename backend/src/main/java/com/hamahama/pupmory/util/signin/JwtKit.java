package com.hamahama.pupmory.util.signin;

import io.jsonwebtoken.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * @author Queue-ri
 * @since 2023/10/20
 */

@Slf4j
@RequiredArgsConstructor
@Component
public class JwtKit {

    @Value("${jwt.secret}")
    private String JWT_SECRET;

    private final Long JWT_EXP = 30 * 24 * 60 * 60 * 1000L; // 30 days for test

    public String generateAccessToken(String uid) {
        return Jwts.builder()
                .setSubject(uid)
                .setExpiration(new Date(System.currentTimeMillis() + JWT_EXP))
                .signWith(SignatureAlgorithm.HS256, JWT_SECRET)
                .compact();
    }

    public String validate(String header) {
        try {
            String token = header.replace("Bearer ", "");
            String uid = Jwts.parser().setSigningKey(JWT_SECRET).parseClaimsJws(token).getBody().getSubject();
            log.info("* * * JwtKit: User " + uid + " validated.");
            return uid;
        } catch (SignatureException e) {
            log.error("Invalid JWT signature", e);
        } catch (MalformedJwtException e) {
            log.error("Invalid JWT token", e);
        } catch (ExpiredJwtException e) {
            log.error("Expired JWT token", e);
        } catch (UnsupportedJwtException e) {
            log.error("Unsupported JWT token", e);
        } catch (IllegalArgumentException e) {
            log.error("JWT claims string is empty.", e);
        }
        return null;
    }
}