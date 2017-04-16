//
//  dispatch_semaphoreVC.m
//  LeeGCDDemo
//
//  Created by MacBook on 2017/4/16.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "dispatch_semaphoreVC.h"

@interface dispatch_semaphoreVC ()

@end

@implementation dispatch_semaphoreVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
//    [self testError];
    [self semaphoreSample];
    
}
//当并行执行的处理更新数据时,会产生数据不一致的情况,有时应用程序还会异常结束,虽然使用Serial Dipatch queue和dispatch_barrier_async函数可避免这类问题,但有必要进行更加细腻的排他控制
/*!
 2  *  @brief  不考虑顺序,将所有数据添加到数组中
 3  */
- (void)testError {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSMutableArray *mArray = [NSMutableArray array];
    //当执行次数过大时,异常结束的概率很高
    for (int i = 0; i < 10000; i++) {
        
        dispatch_async(queue, ^{
            
            [mArray addObject:[NSNumber numberWithInt:i]];
        });
    }
    NSLog(@"%@", mArray);
    /*!
     18      *  @brief  运行结果
     19      *semaphore测试(3312,0x11ab21000) malloc: *** error for object 0x7f971c047000:    pointer being freed was not allocated
     20      *** set a breakpoint in malloc_error_break to debug
     21      *  @return 异常结束
     22     
     */
    
}
//(二)什么是dispatch_semaphore
//dispatch_semaphore是持有计数的信号,该计数是多线程编程中的计数类型信号,类似于过马路的信号灯,红灯表示不能通过,而绿灯表示可以通过
//
//而在dispatch_semaphore中使用计数来实现该功能,进行更细粒度的排他控制.
//
//在没有Serial Dispatch Queue和dispatch_barrier_async函数那么大的粒度且一部分处理需要进行排他控制的情况下,dispatch Semaphore便可发挥威力
/*!
 *  @brief  使用Dispatch Semaphore进行排他性控制
 */

///<>通过dispatch_semaphore_create(long value);函数创建Dispatch_Semaphore,参数表示计数的初始值
//参数说明
//long value:表示计数的初始值
//dispatch_semaphore_t semaphore = dispatch_semaphore_create(long value);


///<>dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout);函数等待Dispatch Semaphore的计数值大于或者等于1,当满足条件时计数器执行减法,并从wait函数中返回
//***当dispatch_semaphore_wait函数返回0时,可以安全地执行排他控制的处理
//参数说明
//dispatch_semaphore_t dsema:操作的Dispatch_Semaphore对象
//dispatch_time_t timeout:由dispatch_time_t类型值指定等待时间



///<>dispatch_semaphore_signal(dispatch_semaphore_t dsema);函数将Dispatch_Semaphore的计数器加1
////参数说明
////dispatch_semaphore_t dsema:操作的Dispatch_Semaphore对象
//dispatch_semaphore_signal(dispatch_semaphore_t dsema);

//信号量在多线程开发中被广泛使用，当一个线程在进入一段关键代码之前，线程必须获取一个信号量，一旦该关键代码段完成了，那么该线程必须释放信号量。其它想进入该关键代码段的线程必须等待前面的线程释放信号量。
//信号量的具体做法是：当信号计数大于0时，每条进来的线程使计数减1，直到变为0，变为0后其他的线程将进不来，处于等待状态；执行完任务的线程释放信号，使计数加1，如此循环下去。
//下面这个例子中使用了10条线程，但是同时只执行一条，其他的线程处于等待状态：

- (void)semaphoreSample {
    
    //1.创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.创建dispatch_semaphore_t对象
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    //3.创建保存数据的可变数组
    NSMutableArray *mArray = [NSMutableArray array];
    //执行10000次操作
    for (int i = 0; i < 10000; i++) {
        //异步添加数据
        dispatch_async(queue, ^{
            //数据进入,等待处理,信号量减1
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            //处理数据
            [mArray addObject:[NSNumber numberWithInt:i]];
            //数据处理完毕,信号量加1,等待下一次处理
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    NSLog(@"%@", mArray);
    
   
}
@end
