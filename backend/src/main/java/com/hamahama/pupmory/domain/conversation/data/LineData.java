package com.hamahama.pupmory.domain.conversation.data;

import io.hypersistence.utils.hibernate.type.array.StringArrayType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;
import org.hibernate.annotations.TypeDefs;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;

/**
 * @author Queue-ri
 * @since 2023/06/16
 */

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@TypeDefs({
        @TypeDef(
                name = "string-array",
                typeClass = StringArrayType.class
        )
})
public class LineData {
    @EmbeddedId
    private LineDataId dataId;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private String type;

    @Type(type = "string-array")
    @Column(columnDefinition = "text[]")
    private String[] selectList; // 임시

    private String buttonText;
    private String placeholder;
}
