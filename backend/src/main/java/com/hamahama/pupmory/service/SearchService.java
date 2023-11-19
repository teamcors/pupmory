package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.memorial.Post;
import com.hamahama.pupmory.domain.memorial.PostRepository;
import com.hamahama.pupmory.domain.search.KeywordRank;
import com.hamahama.pupmory.domain.search.KeywordRankRepository;
import com.hamahama.pupmory.domain.search.SearchHistory;
import com.hamahama.pupmory.domain.search.SearchHistoryRepository;
import com.hamahama.pupmory.domain.user.ServiceUser;
import com.hamahama.pupmory.domain.user.ServiceUserRepository;
import com.hamahama.pupmory.dto.memorial.FeedPostResponseDto;
import com.hamahama.pupmory.dto.search.SearchHistoryResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/09/24
 */

@RequiredArgsConstructor
@Service
public class SearchService {
    private final SearchHistoryRepository historyRepo;
    private final KeywordRankRepository rankRepo;
    private final PostRepository postRepo;
    private final ServiceUserRepository userRepo;

    @Transactional
    public List<FeedPostResponseDto> getSearchResult(String keyword) {
        List<Post> posts = postRepo.findByTitleContainingOrContentContaining(keyword, keyword);
        List<FeedPostResponseDto> feeds = new ArrayList<>();

        for (Post post : posts) {
            ServiceUser user = userRepo.findByUserUid(post.getUserUid());
            FeedPostResponseDto dto = new FeedPostResponseDto(post.getId(), post.getUserUid(), user.getNickname(), user.getProfileImage(), post.getImage(), post.getTitle(), post.getCreatedAt());
            feeds.add(dto);
        }

        return feeds;
    }

    @Transactional
    public List<SearchHistoryResponseDto> getSearchHistory(String uid) {
        List<SearchHistory> result = historyRepo.findTop10ByUserUidOrderByUpdatedAtDesc(uid);
        List<SearchHistoryResponseDto> response = new ArrayList<>();

        for (SearchHistory history : result)
            response.add(new SearchHistoryResponseDto(history.getKeyword(), history.getUpdatedAt()));

        return response;
    }

    @Transactional
    public void saveSearchHistory(String uid, String keyword) {
        SearchHistory history = historyRepo.findOneByUserUidAndKeyword(uid, keyword);

        if (history == null)
            historyRepo.save(
                    SearchHistory.builder()
                            .userUid(uid)
                            .keyword(keyword)
                            .build()
            );
        else {
            history.setUpdatedAt(LocalDateTime.now());
            historyRepo.save(history);
        }
    }

    @Transactional
    public void deleteSearchHistory(String uid, String keyword) {
        SearchHistory history = historyRepo.findSearchHistoryByUserUidAndKeyword(uid, keyword);
        if (history != null) {
            if (history.getUserUid().equals(uid)) {
                historyRepo.deleteByUserUidAndKeyword(uid, keyword);
            }
            else {
                // 4xx error
            }
        }
        else {
            // 4xx error
        }
    }

    @Transactional
    public void deleteAllSearchHistory(String uid) {
        historyRepo.deleteAllByUserUid(uid);
    }

    @Transactional
    public List<KeywordRank> getKeywordRank() {
        return rankRepo.findTop10ByOrderByCountDescUpdatedAtDesc();
    }

    @Transactional
    public void saveKeywordRank(String keyword) {
        List<String> keywords = Arrays.asList(keyword.split(" "));

        for (String k : keywords) {
            KeywordRank rankData = rankRepo.findByKeyword(k);
            if (rankData != null) {
                rankData.setCount(rankData.getCount() + 1);
                rankRepo.save(rankData);
            }
            else
                rankRepo.save(
                        KeywordRank.builder()
                                .keyword(k)
                                .count(1L)
                                .build()
                );
        }
    }
}
