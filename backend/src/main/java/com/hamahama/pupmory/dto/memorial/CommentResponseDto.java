package com.hamahama.pupmory.dto.memorial;

import com.hamahama.pupmory.domain.memorial.Comment;
import com.hamahama.pupmory.domain.user.ServiceUser;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * @author Queue-ri
 * @since 2023/10/27
 */

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class CommentResponseDto {
    private Long id;
    private String userUid;
    private String nickname;
    private String profileImage;
    private String content;
    private LocalDateTime createdAt;

    public static CommentResponseDto of(Comment comment, ServiceUser user) {
        return CommentResponseDto.builder()
                .id(comment.getId())
                .userUid(user.getUserUid())
                .nickname(user.getNickname())
                .profileImage(user.getProfileImage())
                .content(comment.getContent())
                .createdAt(comment.getCreatedAt())
                .build();
    }
}
