package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.conf.NoAuth;
import com.hamahama.pupmory.domain.memorial.Comment;
import com.hamahama.pupmory.dto.memorial.*;
import com.hamahama.pupmory.service.MemorialService;
import com.hamahama.pupmory.util.auth.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
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

    @RequestMapping(method=RequestMethod.POST, consumes = {"multipart/form-data"})
    public void savePost(@RequestAttribute("uid") String uid,
                         @RequestPart("json") PostRequestDto dto,
                         @RequestPart("image") @Nullable List<MultipartFile> mfiles
    ) throws IOException {
        memorialService.savePost(uid, dto, mfiles);
    }

    @RequestMapping(method=RequestMethod.GET)
    public PostDetailResponseDto getPost(@RequestAttribute("uid") String uid, @RequestParam Long postId) {
        // uid를 필요로 하진 않지만 validate해야 함
        return memorialService.getPost(postId);
    }

    @RequestMapping(method=RequestMethod.DELETE)
    public ResponseEntity<?> deletePost(@RequestAttribute("uid") String uid, @RequestParam Long postId) {
        return memorialService.deletePost(uid, postId);
    }

    @GetMapping("/all")
    public PostAllResponseDto getAllPost(@RequestAttribute("uid") String uid) {
        return memorialService.getAllPost(uid);
    }

    @GetMapping("guest/all")
    public PostAllResponseDto getOthersAllPost(@RequestParam String targetUid) {
        // uid를 필요로 하진 않지만 validate해야 함
        return memorialService.getOthersAllPost(targetUid);
    }

    @PostMapping("/feed")
    public List<FeedPostResponseDto> getFeed(@RequestParam Boolean filter, @RequestAttribute("uid") String uid, @RequestBody(required=false) FeedPostFilterRequestDto dto) {
        if (filter)
            return memorialService.getFeedByFilter(uid, dto);
        else
            return memorialService.getFeedByLatest(uid);
    }

    @GetMapping("/like")
    public boolean getLike(@RequestAttribute("uid") String uid, @RequestParam Long postId) {
        return memorialService.getLike(uid, postId);
    }

    @PostMapping("/like")
    public void processLike(@RequestAttribute("uid") String uid, @RequestParam Long postId) {
        memorialService.processLike(uid, postId);
    }

    @GetMapping("/comment")
    @NoAuth
    public List<CommentResponseDto> getComment(@RequestParam Long postId) {
        return memorialService.getComment(postId);
    }

    @PostMapping("/comment")
    public void saveComment(@RequestAttribute("uid") String uid, @RequestParam Long postId, @RequestBody CommentRequestDto dto) {
        memorialService.saveComment(uid, postId, dto);
    }

    @DeleteMapping("/comment")
    public ResponseEntity<?> deleteComment(@RequestAttribute("uid") String uid, @RequestParam Long commentId) {
        return memorialService.deleteComment(uid, commentId);
    }
}
