package com.hamahama.pupmory.domain.search;

import lombok.*;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * @author Queue-ri
 * @since 2023/09/24
 */

@Entity
@EntityListeners(AuditingEntityListener.class)
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class KeywordRank {
    @Id
    private String keyword;

    private Long count;

    @LastModifiedDate
    private LocalDateTime updatedAt;
}
