//
//  Cache.h
//  LeeGCDDemo
//
//  Created by MacBook on 2017/4/16.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject
+ (instancetype)sharedCache;

- (id)cacheWithKey:(id)key;

- (void)setCacheObject:(id)obj withKey:(id)key;
@end
