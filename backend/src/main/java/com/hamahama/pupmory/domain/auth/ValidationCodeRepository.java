package com.hamahama.pupmory.domain.auth;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * @author Queue-ri
 * @since 2023/10/27
 */

public interface ValidationCodeRepository extends JpaRepository<ValidationCode, Long> {
    Optional<ValidationCode> findByCodeAndIssuedBy(String code, String issuedBy);
}
