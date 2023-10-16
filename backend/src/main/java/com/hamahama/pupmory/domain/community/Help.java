package com.hamahama.pupmory.domain.community;

import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * @author Queue-ri
 * @since 2023/10/11
 */

@Entity
@EntityListeners(AuditingEntityListener.class)
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@DynamicInsert // default 값 설정에 필요한 어노테이션
public class Help {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String fromUserUid;

    @Column(nullable = false)
    private String toUserUid;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String content;

    private String answer;

    @ColumnDefault("false")
    private Boolean isFromUserReadAnswer;

    @CreatedDate
    private LocalDateTime createdAt;

    private LocalDateTime answeredAt;
}
