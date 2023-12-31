-- auto-generated definition
create table check_log
(
    userid    bigint                              not null comment '用户id',
    checkdate timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '签到日期(包含具体时间)',
    checkid   bigint auto_increment comment '签到记录id'
        primary key,
    code      varchar(20)                         not null comment '签到码',
    classes   varchar(128)                        not null comment '签到班级',
    length    int                                 not null comment '签到时长(s)'
)
    comment '签到记录表';

create table error_log
(
    logid     bigint auto_increment comment '记录id'
        primary key,
    userid    bigint       not null comment '用户id',
    errortype varchar(256) null comment '异常类型',
    errordate datetime     not null comment '异常发生时间',
    isop      int          null comment '是否补签',
    checkid   bigint       not null comment '签到id，记录哪次签到'
)
    comment '异常记录表';

create table user
(
    id           bigint auto_increment
        primary key,
    username     varchar(256)                       null comment '用户名称',
    userAccount  varchar(256)                       null comment '账号',
    userPassword varchar(512)                       not null comment '密码',
    phone        varchar(128)                       null comment '电话',
    classes      varchar(512)                       null comment '班级',
    userStatus   int      default 0                 not null comment '状态',
    createTime   datetime default CURRENT_TIMESTAMP null comment '创建时间',
    updateTime   datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment '更新时间',
    isDelete     tinyint  default 0                 null comment '是否删除',
    userRole     int      default 1                 not null comment '角色（管理员0、学生1、老师2）'
)
    comment '用户';


