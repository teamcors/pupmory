package com.hamahama.pupmory.dto.memorial;

import com.hamahama.pupmory.domain.memorial.Post;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/10/20
 */

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class PostDetailResponseDto {
    private Long id;
    private String userUid; // feed 에서 타 유저 정보 주는 것으로 수정해야 함
    private List<String> imageList;
    private String title;
    private String date;
    private String place;
    private String content;
    private String hashtag;
    private boolean isPrivate;
    private LocalDateTime createdAt;

    public static PostDetailResponseDto of(Post post) {
        List<String> imageList = Arrays.asList(post.getImage().split("\\s*,\\s*"));

        // https://stackoverflow.com/questions/42619986/lombok-annotation-getter-for-boolean-field
        return PostDetailResponseDto.builder()
                .id(post.getId())
                .userUid(post.getUserUid())
                .imageList(imageList)
                .title(post.getTitle())
                .date(post.getDate())
                .place(post.getPlace())
                .content(post.getContent())
                .hashtag(post.getHashtag())
                .isPrivate(post.isPrivate())
                .createdAt(post.getCreatedAt())
                .build();
    }
}
