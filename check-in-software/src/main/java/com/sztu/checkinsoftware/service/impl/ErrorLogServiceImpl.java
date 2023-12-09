package com.sztu.checkinsoftware.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sztu.checkinsoftware.model.domain.ErrorLog;
import com.sztu.checkinsoftware.service.ErrorLogService;
import com.sztu.checkinsoftware.mapper.ErrorLogMapper;
import org.springframework.stereotype.Service;

/**
* @author wangz
* @description 针对表【error_log(异常记录表)】的数据库操作Service实现
* @createDate 2023-12-09 15:08:02
*/
@Service
public class ErrorLogServiceImpl extends ServiceImpl<ErrorLogMapper, ErrorLog>
    implements ErrorLogService{

}




