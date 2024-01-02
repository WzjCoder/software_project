# 配置手册

## 依赖

* 框架：spring-boot
* 包管理工具：maven
* 数据库管理：mybatis-plus
* 开发工具：idea

## 数据库连接

1. 本地mysql导入student.sql
2. 启动mysql，使用idea连接后端数据库
3. 有需要就在application.yml文件中修改数据库账号密码
   ![image](https://github.com/WzjCoder/software_project/assets/128364962/3671a281-d26a-4691-88f5-c846e9ee8da9)

## 接口文档以及测试

浏览器打开http://localhost:8080/api/doc.html
里边可以查看接口以及进行接口测试(先启动项目)

## 项目部署

1. 选择有公网ip的服务器
2. 使用docker部署
3. 参照博客http://www.bryh.cn/a/380946.html先构建项目运行镜像(maven3.9.5 + openjdk17)
4. 编写项目Dockerfile文件放在项目根目录
5. 使用"docker build -t image_name:v1.0 ."命令构建项目镜像
6. "docker run -p 8080:8080 -d image_name:v1.0" 后台运行镜像并进行端口转发
7. 请求地址：https://公网ip:8080/api/User/..

