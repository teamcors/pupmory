package com.hamahama.pupmory.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@AllArgsConstructor
@Getter
public class AnswerResponseDto {
    private List<String> answer;
}
