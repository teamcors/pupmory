package com.hamahama.pupmory.domain.memorial;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserLikeRepository extends JpaRepository<UserLike, Long> {
    Optional<UserLike> findByUserUidAndPostId(String userUid, Long postId);
    void deleteByUserUidAndPostId(String userUid, Long postId);
}
