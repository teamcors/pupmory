package com.hamahama.pupmory.domain.memorial;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {
    List<Post> findAllByUserUid(String uuid);
    List<Post> findAllByOrderByCreatedAtDesc();
}
