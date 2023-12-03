package com.hamahama.pupmory.domain.memorial;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id")
    private Long id;

    @Column(nullable = false)
    private String userUid;

    @Column(columnDefinition = "TEXT")
    private String image;

    @Column(nullable = false)
    private String title;

    private String date;

    private String place;

    private String content;

    private String hashtag;

    @Column(nullable = false)
    private boolean isPrivate;

    @CreatedDate
    private LocalDateTime createdAt;
}