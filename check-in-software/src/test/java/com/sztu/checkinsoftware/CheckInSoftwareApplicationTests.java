package com.sztu.checkinsoftware;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDateTime;

@SpringBootTest
class CheckInSoftwareApplicationTests {

    @Test
    void contextLoads() {
    }

    @Test
    void timeTest() {
        System.out.println(LocalDateTime.now());
    }

}
