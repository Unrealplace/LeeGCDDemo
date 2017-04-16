//
//  dispatch_groupVC.m
//  LeeGCDDemo
//
//  Created by MacBook on 2017/4/16.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "dispatch_groupVC.h"

@interface dispatch_groupVC (){

    dispatch_group_t group;
    
}

@end

@implementation dispatch_groupVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    Dispatch Group
//    在追加到Dispatch Queue中的多个任务处理完毕之后想执行结束处理，这种需求会经常出现。如果只是使用一个Serial Dispatch Queue（串行队列）时，只要将想执行的处理全部追加到该串行队列中并在最后追加结束处理即可，但是在使用Concurrent Queue 时，可能会同时使用多个Dispatch Queue时，源代码就会变得很复杂。
//    在这种情况下，就可以使用Dispatch Group。
    
    // 全局变量group
    group = dispatch_group_create();
    // 并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 进入组（进入组和离开组必须成对出现, 否则会造成死锁）
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        // 执行异步任务1
        [self firstFunc];
    });
    dispatch_group_leave(group);
    // 进入组
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        // 执行异步任务2
        [self secondFuc];
    });
    dispatch_group_leave(group);

    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        // 执行异步任务3
        [self thirdFunc];
    });
    dispatch_group_leave(group);
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{

        NSLog(@"全部任务数据下载完毕!");
    });
    

}

-(void)firstFunc{

    for (int i = 0; i < 30; i++) {
        NSLog(@"当前线程%@--->%d",[NSThread currentThread],i);
    }
}
-(void)secondFuc{

    for (int i = 31; i < 60; i++) {
        NSLog(@"当前线程%@--->%d",[NSThread currentThread],i);
    }
}
-(void)thirdFunc{

    for (int i = 60; i < 100; i++) {
        NSLog(@"当前线程%@--->%d",[NSThread currentThread],i);
    }
}
@end
