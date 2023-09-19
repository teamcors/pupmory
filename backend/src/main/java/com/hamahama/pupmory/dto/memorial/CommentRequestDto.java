package com.hamahama.pupmory.dto.memorial;

import com.hamahama.pupmory.domain.memorial.Comment;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/09/11
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class CommentRequestDto {
    private String content;

    public Comment toEntity(String uid, Long postId) {
        return Comment.builder()
                .userUid(uid)
                .postId(postId)
                .content(content)
                .build();
    }
}
