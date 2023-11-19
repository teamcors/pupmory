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
public class AnnouncementMetaDto {
    private Long id;
    private String metaContent;

    public static AnnouncementMetaDto of (Announcement announcement) {
        return AnnouncementMetaDto.builder()
                .id(announcement.getId())
                .metaContent(announcement.getMetaContent())
                .build();
    }
}
