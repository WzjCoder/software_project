package com.sztu.checkinsoftware.controller;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.sztu.checkinsoftware.common.BaseResponse;
import com.sztu.checkinsoftware.common.ErrorCode;
import com.sztu.checkinsoftware.common.ResultUtils;
import com.sztu.checkinsoftware.exception.BusinessException;
import com.sztu.checkinsoftware.model.domain.*;
import com.sztu.checkinsoftware.model.domain.request.*;
import com.sztu.checkinsoftware.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.stream.Collectors;

import static com.sztu.checkinsoftware.constant.constant.ADMIN_ROLE;
import static com.sztu.checkinsoftware.constant.constant.USER_LOGIN_STATE;

/**
 * 用户接口
 */
@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/User")
public class UserController {

    @Resource
    private UserService userService;

    @PostMapping("/register")
    public BaseResponse<Long> userRegister(@RequestBody UserRegisterRequest userRegisterRequest){
        if(userRegisterRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        String userAccount = userRegisterRequest.getUserAccount();
        String userPassword = userRegisterRequest.getUserPassword();
        String checkPassword = userRegisterRequest.getCheckPassword();
        String userclasses = userRegisterRequest.getClasses();
        if(StringUtils.isAnyBlank(userAccount,userPassword,checkPassword, userclasses)){
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        long result = userService.userRegister(userAccount, userPassword, checkPassword, userclasses);
        return ResultUtils.success(result);
    }

    @PostMapping("/login")
    public BaseResponse<User> userLogin(@RequestBody UserLoginRequest userLoginRequest, HttpServletRequest request){
        if(userLoginRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        String userAccount = userLoginRequest.getUserAccount();
        String userPassword = userLoginRequest.getUserPassword();
        if(StringUtils.isAnyBlank(userAccount,userPassword)){
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User result =  userService.userLogin(userAccount, userPassword, request);
        return ResultUtils.success(result);
    }

    @PostMapping("/logout")
    public BaseResponse<Integer> userLogout(HttpServletRequest request){
        if(request == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Integer result = userService.userLogout(request);
        return ResultUtils.success(result);
    }

    @GetMapping("current")
    public BaseResponse<User> getCurrentUser(HttpServletRequest request){
        Object userObj = request.getSession().getAttribute(USER_LOGIN_STATE);
        User currentUser = (User) userObj;
        if(currentUser == null){
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "用户不存在");
        }
        long userId = currentUser.getId();
        User user = userService.getById(userId);
        User safetyUser = userService.getSafetyUser(user);
        return ResultUtils.success(safetyUser);
    }

    @GetMapping("/search")
    public BaseResponse<List<User>> searchUsers(String username, HttpServletRequest request){
        //鉴权
        if(!isAdmin(request)){
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "用户不存在");
        }
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        if(StringUtils.isNotBlank(username)){
            queryWrapper.like("username",username);
        }
        List<User> userList = userService.list(queryWrapper);
        List<User> list = userList.stream().map(user ->{
            return userService.getSafetyUser(user);
        }).collect(Collectors.toList());
        return ResultUtils.success(list);
    }

    @PostMapping("/delete")
    public BaseResponse<Boolean> deleteUser(@RequestBody long id, HttpServletRequest request){
        //鉴权
        if(!isAdmin(request)){
            throw new BusinessException(ErrorCode.NO_AUTH);
        }
        if(id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "用户不存在");
        }
        Boolean result = userService.removeById(id);
        return ResultUtils.success(result);
    }

    /**
     * 是否为管理员
     * @param request
     * @return
     */
    private boolean isAdmin(HttpServletRequest request){
        //鉴权
        Object userObj = request.getSession().getAttribute(USER_LOGIN_STATE);
        if(userObj == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User user = (User) userObj;
        return user != null && user.getUserRole() == ADMIN_ROLE;
    }

    /**
     * 发布签到
     */
    @PostMapping("/postcheckin")
    public BaseResponse<CheckLog> postCheckin(HttpServletRequest request, @RequestBody UserPostCheckinRequest userPostCheckin){
        //鉴权
        if(userPostCheckin == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "请求不存在");
        }
        CheckLog checkLog = userService.postCheckin(request, userPostCheckin.getClasses(), userPostCheckin.getLength());
        return ResultUtils.success(checkLog);
    }

    @PostMapping("/startcheckin")
    public BaseResponse<List<String>> startCheckin(HttpServletRequest request, UserStartCheckinRequest userStartCheckinRequest){
        if( userStartCheckinRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        List<String> uncheckin = userService.startCheckin(request,userStartCheckinRequest);
        return ResultUtils.success(uncheckin);
    }

    /**
     * 用户请求签到
     * @param request
     * @param userCheckinRequest
     * @return
     */
    @PostMapping("/usercheckin")
    public BaseResponse<Integer> userCheckin(HttpServletRequest request, @RequestBody UserCheckinRequest userCheckinRequest){
        //鉴权
        if(userCheckinRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Integer result = userService.userCheckin(request, userCheckinRequest.getCheckid(), userCheckinRequest.getCheckcode());
        return ResultUtils.success(result);
    }
    @PostMapping("/searchcheckinlogs")
    public BaseResponse<List<CheckLog>> searchCheckinLog(HttpServletRequest request, UserSearchCheckinLogRequest userSearchCheckinLogRequest){
        List<CheckLog> result = userService.searchCheckinLog(request, userSearchCheckinLogRequest.getClasses());
        return ResultUtils.success(result);
    }

    @PostMapping("/searcherrorlogs")
    public BaseResponse<List<ErrorLog>> searchErrorLog(HttpServletRequest request){
        List<ErrorLog> result = userService.searchErrorLog(request);
        return ResultUtils.success(result);
    }
    @PostMapping("/searchonechecklog")
    public BaseResponse<List<student>> searchOneCheckLog(HttpServletRequest request, Long checkid) {
        return ResultUtils.success(userService.searchOneCheckLog(request, checkid));
    }

    @PostMapping("/recheckin")
    public BaseResponse<Integer> reCheckin(HttpServletRequest request, UserReCheckinRequest userReCheckinRequest) {
        Integer result = userService.reCheckin(request, userReCheckinRequest.getCheckid(), userReCheckinRequest.getUserid());
        return ResultUtils.success(result);
    }
}
