package com.hamahama.pupmory.dto.memorial;

import com.hamahama.pupmory.domain.memorial.Post;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;

/**
 * @author Queue-ri
 * @since 2023/09/11
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class PostRequestDto {
    private String title;
    private String date;
    private String place;
    private String content;
    private String hashtag;
    private boolean isPrivate;

    public Post toEntity(String uid) {
        return Post.builder()
                .userUid(uid)
                .title(title)
                .place(place)
                .content(content)
                .hashtag(hashtag)
                .isPrivate(isPrivate)
                .build();
    }
}
