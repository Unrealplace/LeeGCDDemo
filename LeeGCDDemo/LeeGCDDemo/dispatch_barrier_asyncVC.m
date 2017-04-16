//
//  dispatch_barrier_asyncVC.m
//  LeeGCDDemo
//
//  Created by MacBook on 2017/4/16.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "dispatch_barrier_asyncVC.h"

@interface dispatch_barrier_asyncVC ()

@end

@implementation dispatch_barrier_asyncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    一个dispatch barrier 允许在一个并发队列中创建一个同步点。当在并发队列中遇到一个barrier, 他会延迟执行barrier的block,等待所有在barrier之前提交的blocks执行结束。 这时，barrier block自己开始执行。 之后， 队列继续正常的执行操作。
//    
//    调用这个函数总是在barrier block被提交之后立即返回，不会等到block被执行。当barrier block到并发队列的最前端，他不会立即执行。相反，队列会等到所有当前正在执行的blocks结束执行。到这时，barrier才开始自己执行。所有在barrier block之后提交的blocks会等到barrier block结束之后才执行。
//    
//    这里指定的并发队列应该是自己通过dispatch_queue_create函数创建的。如果你传的是一个串行队列或者全局并发队列，这个函数等同于dispatch_async函数。
    
//    通过dispatch_barrier_async函数提交的任务会等它前面的任务执行完才开始，然后它后面的任务必须等它执行完毕才能开始.
//    必须使用dispatch_queue_create创建的队列才会达到上面的效果.
    
    [self async_barrrier_concurrent];
    [self sync_barrier_concurrent];
    [self async_barrier_serial];
    [self sync_barrier_serial];
    

}


-(void)async_barrrier_concurrent{

    //1 创建并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //2 向队列中添加任务
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务1,%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务2,%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务3,%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"我是barrier:%@",[NSThread currentThread]);
    });
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务4,%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务5,%@",[NSThread currentThread]);
    });
}
-(void)sync_barrier_concurrent{

    //1 创建并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //2 向队列中添加任务
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务1,%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务2,%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务3,%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"我是barrier:%@",[NSThread currentThread]);
    });
    
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务4,%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务5,%@",[NSThread currentThread]);
    });
  
}
-(void)async_barrier_serial{

    //1 创建并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue_serial_queue", DISPATCH_QUEUE_SERIAL);
    
    //2 向队列中添加任务
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务1,%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务2,%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务3,%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"我是barrier:%@",[NSThread currentThread]);
    });
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务4,%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务5,%@",[NSThread currentThread]);
    });
}
-(void)sync_barrier_serial{

    //1 创建并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue_serial", DISPATCH_QUEUE_SERIAL);
    
    //2 向队列中添加任务
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务1,%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务2,%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务3,%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"我是barrier:%@",[NSThread currentThread]);
    });
    
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务4,%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"任务5,%@",[NSThread currentThread]);
    });

}

//我们可以利用 dispatch_barrier 的特性实现读写安全的模型.



@end
