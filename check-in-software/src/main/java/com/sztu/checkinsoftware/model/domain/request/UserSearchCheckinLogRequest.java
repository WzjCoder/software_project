package com.sztu.checkinsoftware.model.domain.request;

import lombok.Data;

import java.io.Serial;

@Data
public class UserSearchCheckinLogRequest {
    @Serial
    private static final long serialVersionUID = 5012419803148707969L;
    /**
     * 签到班级
     */
    private String classes;
}
