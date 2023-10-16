package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.community.Help;
import com.hamahama.pupmory.domain.community.HelpRepository;
import com.hamahama.pupmory.dto.community.HelpAnswerSaveRequestDto;
import com.hamahama.pupmory.dto.community.HelpSaveRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/10/11
 */

@RequiredArgsConstructor
@Service
public class CommunityService {
    private final HelpRepository helpRepo;

    @Transactional
    public void saveHelp(String uid, HelpSaveRequestDto dto) {
        helpRepo.save(dto.toEntity(uid));
    }

    @Transactional
    public Help getHelp(String uid, Long hid) {
        Help help = helpRepo.findById(hid).get();
        help.setIsFromUserReadAnswer(true); // help is read by user
        return help;
    }
    
    @Transactional
    public List<Help> getAllHelp(String uid, String type) {
        if (type.equals("req")) { // 본인이 요청한 도움 내역
            return helpRepo.findAllByFromUserUid(uid);
        }
        else if (type.equals("ans")) { // 본인이 요청받은 도움 내역
            return helpRepo.findAllByToUserUid(uid);
        }
        else
            return null; // ResponseEntity로 리팩토링 필요
    }

    @Transactional
    public void saveHelpAnswer(String uid, HelpAnswerSaveRequestDto dto) {
        Long hid = dto.getHelpId();
        Help help = helpRepo.findById(hid).get();
        if (help.getToUserUid().equals(uid)) {
            help.setAnswer(dto.getContent());
            help.setAnsweredAt(LocalDateTime.now());
        }
        else {
            // 4xx 에러 핸들링
        }
    }

}
