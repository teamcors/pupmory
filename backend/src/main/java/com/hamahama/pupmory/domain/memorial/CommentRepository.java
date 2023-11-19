package com.hamahama.pupmory.domain.memorial;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findAllByPostId(Long postId);
    void deleteAllByUserUid(String userUid);
    void deleteAllByPostId(Long postId);
}
