package com.hamahama.pupmory.domain.conversation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class MetaData {
    @EmbeddedId
    private MetaDataId metaDataId;

    @Column(nullable = false)
    private String setName;

    @Column(nullable = false)
    private Long totalLine;
}
