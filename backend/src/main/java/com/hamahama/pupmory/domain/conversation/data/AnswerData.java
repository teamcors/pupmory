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
 * @since 2023/06/04
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
public class AnswerData {
    @EmbeddedId
    private AnswerDataId dataId;

    private Long selection;

    @Column(nullable = false, columnDefinition="BOOLEAN DEFAULT false")
    private Boolean isGptRequired;

    @Type(type = "string-array")
    @Column(columnDefinition = "text[]")
    private String[] answer;
}
