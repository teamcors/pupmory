package com.hamahama.pupmory.domain.memorial;

import com.hamahama.pupmory.domain.user.ServiceUser;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class CommentRepositoryImpl implements CommentRepositoryCustom {

    private final JPAQueryFactory queryFactory;

    public List<Comment> findAllByUser(ServiceUser user) {
        QComment comment = QComment.comment;
        QPost post = QPost.post;

        return queryFactory.selectFrom(comment)
                .leftJoin(comment.post, post)
                .fetchJoin()
                .where(comment.user.eq(user))
                .fetch();
    }
}