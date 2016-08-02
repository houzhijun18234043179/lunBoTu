//
//  NSTimer+Addition.m
//  CycleView轮播图的封装
//
//  Created by LiuDan on 16/1/19.
//  Copyright © 2016年 LiuDan. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

// 暂停
- (void)pauseTimer{
    if (![self isValid]) { // 判断是否有效，无效直接返回
        return;
    }
    // 有效
    [self setFireDate:[NSDate distantFuture]];
}

// 继续
- (void)resumeTimer{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

// 在多少秒后继续
- (void)resumeTimerAfterTimeinteval:(NSTimeInterval)timeInterval{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
}

@end
