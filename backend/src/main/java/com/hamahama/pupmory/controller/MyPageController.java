package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.conf.NoAuth;
import com.hamahama.pupmory.dto.mypage.AnnouncementMetaDto;
import com.hamahama.pupmory.dto.mypage.CommentMetaDto;
import com.hamahama.pupmory.service.MyPageService;
import com.hamahama.pupmory.util.auth.JwtKit;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/11/18
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("mypage")
public class MyPageController {
    private final MyPageService myPageService;

    @GetMapping("/announcement/all")
    @NoAuth
    public List<AnnouncementMetaDto> getAllAnnouncementMeta() {
        return myPageService.getAllAnnouncementMeta();
    }

    @GetMapping("/announcement")
    @NoAuth
    public ResponseEntity<?> getAnnouncementDetail(@RequestParam Long aid) {
        return myPageService.getAnnouncementDetail(aid);
    }

    @GetMapping("/comment/all")
    public List<CommentMetaDto> getAllCommentMeta(@RequestAttribute("uid") String uid) {
        return myPageService.getAllCommentMeta(uid);
    }
}
