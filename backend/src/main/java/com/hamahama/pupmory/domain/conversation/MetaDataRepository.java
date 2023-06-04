package com.hamahama.pupmory.domain.conversation;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

public interface MetaDataRepository extends JpaRepository<MetaData, MetaDataId> {
    @Query(value = "SELECT * FROM meta_data WHERE stage = :stage ;", nativeQuery = true)
    List<MetaData> findByAllMetaDataIdStage(@Param("stage") Long stage);

    @Query(value = "SELECT * FROM meta_data WHERE stage = :stage AND set != :set ;", nativeQuery = true)
    MetaData findByMetaDataStageAndMetaDataSetNot(@Param("stage") Long stage, @Param("set") Long set);
}
