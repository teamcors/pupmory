package com.hamahama.pupmory.domain.community;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/10/11
 */

public interface HelpRepository extends JpaRepository<Help, Long> {
    List<Help> findAllByFromUserUid(@Param("fromUserUid") String uid);
    List<Help> findAllByToUserUid(@Param("toUserUid") String uid);
}
