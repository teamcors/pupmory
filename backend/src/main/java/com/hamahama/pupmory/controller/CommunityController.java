package com.hamahama.pupmory.controller;

import com.hamahama.pupmory.domain.community.Help;
import com.hamahama.pupmory.dto.community.HelpAnswerSaveRequestDto;
import com.hamahama.pupmory.dto.community.HelpSaveRequestDto;
import com.hamahama.pupmory.service.CommunityService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/10/11
 */

@RequiredArgsConstructor
@RestController
@RequestMapping("community")
public class CommunityController {
    private final CommunityService communityService;

    @PostMapping("/help")
    public void saveHelp(@RequestHeader(value="Authorization") String uid, @RequestBody HelpSaveRequestDto dto) {
        communityService.saveHelp(uid, dto);
    }

    @GetMapping("/help")
    public Help getHelp(@RequestHeader(value="Authorization") String uid, @RequestParam Long hid) {
        return communityService.getHelp(uid, hid);
    }

    @GetMapping("/help/all")
    public List<Help> getAllHelp(@RequestHeader(value="Authorization") String uid, @RequestParam String type) {
        return communityService.getAllHelp(uid, type);
    }

    @PostMapping("/answer")
    public void saveHelpAnswer(@RequestHeader(value="Authorization") String uid, @RequestBody HelpAnswerSaveRequestDto dto) {
        communityService.saveHelpAnswer(uid, dto);
    }
}
