package com.sztu.checkinsoftware.service;
import java.util.Date;

import com.sztu.checkinsoftware.model.domain.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 用户服务测试
 */
@SpringBootTest

class UserServiceTest {

    @Resource
    private UserService userService;

    @Test
    public void testAddUser(){
        User user = new User();
        user.setUsername("aaa");
        user.setUserAccount("123");
        user.setUserPassword("123");
        user.setPhone("213");
        user.setClasses("");
        user.setUserStatus(0);
        user.setCreateTime(new Date());
        user.setUpdateTime(new Date());
        user.setIsDelete(0);
        boolean result = userService.save(user);
        System.out.println(user.getId());
        Assertions.assertTrue(result);
    }

    @Test
    void userRegister() {
        String account="yupi";
        String password="12345678";
        String checkpassword="1234567";
        String userclasses="21计科三班";
        long result = userService.userRegister(account,password,checkpassword,userclasses);
        Assertions.assertEquals(-1,result);
    }
}