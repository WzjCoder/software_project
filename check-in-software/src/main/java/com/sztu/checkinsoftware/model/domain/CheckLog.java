package com.sztu.checkinsoftware.model.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.util.Date;
import lombok.Data;

/**
 * 签到记录表
 * @TableName check_log
 */
@TableName(value ="check_log")
@Data
public class CheckLog implements Serializable {
    /**
     * 签到记录id
     */
    @TableId
    private Long checkid;

    /**
     * 用户id
     */
    private Long userid;

    /**
     * 签到日期(包含具体时间)
     */
    private Date checkdate;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}