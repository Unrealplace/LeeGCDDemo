//
//  dispatch_applyVC.m
//  LeeGCDDemo
//
//  Created by MacBook on 2017/4/16.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "dispatch_applyVC.h"

@interface dispatch_applyVC ()

@end

@implementation dispatch_applyVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self test_concurrent];
//    [self test_serial];
    [self test_array_for];
    [self dispatchApplyTest3];
    
}

-(void)test_concurrent{
    //生成全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /*! dispatch_apply函数说明
     10      *
     11      *  @brief  dispatch_apply函数是dispatch_sync函数和Dispatch Group的关联API
     12      *         该函数按指定的次数将指定的Block追加到指定的Dispatch Queue中,并等到全部的处理执行结束
     13      *
     14      *  @param 10    指定重复次数  指定10次
     15      *  @param queue 追加对象的Dispatch Queue
     16      *  @param index 带有参数的Block, index的作用是为了按执行的顺序区分各个Block
     17      *
     18      */
    dispatch_apply(15, queue, ^(size_t index) {
        NSLog(@"%zu%@", index,[NSThread currentThread]);
    });
    NSLog(@"done");
    
}
-(void)test_serial{

    //生成全局队列
    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    /*! dispatch_apply函数说明
     10      *
     11      *  @brief  dispatch_apply函数是dispatch_sync函数和Dispatch Group的关联API
     12      *         该函数按指定的次数将指定的Block追加到指定的Dispatch Queue中,并等到全部的处理执行结束
     13      *
     14      *  @param 10    指定重复次数  指定10次
     15      *  @param queue 追加对象的Dispatch Queue
     16      *  @param index 带有参数的Block, index的作用是为了按执行的顺序区分各个Block
     17      *
     18      */
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"%zu%@", index,[NSThread currentThread]);
    });
    NSLog(@"done");
}

-(void)test_array_for{

    //1.创建NSArray类对象
         NSArray *array = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j"];
    
         //2.创建一个全局队列
         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //3.通过dispatch_apply函数对NSArray中的全部元素进行处理,并等待处理完成,
         dispatch_apply([array count], queue, ^(size_t index) {
                NSLog(@"%zu: %@-->%@", index, [array objectAtIndex:index],[NSThread currentThread]);
             });
         NSLog(@"done");
}

//(三)在dispatch_async函数中异步执行dispatch_apply函数,模拟dispatch_sync的同步效果
/*!
 2  *  @brief  推荐在dispatch_async函数中异步执行dispatch_apply函数
 3     效果     dispatch_apply函数与dispatch_sync函数形同,会等待处理执行结束
 4  */
- (void)dispatchApplyTest3 {
    NSArray *array = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        dispatch_apply([array count], queue, ^(size_t index) {
            NSLog(@"%zu: %@", index, [array objectAtIndex:index]);
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程执行用户界面更新等操作");
        });
        
    });
}
@end
