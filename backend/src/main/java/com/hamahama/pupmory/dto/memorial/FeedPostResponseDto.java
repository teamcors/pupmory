package com.hamahama.pupmory.dto.memorial;

import com.hamahama.pupmory.domain.memorial.Post;
import com.hamahama.pupmory.domain.user.ServiceUser;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/09/19
 */

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class FeedPostResponseDto {
    private Long id;
    private String userUid;
    private String nickname;
    private String profileImage;
    private String image; // single thumbnail image
    private String title;
    private LocalDateTime createdAt;

    public static FeedPostResponseDto of(Post post, ServiceUser user) {
        List<String> imageList = Arrays.asList(post.getImage().split("\\s*,\\s*"));

        return FeedPostResponseDto.builder()
                .id(post.getId())
                .userUid(user.getUserUid())
                .nickname(user.getNickname())
                .profileImage(user.getProfileImage())
                .image(imageList.get(0))
                .title(post.getTitle())
                .createdAt(post.getCreatedAt())
                .build();
    }
}
