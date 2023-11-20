package com.hamahama.pupmory.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/10/27
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class SignUpResponseDto {
    private String accessToken;
}
