package com.hamahama.pupmory.domain.user;

import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Entity
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
    private Integer conversationStatus;

    @ColumnDefault("0")
    private Integer helpCount;

    // deprecated
    @ColumnDefault("1")
    private Integer memoryCount;
}
