package com.hamahama.pupmory.domain.conversation.result;

import lombok.Data;

import javax.persistence.Embeddable;
import java.io.Serializable;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Data
@Embeddable
public class SetResultId implements Serializable {
    private String userUid;
    private Long stage;
    private Long set;
}
