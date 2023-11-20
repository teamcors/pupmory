package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.memorial.Comment;
import com.hamahama.pupmory.domain.memorial.CommentRepository;
import com.hamahama.pupmory.domain.memorial.Post;
import com.hamahama.pupmory.domain.memorial.PostRepository;
import com.hamahama.pupmory.domain.mypage.Announcement;
import com.hamahama.pupmory.domain.mypage.AnnouncementRepository;
import com.hamahama.pupmory.domain.user.ServiceUser;
import com.hamahama.pupmory.domain.user.ServiceUserRepository;
import com.hamahama.pupmory.dto.mypage.AnnouncementDetailDto;
import com.hamahama.pupmory.dto.mypage.AnnouncementMetaDto;
import com.hamahama.pupmory.dto.mypage.CommentMetaDto;
import com.hamahama.pupmory.pojo.ErrorMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/11/18
 */

@RequiredArgsConstructor
@Service
@Slf4j
public class MyPageService {
    private final AnnouncementRepository anRepo;
    private final CommentRepository commentRepo;
    private final PostRepository postRepo;
    private final ServiceUserRepository userRepo;

    @Transactional
    public List<AnnouncementMetaDto> getAllAnnouncementMeta() {
        List<Announcement> anList = anRepo.findAll();
        List<AnnouncementMetaDto> dtoList = new ArrayList<AnnouncementMetaDto>();

        for (Announcement an : anList)
            dtoList.add(AnnouncementMetaDto.of(an));

        return dtoList;
    }

    @Transactional
    public ResponseEntity<?> getAnnouncementDetail(Long aid) {
        Optional<Announcement> optAnnouncement = anRepo.findById(aid);

        if (optAnnouncement.isPresent()) {
            AnnouncementDetailDto dto = AnnouncementDetailDto.of(optAnnouncement.get());
            return new ResponseEntity<AnnouncementDetailDto>(dto, HttpStatus.OK);
        }
        else
            return new ResponseEntity<ErrorMessage>(new ErrorMessage(404, "no data found."), HttpStatus.NOT_FOUND);
    }

    @Transactional
    public List<CommentMetaDto> getAllCommentMeta(String uid) {
        List<Comment> commentList = commentRepo.findAllByUserUid(uid);
        List<CommentMetaDto> dtoList = new ArrayList<>();

        for(Comment comment : commentList) {
            Post post = postRepo.findById(comment.getPostId()).get();
            ServiceUser user = userRepo.findById(post.getUserUid()).get();
            dtoList.add(CommentMetaDto.of(comment, user.getNickname()));
        }

        return dtoList;
    }

}
