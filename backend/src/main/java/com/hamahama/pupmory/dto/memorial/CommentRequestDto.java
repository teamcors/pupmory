package com.hamahama.pupmory.dto.memorial;

import com.hamahama.pupmory.domain.memorial.Comment;
import com.hamahama.pupmory.domain.user.ServiceUser;
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

    public Comment toEntity(ServiceUser user) {
        return Comment.builder()
                .user(user)
                .content(content)
                .build();
    }
}