package com.sztu.checkinsoftware.model.domain.request;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * 用户签到请求体
 */
@Data
public class UserCheckinRequest implements Serializable {

    @Serial
    private static final long serialVersionUID = 5012419803148707969L;

    private long checkid;
    private String checkcode;

}
