package com.hamahama.pupmory.domain.conversation.data;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/11/14
 */

public interface GptEmotionDataRepository extends JpaRepository<GptEmotionData, Long> {
    List<GptEmotionData> findAllByStageAndSet(Long stage, Long set);
}
