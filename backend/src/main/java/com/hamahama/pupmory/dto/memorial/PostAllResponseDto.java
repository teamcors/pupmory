package com.hamahama.pupmory.dto.memorial;

import com.hamahama.pupmory.pojo.PostMeta;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/09/19
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class PostAllResponseDto {
    private String nickname;
    private String profileImage;
    private String puppyName;
    private String puppyType;
    private Integer puppyAge;
    private List<PostMeta> posts;
}
