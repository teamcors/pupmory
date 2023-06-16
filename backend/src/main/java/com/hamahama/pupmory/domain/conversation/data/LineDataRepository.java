package com.hamahama.pupmory.domain.conversation.data;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/06/16
 */

public interface LineDataRepository extends JpaRepository<LineData, LineDataId> {
    @Query(value = "SELECT * FROM line_data WHERE stage = :stage AND set = :set AND line_id = :id AND selected = :selected ORDER BY \"order\" ASC;", nativeQuery = true)
    List<LineData> findAll(@Param("stage") Long stage, @Param("set") Long set, @Param("id") Long lineId, @Param("selected") Long selected);
}
