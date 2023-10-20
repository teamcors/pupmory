package com.hamahama.pupmory.dto.community;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/10/20
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class WordCloudRequestDto {
    @JsonProperty("prev_list")
    private String prevList;

    private String sentence;
}
