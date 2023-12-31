package com.sztu.checkinsoftware.model.domain.request;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class UserReCheckinRequest implements Serializable {
    @Serial
    private static final long serialVersionUID = 5012419803148707969L;
    private Long userid;

    private Long checkid;
}
