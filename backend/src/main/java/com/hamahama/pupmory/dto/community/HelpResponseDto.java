package com.hamahama.pupmory.dto.community;

import com.hamahama.pupmory.domain.community.Help;
import com.hamahama.pupmory.domain.user.ServiceUser;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * @author Queue-ri
 * @since 2023/10/29
 */

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class HelpResponseDto {
    private Long id;
    private String fromUserUid;
    private String fromUserNickname;
    private String fromUserProfileImage;
    private String toUserUid;
    private String toUserNickname;
    private String toUserProfileImage;
    private Integer isFromUserReadAnswer;
    private LocalDateTime createdAt;
    private LocalDateTime answeredAt;

    public static HelpResponseDto of(Help help, ServiceUser fromUser, ServiceUser toUser) {
        return HelpResponseDto.builder()
                .id(help.getId())
                .fromUserUid(help.getFromUserUid())
                .fromUserNickname(fromUser.getNickname())
                .fromUserProfileImage(fromUser.getProfileImage())
                .toUserUid(help.getToUserUid())
                .toUserNickname(toUser.getNickname())
                .toUserProfileImage(toUser.getProfileImage())
                .isFromUserReadAnswer(help.getIsFromUserReadAnswer())
                .createdAt(help.getCreatedAt())
                .answeredAt(help.getAnsweredAt())
                .build();
    }
}
