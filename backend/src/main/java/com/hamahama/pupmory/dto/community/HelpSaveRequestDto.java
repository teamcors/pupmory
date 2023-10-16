package com.hamahama.pupmory.dto.community;

import com.hamahama.pupmory.domain.community.Help;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * @author Queue-ri
 * @since 2023/10/11
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class HelpSaveRequestDto {
    private String toUserUid;
    private String title;
    private String content;

    public Help toEntity(String fromUserUid) {
        return Help.builder()
                .toUserUid(toUserUid)
                .fromUserUid(fromUserUid)
                .title(title)
                .content(content)
                .build();
    }
}
