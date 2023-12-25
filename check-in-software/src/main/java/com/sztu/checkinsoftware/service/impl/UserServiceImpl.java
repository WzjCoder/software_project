package com.sztu.checkinsoftware.service.impl;

import cn.hutool.core.util.RandomUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.sztu.checkinsoftware.common.ErrorCode;
import com.sztu.checkinsoftware.exception.BusinessException;
import com.sztu.checkinsoftware.mapper.CheckLogMapper;
import com.sztu.checkinsoftware.mapper.ErrorLogMapper;
import com.sztu.checkinsoftware.mapper.UserMapper;
import com.sztu.checkinsoftware.model.domain.CheckLog;
import com.sztu.checkinsoftware.model.domain.CheckinUser;
import com.sztu.checkinsoftware.model.domain.ErrorLog;
import com.sztu.checkinsoftware.model.domain.User;
import com.sztu.checkinsoftware.model.domain.request.UserStartCheckinRequest;
import com.sztu.checkinsoftware.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.sztu.checkinsoftware.constant.constant.*;

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

    @Resource
    private ErrorLogMapper errorlogMapper;

    @Resource
    private CheckLogMapper checklogMapper;

    @Resource
    private CopyOnWriteArrayList<CheckinUser> checkinUsersList;
    private static final String SALT = "sztu";


    @Override
    public long userRegister(String userAccount, String userPassword, String checkPassword) {
        //校验
        if (StringUtils.isAnyBlank(userAccount, userPassword, checkPassword)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "参数为空");
        }
        if (userAccount.length() < 4) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "账号过短");
        }
        if (userPassword.length() < 8 || checkPassword.length() < 8) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "密码过短");
        }
        //账户不能包含特殊字符
        String validPattern = "[`~!@#$%^&*()+=|{}':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
        Matcher matcher = Pattern.compile(validPattern).matcher(userAccount);
        if (matcher.find()) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "存在特殊字符");
        }
        // 密码跟校验密码相同
        if (!userPassword.equals(checkPassword)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "两次输入的密码不相同");
        }
        // 账户不能重复
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userAccount", userAccount);
        long count = userMapper.selectCount(queryWrapper);
        if (count > 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "账号重复");
        }
        // 加密
        String encryptPassword = DigestUtils.md5DigestAsHex((SALT + userPassword).getBytes());
        //插入数据
        User user = new User();
        user.setUserAccount(userAccount);
        user.setUserPassword(userPassword);
        boolean saveResult = this.save(user);
        if (!saveResult) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "保存错误");
        }
        return user.getId();

    }

    @Override
    public User userLogin(String userAccount, String userPassword, HttpServletRequest request) {
        //校验
        if (StringUtils.isAnyBlank(userAccount, userPassword)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        if (userAccount.length() < 4) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "账号过短");
        }
        if (userPassword.length() < 8) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "密码过短");
        }
        //账户不能包含特殊字符
        String validPattern = "[`~!@#$%^&*()+=|{}':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
        Matcher matcher = Pattern.compile(validPattern).matcher(userAccount);
        if (matcher.find()) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "包含特殊字符");
        }
        // 加密
        String encryptPassword = DigestUtils.md5DigestAsHex((SALT + userPassword).getBytes());
        // 查询数据库
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userAccount", userAccount);
        queryWrapper.eq("userPassword", userPassword);
        User user = userMapper.selectOne(queryWrapper);
        //用户不存在
        if (user == null) {
            log.info("user login failed, userAccount cannot match userPassword");
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "用户不存在");
        }
        //用户脱敏
        User safetyUser = getSafetyUser(user);
        //记录用户的登录态
        request.getSession().setAttribute(USER_LOGIN_STATE, safetyUser);
        return safetyUser;
    }

    /**
     * 用户脱敏
     *
     * @param originUser
     * @return
     */
    @Override
    public User getSafetyUser(User originUser) {
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

    /**
     * 用户发布签到
     */
    @Override
    public CheckLog postCheckin(HttpServletRequest request, String classes, int length) {
        Object userObj = request.getSession().getAttribute(USER_LOGIN_STATE);
        if (userObj == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User user = (User) userObj;
        if (user.getUserRole() == STUDENT_ROLE) {
            log.info("Students cannot post check-in");
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "权限不足");
        }
        String checkInCode = RandomUtil.randomString(10);
        CheckLog checklog = new CheckLog();
        // LocalDateTime timestamp = LocalDateTime.now();
        checklog.setUserid(10086L);
        checklog.setCode(checkInCode);
        checklog.setClasses(classes);
        checklog.setLength(length);
        int saveResult = checklogMapper.insert(checklog);
        return checklog;
    }

    @Override
    public List<String> startCheckin(HttpServletRequest request, UserStartCheckinRequest userStartCheckinRequest) {
        Object userObj = request.getSession().getAttribute(USER_LOGIN_STATE);
        if(userObj == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User user = (User) userObj;
        if(user.getUserRole() != TEACHER_ROLE) {
            log.info("Students cannot start check-in");
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "权限不足");
        }
        // 等待签到结束，然后记录未签到
        int length = userStartCheckinRequest.getLength();
        try {
            Thread.sleep(length * 1000L);
        } catch (InterruptedException e) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        // 未签到用户录入
        return record(userStartCheckinRequest);
    }

    @Override
    public List<String> record(UserStartCheckinRequest userStartCheckinRequest) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("classes", userStartCheckinRequest.getClasses());
        List<User> students = userMapper.selectList(queryWrapper);
        List<CheckinUser> successfulStudents = new ArrayList<>(checkinUsersList.stream()
                .filter(element -> Objects.equals(element.getCheckid(), userStartCheckinRequest.getCheckid()))
                .toList());
        List<String> uncheckin = new ArrayList<>();
        // 先按id排序
        students.sort(Comparator.comparingLong(User::getId));
        successfulStudents.sort(Comparator.comparingLong(CheckinUser::getId));
        int length1 = students.size(), length2 = successfulStudents.size();
        int tp1 = 0, tp2 = 0;
        // 对比两个列表中的学生，不一样的即为缺席
        while (tp1 < length1 && tp2 < length2) {
            User user1 = students.get(tp1);
            CheckinUser user2 = successfulStudents.get(tp2);
            if(Objects.equals(user1.getId(), user2.getId())){
                tp1 ++;
                tp2 ++;
            }
            else {
                uncheckin.add(user1.getUsername());
                ErrorLog errorLog = new ErrorLog();
                errorLog.setCheckid(userStartCheckinRequest.getCheckid());
                errorLog.setUserid(user1.getId());
                errorLog.setErrortype("缺席");
                tp1 ++;
            }
        }
        while (tp1 < length1) {
            User user1 = students.get(tp1);
            uncheckin.add(user1.getUsername());
            ErrorLog errorLog = new ErrorLog();
            errorLog.setCheckid(userStartCheckinRequest.getCheckid());
            errorLog.setUserid(user1.getId());
            errorLog.setErrortype("缺席");
            tp1 ++;
        }
        return uncheckin;
    }

    @Override
    public int userCheckin(HttpServletRequest request, Long checkid, String checkinCode){
        Object userObj = request.getSession().getAttribute(USER_LOGIN_STATE);
        if(userObj == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User user = (User) userObj;
        // 到数据库查找签到数据
        QueryWrapper<CheckLog> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("checkid", checkid);
        CheckLog checkLog = checklogMapper.selectOne(queryWrapper);
        if(!Objects.equals(user.getClasses(), checkLog.getClasses())) {
            log.info("Students are not in the check-in class");
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "班级错误");
        }
        // 校验签到码是否相同
        if (!Objects.equals(checkinCode, checkLog.getCode())) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "签到码错误");
        }
        // 校验是否在签到时间内
        long currenttime = System.currentTimeMillis();
        Date checkindata = checkLog.getCheckdate();
        long checkintime = checkindata.getTime();
        if (currenttime - checkintime > checkLog.getLength() * 1000) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "超出签到时间");
        }
        // 将成功签到用户转入列表
        CheckinUser checkinUser = new CheckinUser();
        checkinUser.setId(user.getId());
        checkinUser.setCheckid(checkLog.getCheckid());
        if (!checkinUsersList.contains(checkinUser)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "重复签到");
        }
        checkinUsersList.add(checkinUser);
        return 1;
    }
}




