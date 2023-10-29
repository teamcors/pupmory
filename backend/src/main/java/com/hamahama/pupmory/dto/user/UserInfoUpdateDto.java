package com.hamahama.pupmory.dto.user;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/10/29
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class UserInfoUpdateDto {
    private String nickname;
    private String puppyName;
    private Integer puppyAge;
    private String puppyType;
}
