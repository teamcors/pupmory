package com.hamahama.pupmory.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.hamahama.pupmory.domain.conversation.data.LineData;

import lombok.Getter;

/**
 * @author Queue-ri
 * @since 2023/06/16
 */

@Getter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class LineResponseDto {
    private Long order;
    private String content;
    private String type;
    private String[] selectList; // 임시
    private String buttonText;
    private String placeholder;

    public LineResponseDto(LineData data) {
        order = data.getDataId().getOrder();
        content = data.getContent();
        type = data.getType();
        selectList = data.getSelectList();
        buttonText = data.getButtonText();
        placeholder = data.getPlaceholder();
    }
}
