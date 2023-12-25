package com.sztu.checkinsoftware.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sztu.checkinsoftware.model.domain.CheckLog;
import com.sztu.checkinsoftware.model.domain.User;
import com.sztu.checkinsoftware.model.domain.request.UserStartCheckinRequest;

import javax.servlet.http.HttpServletRequest;
import java.util.List;


/**
* @author wangz
* @description 针对表【user(用户)】的数据库操作Service
* @createDate 2023-10-22 16:41:53
*/
public interface UserService extends IService<User> {


    /**
     * 用户注册
     * @param userAccount 用户账户
     * @param userPassword 用户密码
     * @param checkPassword 校验码
     * @return 新用户id
     */
    long userRegister(String userAccount,String userPassword,String checkPassword);

    /**
     * 用户登录
     * @param userAccount 账户
     * @param userPassword 密码
     * @return 返回脱敏后的用户信息
     */
    User userLogin(String userAccount, String userPassword, HttpServletRequest request);

    /**
     * 用户脱敏
     * @param originUser
     * @return
     */
    User getSafetyUser(User originUser);

    /**
     * 用户注销
     *
     * @param request
     * @return
     */
    int userLogout(HttpServletRequest request);

    /**
     * 发布签到，创建CheckLog对象，并生成签到码
     * @param request 签到session
     * @param classes 签到班级
     * @param length 签到时长(s)
     * @return 返回签到对象
     */
    CheckLog postCheckin(HttpServletRequest request, String classes, int length);

    /**
     * 老师开始签到，从此刻的length阶段内完成签到
     * @param request 发布用户
     * @param checkLog 发布签到的实体
     * @return 返回未签到用户姓名列表
     */
    List<String> startCheckin(HttpServletRequest request, UserStartCheckinRequest userStartCheckinRequest);

    List<String> record(UserStartCheckinRequest userStartCheckinRequest);

    /**
     * 学生签到接口，将成功签到的用户存入list<CheckinUser>
     * @param request
     * @param checkid
     * @param checkCode
     * @return
     */
    int userCheckin(HttpServletRequest request, Long checkid, String checkCode);
}
