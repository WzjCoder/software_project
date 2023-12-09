package com.sztu.checkinsoftware.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sztu.checkinsoftware.model.domain.CheckLog;
import com.sztu.checkinsoftware.service.CheckLogService;
import com.sztu.checkinsoftware.mapper.CheckLogMapper;
import org.springframework.stereotype.Service;

/**
* @author wangz
* @description 针对表【check_log(签到记录表)】的数据库操作Service实现
* @createDate 2023-12-09 15:02:57
*/
@Service
public class CheckLogServiceImpl extends ServiceImpl<CheckLogMapper, CheckLog>
    implements CheckLogService{

}




