package com.hamahama.pupmory.domain.community;

import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;

/**
 * @author Queue-ri
 * @since 2023/10/20
 */

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@DynamicInsert // default 값 설정에 필요한 어노테이션
public class WordCloud {
    @Id
    private String userUid;

    @Column(nullable = false, columnDefinition = "TEXT")
    @ColumnDefault("'[]'")
    private String words; // refactor later
}
