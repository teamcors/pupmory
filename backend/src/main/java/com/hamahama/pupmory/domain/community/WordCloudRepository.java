package com.hamahama.pupmory.domain.community;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * @author Queue-ri
 * @since 2023/10/20
 */

public interface WordCloudRepository extends JpaRepository<WordCloud, String> {
}
