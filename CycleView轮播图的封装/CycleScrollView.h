//
//  CycleScrollView.h
//  CycleView轮播图的封装
//
//  Created by LiuDan on 16/1/19.
//  Copyright © 2016年 LiuDan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView<UIScrollViewDelegate>

// 自定义初始化方法
// CGRect  定义滑动视图的大小
// NSTimeInterval 定义滚动的时间的间隔
// return 返回当前初始化对象
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

// 刷新页面
// 把下标传过去，有参有返回值
@property (nonatomic, copy) UIView * (^fetchContentViewAtIndex)(NSInteger pageIndex);

// 点击页面,有参无返回值
@property (nonatomic, copy) void (^TapActionBlock)(NSInteger pageIndex);


// 设置PageControl页面图片总个数
@property (nonatomic, assign)NSInteger totalPageCount;

@end
