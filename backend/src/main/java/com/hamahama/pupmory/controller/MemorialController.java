package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.domain.memorial.Comment;
import com.hamahama.pupmory.dto.memorial.*;
import com.hamahama.pupmory.service.MemorialService;
import com.hamahama.pupmory.util.auth.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/09/11
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("memorial")
public class MemorialController {
    private final MemorialService memorialService;
    private final JwtKit jwtKit;

    @RequestMapping(method=RequestMethod.POST, consumes = {"multipart/form-data"})
    public void savePost(@RequestHeader(value="Authorization") String token,
                         @RequestPart("json") PostRequestDto dto,
                         @RequestPart("image") @Nullable List<MultipartFile> mfiles
    ) throws IOException {
        String uid = jwtKit.validate(token);
        memorialService.savePost(uid, dto, mfiles);
    }

    @RequestMapping(method=RequestMethod.GET)
    public PostDetailResponseDto getPost(@RequestHeader(value="Authorization") String token, @RequestParam Long postId) {
        String uid = jwtKit.validate(token);
        return memorialService.getPost(postId);
    }

    @GetMapping("/all")
    public PostAllResponseDto getAllPost(@RequestHeader(value="Authorization") String token) {
        String uid = jwtKit.validate(token);
        return memorialService.getAllPost(uid);
    }

    @PostMapping("/feed")
    public List<FeedPostResponseDto> getFeed(@RequestParam Boolean filter, @RequestHeader(value="Authorization") String token, @RequestBody(required=false) FeedPostFilterRequestDto dto) {
        String uid = jwtKit.validate(token);
        if (filter)
            return memorialService.getFeedByFilter(uid, dto);
        else
            return memorialService.getFeedByLatest(uid);
    }

    @GetMapping("/like")
    public boolean getLike(@RequestHeader(value="Authorization") String token, @RequestParam Long postId) {
        String uid = jwtKit.validate(token);
        return memorialService.getLike(uid, postId);
    }

    @PostMapping("/like")
    public void processLike(@RequestHeader(value="Authorization") String token, @RequestParam Long postId) {
        String uid = jwtKit.validate(token);
        memorialService.processLike(uid, postId);
    }

    @GetMapping("/comment")
    public List<Comment> getComment(@RequestParam Long postId) {
        return memorialService.getComment(postId);
    }

    @PostMapping("/comment")
    public void saveComment(@RequestHeader(value="Authorization") String token, @RequestParam Long postId, @RequestBody CommentRequestDto dto) {
        String uid = jwtKit.validate(token);
        memorialService.saveComment(uid, postId, dto);
    }
}
