package com.hamahama.pupmory.pojo;

import com.hamahama.pupmory.domain.memorial.Post;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

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
public class PostMeta {
    private Long id;
    private String image; // 대표 사진 1장
    private boolean isPrivate;

    public static PostMeta of(Post post) {
        List<String> imageList = Arrays.asList(post.getImage().split("\\s*,\\s*"));

        // https://stackoverflow.com/questions/42619986/lombok-annotation-getter-for-boolean-field
        return PostMeta.builder()
                .id(post.getId())
                .image(imageList.get(0))
                .isPrivate(post.isPrivate())
                .build();
    }
}
