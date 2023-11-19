package com.hamahama.pupmory.dto.mypage;

import com.hamahama.pupmory.domain.mypage.Announcement;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/11/18
 */

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class AnnouncementDetailDto {
    private Long id;
    private String title;
    private String content;

    public static AnnouncementDetailDto of (Announcement announcement) {
        return AnnouncementDetailDto.builder()
                .id(announcement.getId())
                .title(announcement.getTitle())
                .content(announcement.getContent())
                .build();
    }
}
