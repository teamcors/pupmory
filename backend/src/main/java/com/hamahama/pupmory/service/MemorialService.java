package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.memorial.*;
import com.hamahama.pupmory.domain.user.*;
import com.hamahama.pupmory.domain.user.ServiceUserRepository;
import com.hamahama.pupmory.dto.memorial.*;
import com.hamahama.pupmory.pojo.PostMeta;
import com.hamahama.pupmory.util.S3Uploader;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/09/11
 */

@Slf4j
@RequiredArgsConstructor
@Service
public class MemorialService {
    private final PostRepository postRepo;
    private final UserLikeRepository likeRepo;
    private final CommentRepository commentRepo;
    private final ServiceUserRepository userRepo;
    private final S3Uploader s3Uploader;

    @Transactional
    public PostDetailResponseDto getPost(Long id) {
        Post post = postRepo.findById(id).get();
        return PostDetailResponseDto.of(post);
    }

    @Transactional
    public PostAllResponseDto getAllPost(String uid) {
        List<Post> posts = postRepo.findAllByUserUid(uid);
        List<PostMeta> postMetas = new ArrayList<>();
        for (Post post : posts)
            postMetas.add(PostMeta.of(post));

        ServiceUser user = userRepo.findByUserUid(uid);

        return new PostAllResponseDto(user.getNickname(), user.getProfileImage(), user.getPuppyName(), user.getPuppyType(), user.getPuppyAge(), postMetas);
    }

    @Transactional
    public List<FeedPostResponseDto> getFeedByLatest(String uuid) {
        List<Post> posts = postRepo.findLatestFeed(uuid);
        List<FeedPostResponseDto> feeds = new ArrayList<>();

        for (Post post : posts) {
            ServiceUser user = userRepo.findByUserUid(post.getUserUid());
            FeedPostResponseDto dto = new FeedPostResponseDto(post.getId(), user.getNickname(), user.getProfileImage(), post.getImage(), post.getTitle(), post.getCreatedAt());
            feeds.add(dto);
        }

        return feeds;
    }

    @Transactional
    public List<FeedPostResponseDto> getFeedByFilter(String uuid, FeedPostFilterRequestDto fDto) {
        List<Post> posts = new ArrayList<>();
        if (fDto.getType() == null) posts = postRepo.findFilteredFeedByAge(uuid, fDto.getAge());
        else if (fDto.getAge() == null) posts = postRepo.findFilteredFeedByType(uuid, fDto.getType());
        else posts = postRepo.findFilteredFeedByBoth(uuid, fDto.getType(), fDto.getAge());

        List<FeedPostResponseDto> feeds = new ArrayList<>();

        for (Post post : posts) {
            ServiceUser user = userRepo.findByUserUid(post.getUserUid());
            FeedPostResponseDto dto = new FeedPostResponseDto(post.getId(), user.getNickname(), user.getProfileImage(), post.getImage(), post.getTitle(), post.getCreatedAt());
            feeds.add(dto);
        }

        return feeds;
    }

    @Transactional
    public void savePost(String uid, PostRequestDto dto, List<MultipartFile> mfiles) throws IOException {
        if (mfiles != null)
            for (MultipartFile mfile : mfiles)
                log.info("- image: " + mfile);

        List<String> fileUrlList = new ArrayList<String>();
        if (mfiles != null)
            fileUrlList = s3Uploader.upload(mfiles, "memorial", uid);

        postRepo.save(dto.toEntity(uid, fileUrlList));
    }

    @Transactional
    public boolean getLike(String uid, Long postId) {
        return likeRepo.findByUserUidAndPostId(uid, postId).isPresent();
    }

    @Transactional
    public void processLike(String uid, Long postId) {
        Optional<UserLike> like = likeRepo.findByUserUidAndPostId(uid, postId);
        
        if (like.isPresent()) { // 이미 좋아요 한 상태
            likeRepo.deleteByUserUidAndPostId(uid, postId);
        }
        else { // 좋아요 안한 상태
            likeRepo.save(
                    UserLike.builder()
                            .userUid(uid)
                            .postId(postId)
                            .build()
            );
        }
    }

    @Transactional
    public List<Comment> getComment(Long postId) { return commentRepo.findAllByPostId(postId); }

    @Transactional
    public void saveComment(String uid, Long postId, CommentRequestDto dto) {
        commentRepo.save(dto.toEntity(uid, postId));
    }
}
