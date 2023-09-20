package com.hamahama.pupmory.domain.memorial;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {
    List<Post> findAllByUserUid(String uuid);

    @Query("SELECT p FROM Post p WHERE p.userUid <> :userUid AND p.isPrivate = false ORDER BY p.createdAt DESC")
    List<Post> findLatestFeed(@Param("userUid") String uuid);

    // 피드 필터 조회
    @Query(value = "SELECT *\n" +
            "FROM post\n" +
            "    INNER JOIN service_user\n" +
            "    ON post.user_uid = service_user.user_uid\n" +
            "WHERE post.user_uid != :userUid AND puppy_type = :puppyType AND is_private = false\n" +
            "ORDER BY created_at DESC;", nativeQuery = true)
    List<Post> findFilteredFeedByType(@Param("userUid") String uuid, @Param("puppyType") String type);

    @Query(value = "SELECT *\n" +
            "FROM post\n" +
            "    INNER JOIN service_user\n" +
            "    ON post.user_uid = service_user.user_uid\n" +
            "WHERE post.user_uid != :userUid AND puppy_age = :puppyAge AND is_private = false\n" +
            "ORDER BY created_at DESC;", nativeQuery = true)
    List<Post> findFilteredFeedByAge(@Param("userUid") String uuid, @Param("puppyAge") Integer age);

    @Query(value = "SELECT *\n" +
            "FROM post\n" +
            "    INNER JOIN service_user\n" +
            "    ON post.user_uid = service_user.user_uid\n" +
            "WHERE post.user_uid != :userUid AND puppy_type = :puppyType AND puppy_age = :puppyAge AND is_private = false\n" +
            "ORDER BY created_at DESC;", nativeQuery = true)
    List<Post> findFilteredFeedByBoth(@Param("userUid") String uuid, @Param("puppyType") String type, @Param("puppyAge") Integer age);
}
