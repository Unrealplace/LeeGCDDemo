//
//  LeeBaseVC.m
//  LeeGCDDemo
//
//  Created by MacBook on 2017/4/18.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeBaseVC.h"

@interface LeeBaseVC ()

@end

@implementation LeeBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
//    [self testLock1];
 
//    [self testLock2];
//    [self testLock3];
//    [self testLock4];
    [self testLock5];
}


-(void)testLock1{

    NSLog(@"1");
    @try {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"2");
//        });
        NSArray * arr = @[@"'"];
        NSLog(@"%@",arr[1]);
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
   
//    NSLog(@"3");

}
-(void)testLock2{
    NSLog(@"1");
    dispatch_sync(dispatch_queue_create("dd", DISPATCH_QUEUE_CONCURRENT), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
    
}
-(void)testLock3{

    dispatch_queue_t queue = dispatch_queue_create("com.demo.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1"); // 任务1
    dispatch_async(queue, ^{
        NSLog(@"2"); // 任务2
        dispatch_sync(dispatch_queue_create("com.demo.serial", DISPATCH_QUEUE_SERIAL), ^{
            NSLog(@"3"); // 任务3
        });
        NSLog(@"4"); // 任务4
    });
    NSLog(@"5"); // 任务5
}
-(void)testLock4{

    NSLog(@"1"); // 任务1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2"); // 任务2
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"3"); // 任务3
        });
        NSLog(@"4"); // 任务4
    });
    NSLog(@"5"); // 任务5
    
}
-(void)testLock5{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1"); // 任务1
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2"); // 任务2
        });
        NSLog(@"3"); // 任务3
    });
    NSLog(@"4"); // 任务4
    while (1) {
    }
    NSLog(@"5"); // 任务5
}
@end
