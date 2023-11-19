package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.dto.mypage.AnnouncementMetaDto;
import com.hamahama.pupmory.service.MyPageService;
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
    public List<AnnouncementMetaDto> getAllAnnouncementMeta() {
        return myPageService.getAllAnnouncementMeta();
    }

    @GetMapping("/announcement")
    public ResponseEntity<?> getAnnouncementDetail(@RequestParam Long aid) {
        return myPageService.getAnnouncementDetail(aid);
    }
}
