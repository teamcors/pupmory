package com.hamahama.pupmory.domain.community;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/10/11
 */

public interface HelpRepository extends JpaRepository<Help, Long> {
    List<Help> findAllByFromUserUid(@Param("fromUserUid") String uid);
    List<Help> findAllByToUserUid(@Param("toUserUid") String uid);

    @Query("SELECT COUNT(*) FROM Help h WHERE h.toUserUid = :toUserUid AND h.answer IS NOT NULL")
    Long countAllToUserAnswer(@Param("toUserUid") String uid);

    @Query("SELECT DISTINCT h.fromUserUid FROM Help h WHERE h.toUserUid = :toUserUid AND h.answer IS NOT NULL")
    List<String> findDistinctFromUser(@Param("toUserUid") String uid);

    @Modifying
    @Query("DELETE FROM Help h WHERE h.fromUserUid = :uid OR h.toUserUid = :uid")
    void deleteAllByUserUid(@Param("uid") String userUid);
}
