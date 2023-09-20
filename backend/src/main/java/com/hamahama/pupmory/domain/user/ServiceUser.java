package com.hamahama.pupmory.domain.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

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
@NoArgsConstructor
@AllArgsConstructor
public class ServiceUser {
    // User는 PostgreSQL에서 reserved keyword임에 유의
    @Id
    private String userUid;

    private String profileImage;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String nickname;

    private String puppyName;

    private String puppyType;

    private Integer puppyAge;

    @Column(nullable = false)
    private Long conversationStatus;

    // deprecated
    private String characterData;

    @Column(nullable = false)
    private Long memoryCount;
}
