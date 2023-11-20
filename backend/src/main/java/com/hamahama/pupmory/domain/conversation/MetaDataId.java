package com.hamahama.pupmory.domain.conversation;

import lombok.Data;

import javax.persistence.Embeddable;
import java.io.Serializable;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Data
@Embeddable
public class MetaDataId implements Serializable {
    private Long stage;
    private Long set;
}
