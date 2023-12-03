package com.hamahama.pupmory.domain.memorial;

import com.hamahama.pupmory.domain.user.ServiceUser;

import java.util.List;

public interface CommentRepositoryCustom {
    List<Comment> findAllByUser(ServiceUser user);
}