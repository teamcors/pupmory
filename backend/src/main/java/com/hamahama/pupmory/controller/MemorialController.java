package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.domain.memorial.Comment;
import com.hamahama.pupmory.domain.memorial.UserLike;
import com.hamahama.pupmory.domain.memorial.Post;
import com.hamahama.pupmory.dto.memorial.*;
import com.hamahama.pupmory.service.MemorialService;
import lombok.RequiredArgsConstructor;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/09/11
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("memorial")
public class MemorialController {
    private final MemorialService memorialService;

    @RequestMapping(method=RequestMethod.POST, consumes = {"multipart/form-data"})
    public void savePost(@RequestHeader(value="Authorization") String uid,
                         @RequestPart("json") PostRequestDto dto,
                         @RequestPart("image") @Nullable List<MultipartFile> mfiles
    ) throws IOException {
        memorialService.savePost(uid, dto, mfiles);
    }

    @RequestMapping(method=RequestMethod.GET)
    public Optional<Post> getPost(@RequestHeader(value="Authorization") String uid, @RequestParam Long postId) {
        return memorialService.getPost(postId);
    }

    @GetMapping("/all")
    public PostAllResponseDto getAllPost(@RequestHeader(value="Authorization") String uid) {
        return memorialService.getAllPost(uid);
    }

    @PostMapping("/feed")
    public List<FeedPostResponseDto> getFeed(@RequestParam Boolean filter, @RequestHeader(value="Authorization") String uuid, @RequestBody(required=false) FeedPostFilterRequestDto dto) {
        if (filter)
            return memorialService.getFeedByFilter(uuid, dto);
        else
            return memorialService.getFeedByLatest(uuid);
    }

    @GetMapping("/like")
    public Optional<UserLike> getLike(@RequestHeader(value="Authorization") String uid, @RequestParam Long postId) {
        return memorialService.getLike(uid, postId);
    }

    @PostMapping("/like")
    public void saveLike(@RequestHeader(value="Authorization") String uid, @RequestParam Long postId) {
        memorialService.saveLike(uid, postId);
    }

    @GetMapping("/comment")
    public List<Comment> getComment(@RequestParam Long postId) {
        return memorialService.getComment(postId);
    }

    @PostMapping("/comment")
    public void saveComment(@RequestHeader(value="Authorization") String uid, @RequestParam Long postId, @RequestBody CommentRequestDto dto) {
        memorialService.saveComment(uid, postId, dto);
    }
}
