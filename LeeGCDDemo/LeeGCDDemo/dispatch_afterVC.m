//
//  dispatch_afterVC.m
//  LeeGCDDemo
//
//  Created by MacBook on 2017/4/16.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "dispatch_afterVC.h"

@interface dispatch_afterVC (){

    NSInteger _count;
    NSTimer * _timer;
}

@end

@implementation dispatch_afterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10*NSEC_PER_SEC), dispatch_queue_create("delay_queue", DISPATCH_QUEUE_CONCURRENT), ^{
        NSLog(@"hello");

    });
    
    _count=1;
    _timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];

}

//dispatch_after能让我们添加进队列的任务延时执行，该函数并不是在指定时间后执行处理，而只是在指定时间追加处理到dispatch_queue
//该方法的第一个参数是time，第二个参数是dispatch_queue，第三个参数是要执行的block。
//dispatch_time_t有两种形式的构造方式，第一种相对时间：DISPATCH_TIME_NOW表示现在，NSEC_PER_SEC表示的是秒数，它还提供了NSEC_PER_MSEC表示毫秒。第二种是绝对时间，通过dispatch_walltime函数来获取，dispatch_walltime需要使用一个timespec的结构体来得到dispatch_time_t。
//以下代码可以很清楚地看到dispatch_after的执行效果，

-(void)run
{
    if (_count==10) {
        [_timer invalidate];
    }
    _count++;
    NSLog(@"the value is %ld",(long)_count);
}



@end
