package com.hamahama.pupmory.dto.search;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * @author Queue-ri
 * @since 2023/09/24
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class SearchHistoryResponseDto {
    private String keyword;
    private LocalDateTime updatedAt;
}
