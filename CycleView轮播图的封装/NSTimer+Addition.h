//
//  NSTimer+Addition.h
//  CycleView轮播图的封装
//
//  Created by LiuDan on 16/1/19.
//  Copyright © 2016年 LiuDan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

// 暂停
- (void)pauseTimer;
// 继续
- (void)resumeTimer;
// 在多少秒后继续
- (void)resumeTimerAfterTimeinteval:(NSTimeInterval)timeInterval;

@end
