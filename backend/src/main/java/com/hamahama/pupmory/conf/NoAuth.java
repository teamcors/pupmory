package com.hamahama.pupmory.conf;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author Queue-ri
 * @author becky
 * @author hyojeongchoi
 * @author nusuy
 * @since 2023/11/16
 */

@Retention(RetentionPolicy.RUNTIME) // 어노테이션 레벨 설정
@Target({ElementType.TYPE, ElementType.METHOD}) // 선언된 어노테이션이 적용될 수 있는 위치 설정
public @interface NoAuth {

}