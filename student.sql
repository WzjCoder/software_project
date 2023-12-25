-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2023-12-25 19:50:53
-- 服务器版本： 5.7.26
-- PHP 版本： 7.3.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `student`
--

-- --------------------------------------------------------

--
-- 表的结构 `check_log`
--

CREATE TABLE `check_log` (
  `userid` bigint(20) NOT NULL COMMENT '用户id',
  `checkdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '签到日期(包含具体时间)',
  `checkid` bigint(20) NOT NULL COMMENT '签到记录id',
  `code` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT '签到码',
  `classes` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT '签到班级',
  `length` int(11) NOT NULL COMMENT '签到时长(s)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='签到记录表';

--
-- 转存表中的数据 `check_log`
--

INSERT INTO `check_log` (`userid`, `checkdate`, `checkid`, `code`, `classes`, `length`) VALUES
(10086, '2023-12-24 05:41:38', 1, 'fl1bnqr61r', '\"21计科三班\"', 0),
(1, '2023-12-24 05:41:08', 0, 'firstcheck', '21计科三班', 0),
(10086, '2023-12-24 05:42:06', 2, 'x0eumrwj6q', '\"21计科三班\"', 0),
(10086, '2023-12-24 05:42:42', 1738794536688279559, '4lqodyubc5', '\"21计科三班\"', 0);

-- --------------------------------------------------------

--
-- 表的结构 `error_log`
--

CREATE TABLE `error_log` (
  `logid` bigint(20) NOT NULL COMMENT '记录id',
  `userid` bigint(20) NOT NULL COMMENT '用户id',
  `errortype` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '异常类型',
  `errordate` datetime NOT NULL COMMENT '异常发生时间',
  `isop` int(11) DEFAULT NULL COMMENT '是否补签',
  `checkid` bigint(20) NOT NULL COMMENT '签到id，记录哪次签到'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='异常记录表';

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL,
  `username` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '用户名称',
  `userAccount` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '账号',
  `userPassword` varchar(512) COLLATE utf8_unicode_ci NOT NULL COMMENT '密码',
  `phone` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '电话',
  `classes` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '班级',
  `userStatus` int(11) NOT NULL DEFAULT '0' COMMENT '状态',
  `createTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `isDelete` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  `userRole` int(11) NOT NULL DEFAULT '1' COMMENT '角色（管理员0、学生1、老师2）'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='用户';

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`id`, `username`, `userAccount`, `userPassword`, `phone`, `classes`, `userStatus`, `createTime`, `updateTime`, `isDelete`, `userRole`) VALUES
(1, 'aaa', '123', '123', '213', '456', 0, '2023-10-26 14:40:34', '2023-10-26 14:40:34', 0, 0),
(2, NULL, 'yupi', '12345678', NULL, NULL, 0, '2023-10-26 14:41:52', '2023-10-26 14:41:52', 0, 0);

--
-- 转储表的索引
--

--
-- 表的索引 `check_log`
--
ALTER TABLE `check_log`
  ADD PRIMARY KEY (`checkid`);

--
-- 表的索引 `error_log`
--
ALTER TABLE `error_log`
  ADD PRIMARY KEY (`logid`);

--
-- 表的索引 `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `check_log`
--
ALTER TABLE `check_log`
  MODIFY `checkid` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '签到记录id', AUTO_INCREMENT=1738794536688279560;

--
-- 使用表AUTO_INCREMENT `error_log`
--
ALTER TABLE `error_log`
  MODIFY `logid` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录id';

--
-- 使用表AUTO_INCREMENT `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
