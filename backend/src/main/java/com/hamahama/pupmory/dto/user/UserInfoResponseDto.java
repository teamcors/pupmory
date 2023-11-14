package com.hamahama.pupmory.dto.user;

import com.hamahama.pupmory.domain.user.ServiceUser;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.data.annotation.CreatedDate;

import javax.persistence.Column;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * @author Queue-ri
 * @since 2023/11/11
 */

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class UserInfoResponseDto {
    private String userUid;
    private String profileImage;
    private String email;
    private String nickname;
    private String puppyName;
    private String puppyType;
    private Integer puppyAge;
    private String conversationStatus;
    private String nextConversationAt;
    private Long helpCount;
    private Long memoryCount;

    public static UserInfoResponseDto of(ServiceUser user, Long helpCount) {
        return UserInfoResponseDto.builder()
                .userUid(user.getUserUid())
                .profileImage(user.getProfileImage())
                .email(user.getEmail())
                .nickname(user.getNickname())
                .puppyName(user.getPuppyName())
                .puppyType(user.getPuppyType())
                .puppyAge(user.getPuppyAge())
                .conversationStatus(user.getConversationStatus())
                .nextConversationAt(user.getNextConversationAt())
                .helpCount(helpCount)
                .memoryCount(ChronoUnit.DAYS.between(user.getRegistrationDate(), LocalDate.now()) + 1)
                .build();
    }
}
