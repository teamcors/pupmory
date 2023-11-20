package com.hamahama.pupmory.dto.community;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/10/11
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class HelpAnswerSaveRequestDto {
    private Long helpId;
    private String content;
}
