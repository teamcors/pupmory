package com.hamahama.pupmory.dto;

import com.hamahama.pupmory.domain.conversation.MetaData;
import lombok.Getter;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Getter
public class SetResponseDto {
    private Long stage;
    private Long set;
    private String setName;
    private Long totalQuestion;

    public SetResponseDto(MetaData metaData) {
        this.stage = metaData.getMetaDataId().getStage();
        this.set = metaData.getMetaDataId().getSet();
        this.setName = metaData.getSetName();
        this.totalQuestion = metaData.getTotalQuestion();
    }
}
