package com.sztu.checkinsoftware.model.domain.request;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * 用户注册请求体
 */
@Data
public class UserRegisterRequest implements Serializable {

    @Serial
    private static final long serialVersionUID = 5012419803148707969L;
    private String classes;
    private String userAccount;
    private String userPassword;
    private String checkPassword;
}
