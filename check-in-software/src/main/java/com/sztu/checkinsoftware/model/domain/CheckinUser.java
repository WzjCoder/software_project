package com.sztu.checkinsoftware.model.domain;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * 签到记录表
 * @TableName checkin_user
 */
@TableName(value ="checkin_user")
@Data
public class CheckinUser implements Serializable {
    /**
     * 用户id
     */
    private Long id;
    /**
     * 签到记录id
     */
    private Long checkid;
}