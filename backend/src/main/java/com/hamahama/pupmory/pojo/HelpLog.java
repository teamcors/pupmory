package com.hamahama.pupmory.pojo;

import com.hamahama.pupmory.domain.community.Help;
import com.hamahama.pupmory.domain.memorial.Post;
import com.hamahama.pupmory.domain.user.ServiceUser;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Arrays;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/10/27
 */

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class HelpLog {
    private String userUid;
    private String nickname;
    private String profileImage;

    public static HelpLog of(ServiceUser user) {

        return HelpLog.builder()
                .userUid(user.getUserUid())
                .nickname(user.getNickname())
                .profileImage(user.getProfileImage())
                .build();
    }
}
