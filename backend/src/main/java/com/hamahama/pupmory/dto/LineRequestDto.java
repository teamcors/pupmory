package com.hamahama.pupmory.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/06/16
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class LineRequestDto {
    private Long stage;
    private Long set;
    private Long lineId;
    private Long selected;
}
