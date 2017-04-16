//
//  Cache.m
//  LeeGCDDemo
//
//  Created by MacBook on 2017/4/16.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "Cache.h"
static Cache *_instance;


@interface Cache(){

    dispatch_queue_t queue;

}
@property (nonatomic, strong) NSMutableDictionary *cache;


@end
@implementation Cache

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)sharedCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] _init];
    });
    
    return _instance;
}

- (instancetype)_init
{
    if (self = [super init]) {
         queue = dispatch_queue_create("cache_gcd_mark", DISPATCH_QUEUE_CONCURRENT);
        _cache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    return self;
}

- (id)cacheWithKey:(id)key
{
    __block id obj;
    
    // 任意线程都可以'读'
    dispatch_sync(queue, ^{
        obj = [self.cache objectForKey:key];
    });
    
    return obj;
}

- (void)setCacheObject:(id)obj withKey:(id)key
{
    // 保证同时'写'的的只有一个
    dispatch_barrier_async(queue, ^{
        [self.cache setObject:obj forKey:key];
    });
}

@end
