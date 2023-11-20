package com.hamahama.pupmory.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class AnswerRequestDto {
    private String uuid;
    private Long stage;
    private Long set;
    private Long lineId;
    private String userAnswer;
}
