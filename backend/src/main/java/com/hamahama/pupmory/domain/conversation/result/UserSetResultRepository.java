package com.hamahama.pupmory.domain.conversation.result;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

public interface UserSetResultRepository extends JpaRepository<UserSetResult, SetResultId> {
    @Query(value = "SELECT * FROM user_set_result WHERE user_uid = :uuid ORDER BY stage DESC LIMIT 2;", nativeQuery = true)
    List<UserSetResult> getLastTwoSet(@Param("uuid") String uuid);
}
