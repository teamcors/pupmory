package com.hamahama.pupmory.domain.memorial;

import com.hamahama.pupmory.domain.user.ServiceUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findAllByPostId(Long postId);

    void deleteAllByUser(ServiceUser user);

    void deleteAllByPostId(Long postId);

    List<Comment> findAllByUser(ServiceUser user);
}