package com.hamahama.pupmory.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Choice {
    private Message message;
    private Integer index;

    @JsonProperty("finish_reason")
    private String finishReason;
}

