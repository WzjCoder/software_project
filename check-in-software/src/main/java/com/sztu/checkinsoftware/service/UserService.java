package com.sztu.checkinsoftware.service;

import com.sztu.checkinsoftware.model.domain.User;
import com.baomidou.mybatisplus.extension.service.IService;

import javax.servlet.http.HttpServletRequest;


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
}
