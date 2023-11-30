package com.hamahama.pupmory.conf;

import com.hamahama.pupmory.util.auth.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @author Queue-ri
 * @author becky
 * @author hyojeongchoi
 * @author nusuy
 * @since 2023/11/16
 */

@Configuration
@RequiredArgsConstructor
public class WebConfig implements WebMvcConfigurer {
    private final JwtKit jwtKit;

    @Override
    public void addInterceptors(InterceptorRegistry reg){
        reg.addInterceptor(new AuthenticationInterceptor(jwtKit))
                .order(1)
                .addPathPatterns("/**"); // interceptor 작업이 필요한 path
    }
}