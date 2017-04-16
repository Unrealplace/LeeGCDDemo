//
//  QueueVC.m
//  LeeGCDDemo
//
//  Created by MacBook on 2017/4/16.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "QueueVC.h"

@interface QueueVC ()

@end

@implementation QueueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self asyncFunc];
    [self syncFunc];
}

-(void)sync_mainWith:(NSInteger) num {
    
    NSLog(@"任务%ld--->%@",(long)num,[NSThread currentThread]);
    
}
-(void)sync_serialWith:(NSInteger) num {
    NSLog(@"任务%ld--->%@",(long)num,[NSThread currentThread]);
    
}
-(void)sync_concurrentWith:(NSInteger) num {
    
    NSLog(@"任务%ld--->%@",(long)num,[NSThread currentThread]);
    
}
-(void)async_concurrentWith:(NSInteger) num {
    
    NSLog(@"任务%ld--->%@",(long)num,[NSThread currentThread]);
    
}
-(void)async_serialWith:(NSInteger) num {
    
    NSLog(@"任务%ld--->%@",(long)num,[NSThread currentThread]);
    
}
-(void)async_mainWith:(NSInteger) num {
    
    NSLog(@"任务%ld--->%@",(long)num,[NSThread currentThread]);
    
}
-(void)asyncFunc{
    
    //异步执行+ 并行对列(相当于任务数组)
    
    /**
     理解一下这个时异步并行队列，异步具有开辟多个的线程的能力，有几个任务开几个线程，这里面开辟了4个线程，加上主线程相当于5个线程
     任务同时执行
     */
    dispatch_queue_t concurrentQueue = dispatch_queue_create("lee_Concurrent_Queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"--------------start------------------");
    
    dispatch_async(concurrentQueue, ^{
        
        [self async_concurrentWith:1];
    });
    dispatch_async(concurrentQueue, ^{
        [self async_concurrentWith:2];
        
    });
    dispatch_async(concurrentQueue, ^{
        [self async_concurrentWith:3];
        
    });
    dispatch_async(concurrentQueue, ^{
        [self async_concurrentWith:4];
        
    });
    
    for (int i = 0; i < 5; i++) {
        NSLog(@"%d",i);
    }
    NSLog(@"-----------------end----------------");
    
    
    //异步串行队列
    
    NSLog(@"--------------start------------------");
    
    /**
     异步串行，可以开辟一条新的线程，但是放在串行队列中的人物时顺序执行的，会和主线程同时执行
     */
    dispatch_queue_t async_serial_Queue = dispatch_queue_create("async_serial_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(async_serial_Queue, ^{
        [self async_serialWith:5];
    });
    dispatch_async(async_serial_Queue, ^{
        [self async_serialWith:6];
    });
    dispatch_async(async_serial_Queue, ^{
        [self async_serialWith:7];
    });
    dispatch_async(async_serial_Queue, ^{
        [self async_serialWith:8];
    });
    for (int i = 0; i < 10; i++) {
        NSLog(@"%d",i);
    }
    NSLog(@"-----------------end----------------");
    
    
    // 异步+主队列
    NSLog(@"--------------start------------------");
    
    /**
     异步加主队列，不会开启新线程，任务按顺序执行
     */
    dispatch_queue_t  mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        
        [self async_mainWith:9];
    });
    dispatch_async(mainQueue, ^{
        
        [self async_mainWith:10];
    });
    dispatch_async(mainQueue, ^{
        
        [self async_mainWith:11];
    });
    dispatch_async(mainQueue, ^{
        
        [self async_mainWith:12];
    });
    for (int i = 0; i < 10; i++) {
        NSLog(@"%d",i);
    }
    NSLog(@"-----------------end----------------");
    
    
}
-(void)syncFunc{
    
    // 同步+并行队列
    
    /**
     这个不开启新的线程，任务按顺序执行的
     */
    dispatch_queue_t sync_Concrrent_queue = dispatch_queue_create("sync_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"--------------start------------------");
    
    dispatch_sync(sync_Concrrent_queue, ^{
        [self sync_concurrentWith:1];
        
    });
    dispatch_sync(sync_Concrrent_queue, ^{
        [self sync_concurrentWith:2];
        dispatch_sync(sync_Concrrent_queue, ^{
            [self sync_concurrentWith:4];
            
        });
    });
    dispatch_sync(sync_Concrrent_queue, ^{
        [self sync_concurrentWith:3];
        
    });
    NSLog(@"-----------------end----------------");
    
    // 同步串行
    NSLog(@"--------------start------------------");
    
    /**
     不会开启新的线程，任务按顺序执行。
     */
    dispatch_queue_t sync_serial_queue = dispatch_queue_create("sync_serial_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(sync_serial_queue, ^{
        [self sync_serialWith:5];
    });
    dispatch_sync(sync_serial_queue, ^{
        [self sync_serialWith:6];
    });
    dispatch_sync(sync_serial_queue, ^{
        [self sync_serialWith:7];
    });
    dispatch_sync(sync_serial_queue, ^{
        [self sync_serialWith:8];
    });
    NSLog(@"-----------------end----------------");
    
    // 同步+主队列
    
    /**
     程序崩溃。。。
     */
    //    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //    dispatch_sync(mainQueue, ^{
    //        [self sync_mainWith:9];
    //    });
    //    dispatch_sync(mainQueue, ^{
    //        [self sync_mainWith:10];
    //    });
    //    dispatch_sync(mainQueue, ^{
    //        [self sync_mainWith:11];
    //    });
    //    dispatch_sync(mainQueue, ^{
    //        [self sync_mainWith:12];
    //    });
}



@end
