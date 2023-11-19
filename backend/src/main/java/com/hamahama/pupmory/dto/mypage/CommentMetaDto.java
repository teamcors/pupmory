package com.hamahama.pupmory.dto.mypage;

import com.hamahama.pupmory.domain.memorial.Comment;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * @author Queue-ri
 * @since 2023/11/19
 */

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class CommentMetaDto {
    private Long id;
    private Long postId;
    private String postOpName;
    private String content;
    private LocalDateTime createdAt;

    public static CommentMetaDto of (Comment comment, String postOpName) {
        return CommentMetaDto.builder()
                .id(comment.getId())
                .postId(comment.getPostId())
                .postOpName(postOpName)
                .content(comment.getContent())
                .createdAt(comment.getCreatedAt())
                .build();
    }
}
