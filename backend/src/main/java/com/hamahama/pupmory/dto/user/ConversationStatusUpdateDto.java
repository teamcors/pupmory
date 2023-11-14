package com.hamahama.pupmory.dto.user;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/11/11
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class ConversationStatusUpdateDto {
    private String conversationStatus;
    private String nextConversationAt;
}
