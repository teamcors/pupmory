package com.hamahama.pupmory.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.hamahama.pupmory.domain.community.Help;
import com.hamahama.pupmory.dto.community.HelpAnswerSaveRequestDto;
import com.hamahama.pupmory.dto.community.HelpResponseDto;
import com.hamahama.pupmory.dto.community.HelpSaveRequestDto;
import com.hamahama.pupmory.dto.community.WordCloudRequestDto;
import com.hamahama.pupmory.pojo.HelpLog;
import com.hamahama.pupmory.pojo.WordCount;
import com.hamahama.pupmory.service.CommunityService;
import com.hamahama.pupmory.util.auth.JwtKit;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/10/11
 */

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("community")
public class CommunityController {
    private final CommunityService communityService;

    @PostMapping("/help")
    public void saveHelp(@RequestAttribute("uid") String uid, @RequestBody HelpSaveRequestDto dto) {
        communityService.saveHelp(uid, dto);
    }

    @GetMapping("/help")
    public Help getHelp(@RequestAttribute("uid") String uid, @RequestParam Long hid) {
        return communityService.getHelp(uid, hid);
    }

    @GetMapping("/help/all")
    public List<HelpResponseDto> getAllHelp(@RequestAttribute("uid") String uid, @RequestParam String type) {
        return communityService.getAllHelp(uid, type);
    }

    @GetMapping("/help/log")
    public List<HelpLog> getHelpLog(@RequestAttribute("uid") String uid, @RequestParam String targetUid) {
        return communityService.getHelpLog(targetUid);
    }

    @PostMapping("/answer")
    public void saveHelpAnswer(@RequestAttribute("uid") String uid, @RequestBody HelpAnswerSaveRequestDto dto) throws IOException, InterruptedException {
        communityService.saveHelpAnswer(uid, dto);
    }

    // 테스트용 엔드포인트. 프로덕션에서 사용하지 않음.
    @PostMapping("/wcloud")
    public void saveWordCloud(@RequestAttribute("uid") String uid, @RequestBody WordCloudRequestDto dto) throws IOException, InterruptedException {
//        try {
//            communityService.saveWordCloudLegacy(uid, dto);
//        }
//        catch (IOException e) {
//            log.error(e.getMessage());
//        }
        communityService.saveWordCloudExec(uid, dto.getSentence());
    }

    @GetMapping("/wcloud")
    public List<WordCount> getWordCloud(@RequestParam String targetUid) throws JsonProcessingException {
        // uid를 필요로 하진 않지만 validate해야 함
        return communityService.getWordCloud(targetUid);
    }
}
