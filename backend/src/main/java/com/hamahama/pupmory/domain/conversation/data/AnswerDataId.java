package com.hamahama.pupmory.domain.conversation.data;

import lombok.AllArgsConstructor;
import lombok.Data;

import javax.persistence.Embeddable;
import java.io.Serializable;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Data
@Embeddable
public class AnswerDataId implements Serializable {
    private Long stage;
    private Long set;
    private Long questionId;
}
