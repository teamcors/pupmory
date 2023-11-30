package com.hamahama.pupmory.conf;

import com.hamahama.pupmory.util.auth.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author Queue-ri
 * @author becky
 * @author hyojeongchoi
 * @author nusuy
 * @since 2023/11/16
 */

@RequiredArgsConstructor
public class AuthenticationInterceptor implements HandlerInterceptor {
    private final JwtKit jwtKit;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        boolean check = checkAnnotation(handler, NoAuth.class);
        // 인가가 필요하지 않은 api에 접근할 경우
        if (check) return true;

        // 인가가 필요할 경우
        String header = request.getHeader("Authorization");
        String uid = jwtKit.validate(header);
        request.setAttribute("uid", uid);
        return true;
    }

    private boolean checkAnnotation(Object handler, Class cls) {
        HandlerMethod handlerMethod = (HandlerMethod)handler;
        if (handlerMethod.getMethodAnnotation(cls) != null) { // 해당 어노테이션이 존재하면 true.
            return true;
        }
        return false;
    }
}
