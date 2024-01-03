package com.sztu.checkinsoftware.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.ThreadPoolExecutor;

@Configuration //让spring扫描到
@EnableAsync
public class ThreadConfig {

    //获取cpu线程数+1
    private static final int threadNum = Runtime.getRuntime().availableProcessors() + 1;

    // 核心线程池大小
    public static int corePoolSize = threadNum;

    //最大线程数
    private int maxPoolSize = 2 * threadNum;

    //线程池维护线程所允许的空闲时间 1分钟
    private int keepAliveSeconds = 60;

    //队列最大长度
    private int queueCapacity = 1024;

    //线程池名前缀
    private static final String threadNamePrefixName = "Async-Test-Service-";

    /**
     * 自定义线程池
     * @return
     */
    @Bean(name = "threadPoolTaskExecutor")
    public ThreadPoolTaskExecutor createThreadPoolTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        //最大线程数
        executor.setMaxPoolSize(maxPoolSize);
        //核心线程数
        executor.setCorePoolSize(threadNum);
        //线程活跃时间（秒）
        executor.setKeepAliveSeconds(keepAliveSeconds);
        //默认线程名称
        executor.setThreadNamePrefix(threadNamePrefixName);
        //阻塞队列容量
        executor.setQueueCapacity(queueCapacity);
        //设置拒绝策略:不在新线程中执行任务，而是由调用者所在的线程来执行
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        // 等待所有任务结束后再关闭线程池
        executor.setWaitForTasksToCompleteOnShutdown(true);
        //初始化
        executor.initialize();
        return executor;
    }
}

