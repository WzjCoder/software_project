package com.sztu.checkinsoftware.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.sztu.checkinsoftware.model.domain.CheckLog;
import com.sztu.checkinsoftware.model.domain.ErrorLog;
import com.sztu.checkinsoftware.model.domain.User;
import com.sztu.checkinsoftware.model.domain.request.UserStartCheckinRequest;
import com.sztu.checkinsoftware.model.domain.student;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.concurrent.Future;


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
    long userRegister(String userAccount,String userPassword,String checkPassword, String userName, String classes);

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
     * @return 返回未签到用户姓名列表
     */
    Future<List<String>> startCheckin(HttpServletRequest request, UserStartCheckinRequest userStartCheckinRequest);

    List<String> record(UserStartCheckinRequest userStartCheckinRequest);

    /**
     * 学生签到接口，将成功签到的用户存入list<CheckinUser>
     * @param request 用户请求
     * @param checkid 签到id
     * @param checkCode 签到码
     * @return 返回结果
     */
    int userCheckin(HttpServletRequest request, Long checkid, String checkCode);

    /**
     * 发布签到历史记录查询
     * 老师查看自己在某班级的签到历史记录
     * @param classes 查询的班级
     * @return 返回签到记录
     */
    List<CheckLog> searchCheckinLog(HttpServletRequest request, String classes);

    /**
     * 查询某次签到的整体签到情况
     * @param checkid 签到id
     * @return 返回签到情况
     */
    List<student> searchOneCheckLog(HttpServletRequest request, Long checkid);
    /**
     * 学生端查询未签到的记录
     * @param request 用户请求
     * @return 返回未签到记录
     */
    List<ErrorLog> searchErrorLog(HttpServletRequest request);

    /**
     * 老师对未签到同学进行补签
     * @param checkid 签到id
     * @param userid  学生id
     * @return
     */
    int reCheckin(HttpServletRequest request, Long checkid, Long userid);

    /**
     *
     * @param content
     * @param fileSaveFullPath
     * @param hints 参数配置
     * @throws Exception
     */

}
