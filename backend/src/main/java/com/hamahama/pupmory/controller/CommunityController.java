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
    private final JwtKit jwtKit;

    @PostMapping("/help")
    public void saveHelp(@RequestHeader(value="Authorization") String token, @RequestBody HelpSaveRequestDto dto) {
        String uid = jwtKit.validate(token);
        communityService.saveHelp(uid, dto);
    }

    @GetMapping("/help")
    public Help getHelp(@RequestHeader(value="Authorization") String token, @RequestParam Long hid) {
        String uid = jwtKit.validate(token);
        return communityService.getHelp(uid, hid);
    }

    @GetMapping("/help/all")
    public List<HelpResponseDto> getAllHelp(@RequestHeader(value="Authorization") String token, @RequestParam String type) {
        String uid = jwtKit.validate(token);
        return communityService.getAllHelp(uid, type);
    }

    @GetMapping("/help/log")
    public List<HelpLog> getHelpLog(@RequestHeader(value="Authorization") String token, @RequestParam String targetUid) {
        String uid = jwtKit.validate(token);
        return communityService.getHelpLog(targetUid);
    }

    @PostMapping("/answer")
    public void saveHelpAnswer(@RequestHeader(value="Authorization") String token, @RequestBody HelpAnswerSaveRequestDto dto) throws IOException, InterruptedException {
        String uid = jwtKit.validate(token);
        communityService.saveHelpAnswer(uid, dto);
    }

    // 테스트용 엔드포인트. 프로덕션에서 사용하지 않음.
    @PostMapping("/wcloud")
    public void saveWordCloud(@RequestHeader(value="Authorization") String token, @RequestBody WordCloudRequestDto dto) throws IOException, InterruptedException {
        String uid = jwtKit.validate(token);
//        try {
//            communityService.saveWordCloudLegacy(uid, dto);
//        }
//        catch (IOException e) {
//            log.error(e.getMessage());
//        }
        communityService.saveWordCloudExec(uid, dto.getSentence());
    }

    @GetMapping("/wcloud")
    public List<WordCount> getWordCloud(@RequestHeader(value="Authorization") String token) throws JsonProcessingException {
        String uid = jwtKit.validate(token);
        return communityService.getWordCloud(uid);
    }
}
