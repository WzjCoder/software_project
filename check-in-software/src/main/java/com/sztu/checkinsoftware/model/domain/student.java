package com.sztu.checkinsoftware.model.domain;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * 记录某次签到中学生是否签到，返回给前端显示签到记录
 * @TableName
 */
@TableName(value ="student")
@Data
public class student implements Serializable {
    /**
     * 用户id
     */
    private Long id;

    private String name;
    /**
     * 是否签到，0-未签到，1-签到
     */
    private Long ischeckin;
}