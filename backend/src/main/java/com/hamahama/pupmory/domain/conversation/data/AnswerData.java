package com.hamahama.pupmory.domain.conversation.data;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class AnswerData {
    @EmbeddedId
    private AnswerDataId dataId;

    private Long selection;

    @Column(nullable = false, columnDefinition="BOOLEAN DEFAULT false")
    private Boolean isGptRequired;

    private String answer;
}
