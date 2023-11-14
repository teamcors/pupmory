package com.hamahama.pupmory.domain.conversation.data;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * @author Queue-ri
 * @since 2023/11/14
 */

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class GptEmotionData {
    @Id
    private Long id;

    @Column(nullable = false)
    private Long stage;

    @Column(nullable = false)
    private Long set;

    @Column(nullable = false)
    private String emotion;
}
