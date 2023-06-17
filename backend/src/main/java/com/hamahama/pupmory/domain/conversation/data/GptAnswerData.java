package com.hamahama.pupmory.domain.conversation.data;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class GptAnswerData {
    @Id
    private Long gptAnswerDataId;

    @Column(nullable = false)
    private Long lineId;

    @Column(nullable = false)
    private Long stage;

    @Column(nullable = false)
    private Long set;

    @Column(nullable = false)
    private String emotion;

    @Column(nullable = false)
    private String template;
}
