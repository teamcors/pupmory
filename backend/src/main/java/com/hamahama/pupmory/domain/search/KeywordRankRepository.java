package com.hamahama.pupmory.domain.search;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface KeywordRankRepository extends JpaRepository<KeywordRank, String> {
    List<KeywordRank> findTop10ByOrderByCountDescUpdatedAtDesc();
    KeywordRank findByKeyword(String keyword);
}
