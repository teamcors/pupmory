package com.hamahama.pupmory.domain.search;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SearchHistoryRepository extends JpaRepository<SearchHistory, Long> {
    List<SearchHistory> findTop10ByUserUidOrderByUpdatedAtDesc(@Param("userUid") String uuid);
    SearchHistory findOneByUserUidAndKeyword(@Param("userUid") String uuid, @Param("keyword") String keyword);
    void deleteByUserUidAndKeyword(@Param("userUid") String uuid, @Param("keyword") String keyword);
    SearchHistory findSearchHistoryByUserUidAndKeyword(@Param("userUid") String uuid, @Param("keyword") String keyword);
}
