package com.sztu.checkinsoftware;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.sztu.checkinsoftware.mapper")
public class CheckInSoftwareApplication {

    public static void main(String[] args) {

        SpringApplication.run(CheckInSoftwareApplication.class, args);
    }

}
