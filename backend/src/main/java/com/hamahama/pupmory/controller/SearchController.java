package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.conf.NoAuth;
import com.hamahama.pupmory.domain.search.KeywordRank;
import com.hamahama.pupmory.dto.memorial.FeedPostResponseDto;
import com.hamahama.pupmory.dto.search.SearchHistoryResponseDto;
import com.hamahama.pupmory.service.SearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author Queue-ri
 * @author becky
 * @author hyojeongchoi
 * @author nusuy
 * @since 2023/09/24
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("search")
public class SearchController {
    private final SearchService searchService;

    @RequestMapping(method = RequestMethod.GET)
    public List<FeedPostResponseDto> getSearchResult(@RequestAttribute("uid") String uid, @RequestParam String keyword) {
        // 히스토리 저장
        searchService.saveSearchHistory(uid, keyword);

        // 추천 검색어 통계 반영
        searchService.saveKeywordRank(keyword);

        // 검색 결과 반환
        return searchService.getSearchResult(keyword);
    }

    @GetMapping("history")
    public List<SearchHistoryResponseDto> getSearchHistory(@RequestAttribute("uid") String uid) {
        return searchService.getSearchHistory(uid);
    }

    @GetMapping("rank")
    @NoAuth
    public List<KeywordRank> getKeywordRank() {
        return searchService.getKeywordRank();
    }

    @DeleteMapping("history")
    public void deleteSearchHistory(@RequestAttribute("uid") String uid, @RequestParam String keyword) {
        searchService.deleteSearchHistory(uid, keyword);
    }

    @DeleteMapping("history/all")
    public void deleteSearchHistory(@RequestAttribute("uid") String uid) {
        searchService.deleteAllSearchHistory(uid);
    }

}
