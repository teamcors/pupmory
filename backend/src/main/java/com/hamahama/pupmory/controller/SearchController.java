package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.domain.memorial.Post;
import com.hamahama.pupmory.domain.search.KeywordRank;
import com.hamahama.pupmory.dto.memorial.FeedPostResponseDto;
import com.hamahama.pupmory.dto.search.SearchHistoryResponseDto;
import com.hamahama.pupmory.service.SearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/09/24
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("search")
public class SearchController {
    private final SearchService searchService;

    @RequestMapping(method = RequestMethod.GET)
    public List<FeedPostResponseDto> getSearchResult(@RequestHeader(value="Authorization") String uid, @RequestParam String keyword) {
        // 히스토리 저장
        searchService.saveSearchHistory(uid, keyword);

        // 추천 검색어 통계 반영
        searchService.saveKeywordRank(keyword);

        // 검색 결과 반환
        return searchService.getSearchResult(keyword);
    }

    @GetMapping("history")
    public List<SearchHistoryResponseDto> getSearchHistory(@RequestHeader(value="Authorization") String uid) {
        return searchService.getSearchHistory(uid);
    }

    @GetMapping("rank")
    public List<KeywordRank> getKeywordRank() {
        return searchService.getKeywordRank();
    }

}
