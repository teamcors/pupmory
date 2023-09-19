package com.hamahama.pupmory.dto.memorial;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/09/19
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class FeedPostResponseDto {
    private Long id;
    private String nickname;
    private String profileImage;
    private String image;
    private String title;
}
