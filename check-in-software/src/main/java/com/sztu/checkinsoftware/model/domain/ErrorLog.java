package com.sztu.checkinsoftware.model.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Data;

/**
 * 异常记录表
 * @TableName error_log
 */
@TableName(value ="error_log")
@Data
public class ErrorLog implements Serializable {
    /**
     * 记录id
     */
    @TableId(type = IdType.AUTO)
    private Long logid;

    /**
     * 用户id
     */
    private Long userid;

    /**
     * 异常类型
     */
    private String errortype;

    /**
     * 异常发生时间
     */
    private String errordate;

    /**
     * 是否补签
     */
    private Integer isop;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}