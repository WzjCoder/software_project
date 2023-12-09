package com.sztu.checkinsoftware.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sztu.checkinsoftware.common.ErrorCode;
import com.sztu.checkinsoftware.exception.BusinessException;
import com.sztu.checkinsoftware.service.UserService;
import com.sztu.checkinsoftware.model.domain.User;
import com.sztu.checkinsoftware.mapper.UserMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.sztu.checkinsoftware.constant.constant.USER_LOGIN_STATE;

/**
* @author wangz
* @description 针对表【user(用户)】的数据库操作Service实现
* @createDate 2023-10-22 16:41:53
*/
@Service
@Slf4j
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
    implements UserService {
    @Resource
    private UserMapper userMapper;
    private static final String SALT = "sztu";


    @Override
    public long userRegister(String userAccount, String userPassword, String checkPassword) {
        //校验
        if(StringUtils.isAnyBlank(userAccount,userPassword,checkPassword)){
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"参数为空");
        }
        if(userAccount.length() < 4) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"账号过短");
        }
        if(userPassword.length() < 8 || checkPassword.length() < 8){
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"密码过短");
        }
        //账户不能包含特殊字符
        String validPattern = "[`~!@#$%^&*()+=|{}':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
        Matcher matcher = Pattern.compile(validPattern).matcher(userAccount);
        if (matcher.find()) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"存在特殊字符");
        }
        // 密码跟校验密码相同
        if(!userPassword.equals(checkPassword)){
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"两次输入的密码不相同");
        }
        // 账户不能重复
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userAccount",userAccount);
        long count = userMapper.selectCount(queryWrapper);
        if(count > 0){
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"账号重复");
        }
        // 加密
        String encryptPassword = DigestUtils.md5DigestAsHex((SALT + userPassword).getBytes());
        //插入数据
        User user = new User();
        user.setUserAccount(userAccount);
        user.setUserPassword(userPassword);
        boolean saveResult = this.save(user);
        if(!saveResult) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"保存错误");
        }
        return user.getId();

    }

    @Override
    public User userLogin(String userAccount, String userPassword, HttpServletRequest request) {
        //校验
        if(StringUtils.isAnyBlank(userAccount,userPassword)){
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        if(userAccount.length() < 4) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"账号过短");
        }
        if(userPassword.length() < 8 ){
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"密码过短");
        }
        //账户不能包含特殊字符
        String validPattern = "[`~!@#$%^&*()+=|{}':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
        Matcher matcher = Pattern.compile(validPattern).matcher(userAccount);
        if (matcher.find()) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"包含特殊字符");
        }
        // 加密
        String encryptPassword = DigestUtils.md5DigestAsHex((SALT + userPassword).getBytes());
        // 查询数据库
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userAccount",userAccount);
        queryWrapper.eq("userPassword",userPassword);
        User user = userMapper.selectOne(queryWrapper);
        //用户不存在
        if(user == null){
            log.info("user login failed, userAccount cannot match userPassword");
            throw new BusinessException(ErrorCode.PARAMS_ERROR,"用户不存在");
        }
        //用户脱敏
        User safetyUser = getSafetyUser(user);
        //记录用户的登录态
        request.getSession().setAttribute(USER_LOGIN_STATE,safetyUser);
        return safetyUser;
    }

    /**
     * 用户脱敏
     * @param originUser
     * @return
     */
    @Override
    public User getSafetyUser(User originUser){
        //用户脱敏
        User safetyUser = new User();
        safetyUser.setId(originUser.getId());
        safetyUser.setUsername(originUser.getUsername());
        safetyUser.setUserAccount(originUser.getUserAccount());
        safetyUser.setPhone(originUser.getPhone());
        safetyUser.setClasses(originUser.getClasses());
        safetyUser.setUserRole(originUser.getUserRole());
        safetyUser.setUserStatus(originUser.getUserStatus());
        safetyUser.setCreateTime(originUser.getCreateTime());
        return safetyUser;
    }

    /**
     * 用户注销
     *
     * @param request
     * @return
     */
    @Override
    public int userLogout(HttpServletRequest request) {
        request.getSession().removeAttribute(USER_LOGIN_STATE);
        //移除登录态
        return 1;
    }
}




