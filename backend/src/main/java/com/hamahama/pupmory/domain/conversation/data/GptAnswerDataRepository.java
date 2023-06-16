package com.hamahama.pupmory.domain.conversation.data;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

public interface GptAnswerDataRepository extends JpaRepository<GptAnswerData, Long> {
    //@Query(value = "SELECT * FROM answer_data WHERE stage = :stage AND set = :set AND question_id = :qid ;", nativeQuery = true)
    List<GptAnswerData> findAllByStageAndSetAndQuestionId(Long stage, Long set, Long questionId);
}
