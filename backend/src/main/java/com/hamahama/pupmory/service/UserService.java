package com.hamahama.pupmory.service;

import com.hamahama.pupmory.domain.user.ServiceUser;
import com.hamahama.pupmory.domain.user.ServiceUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author Queue-ri
 * @since 2023/09/24
 */

@RequiredArgsConstructor
@Service
public class UserService {
    private final ServiceUserRepository userRepo;

    @Transactional
    public ServiceUser getUserInfo(String uuid) {
        return userRepo.findByUserUid(uuid);
    }
}
