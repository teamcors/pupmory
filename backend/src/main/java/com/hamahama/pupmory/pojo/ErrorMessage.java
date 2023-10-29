package com.hamahama.pupmory.pojo;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * @author Queue-ri
 * @since 2023/10/20
 */

@AllArgsConstructor
@Getter
public class ErrorMessage {
    private Integer errorCode;
    private String errorMessage;
}
