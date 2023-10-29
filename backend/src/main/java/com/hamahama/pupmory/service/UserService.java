package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.user.ServiceUser;
import com.hamahama.pupmory.domain.user.ServiceUserRepository;
import com.hamahama.pupmory.dto.memorial.PostRequestDto;
import com.hamahama.pupmory.dto.user.UserInfoUpdateDto;
import com.hamahama.pupmory.pojo.ErrorMessage;
import com.hamahama.pupmory.util.S3Uploader;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Queue-ri
 * @since 2023/09/24
 */

@RequiredArgsConstructor
@Service
@Slf4j
public class UserService {
    private final ServiceUserRepository userRepo;
    private final S3Uploader s3Uploader;

    @Transactional
    public ServiceUser getUserInfo(String uuid) {
        return userRepo.findByUserUid(uuid);
    }

    @Transactional
    public ResponseEntity<?> updateUserInfo(String uid, UserInfoUpdateDto dto, MultipartFile mfile) {
        ServiceUser user = userRepo.findById(uid).get();
        List<MultipartFile> mfileList = new ArrayList<MultipartFile>();
        List<String> fileUrlList = new ArrayList<String>();
        mfileList.add(mfile);

        try {
            if (mfile != null) {
                fileUrlList = s3Uploader.upload(mfileList, "profile", uid);
                user.setProfileImage(fileUrlList.get(0));
            }
        }
        catch (IOException e) {
            log.error(e.getMessage());
            return new ResponseEntity<ErrorMessage>(new ErrorMessage(502, e.getMessage()), HttpStatus.BAD_GATEWAY);
        }

        user.setNickname(dto.getNickname());
        user.setPuppyName(dto.getPuppyName());
        user.setPuppyAge(dto.getPuppyAge());
        user.setPuppyType(dto.getPuppyType());

        return new ResponseEntity<>(HttpStatus.OK);
    }
}
