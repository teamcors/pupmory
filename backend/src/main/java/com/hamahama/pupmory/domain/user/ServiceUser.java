package com.hamahama.pupmory.domain.user;

import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityListeners;
import javax.persistence.Id;
import java.time.LocalDate;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Entity
@EntityListeners(AuditingEntityListener.class)
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@DynamicInsert // default 값 설정에 필요한 어노테이션
public class ServiceUser {
    // User는 PostgreSQL에서 reserved keyword임에 유의
    @Id
    private String userUid;

    private String profileImage;

    @Column(nullable = false)
    private String email;

    private String nickname;

    private String puppyName;

    private String puppyType;

    private Integer puppyAge;

    @ColumnDefault("0")
    private String conversationStatus;

    private String nextConversationAt;

    @CreatedDate
    private LocalDate registrationDate;
}
