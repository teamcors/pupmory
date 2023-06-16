package com.hamahama.pupmory.domain.conversation.data;

import lombok.Data;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

/**
 * @author Queue-ri
 * @since 2023/06/04
 */

@Data
@Embeddable
public class LineDataId implements Serializable {
    private Long lineId;

    @ColumnDefault("-1")
    private Long selected;

    @Column(name = "`order`")
    private Long order; // 한 라인 내의 내용 순서번호
    
    private Long stage;
    private Long set;
}
