package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.memorial.*;
import com.hamahama.pupmory.domain.user.*;
import com.hamahama.pupmory.domain.user.ServiceUserRepository;
import com.hamahama.pupmory.dto.memorial.CommentRequestDto;
import com.hamahama.pupmory.dto.memorial.FeedPostResponseDto;
import com.hamahama.pupmory.dto.memorial.PostAllResponseDto;
import com.hamahama.pupmory.dto.memorial.PostRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/09/11
 */

@RequiredArgsConstructor
@Service
public class MemorialService {
    private final PostRepository postRepo;
    private final UserLikeRepository likeRepo;
    private final CommentRepository commentRepo;
    private final ServiceUserRepository userRepo;

    @Transactional
    public Optional<Post> getPost(Long id) {
        return postRepo.findById(id);
    }

    @Transactional
    public PostAllResponseDto getAllPost(String uid) {
        List<Post> posts = postRepo.findAllByUserUid(uid);
        ServiceUser user = userRepo.findByUserUid(uid);

        return new PostAllResponseDto(user.getNickname(), user.getProfileImage(), user.getPuppyName(), user.getPuppyType(), user.getPuppyAge(), posts);
    }

    @Transactional
    public List<FeedPostResponseDto> getFeedByLatest() {
        List<Post> posts = postRepo.findAllByOrderByCreatedAtDesc();
        List<FeedPostResponseDto> feeds = new ArrayList<FeedPostResponseDto>();

        for (Post post : posts) {
            ServiceUser user = userRepo.findByUserUid(post.getUserUid());
            FeedPostResponseDto dto = new FeedPostResponseDto(post.getId(), user.getNickname(), user.getProfileImage(), post.getImage(), post.getTitle());
            feeds.add(dto);
        }

        return feeds;
    }

    @Transactional
    public void savePost(String uid, PostRequestDto dto) {
        postRepo.save(dto.toEntity(uid));
    }

    @Transactional
    public Optional<UserLike> getLike(String uid, Long postId) { return likeRepo.findByUserUidAndPostId(uid, postId); }

    @Transactional
    public void saveLike(String uid, Long postId) {
        likeRepo.save(
                UserLike.builder()
                        .userUid(uid)
                        .postId(postId)
                        .build()
        );
    }

    @Transactional
    public List<Comment> getComment(Long postId) { return commentRepo.findAllByPostId(postId); }

    @Transactional
    public void saveComment(String uid, Long postId, CommentRequestDto dto) {
        commentRepo.save(dto.toEntity(uid, postId));
    }
}
