package com.hamahama.pupmory.domain.user;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

public interface ServiceUserRepository extends JpaRepository<ServiceUser, Long> {
    ServiceUser findByUserUid(@Param("userUid") String uuid);
}
