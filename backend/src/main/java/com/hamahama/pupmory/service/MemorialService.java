package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.memorial.*;
import com.hamahama.pupmory.dto.memorial.CommentRequestDto;
import com.hamahama.pupmory.dto.memorial.PostRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Transactional
    public Optional<Post> getPost(Long id) {
        return postRepo.findById(id);
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
