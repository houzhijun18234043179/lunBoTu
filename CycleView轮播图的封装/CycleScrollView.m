//
//  CycleScrollView.m
//  CycleView轮播图的封装
//
//  Created by LiuDan on 16/1/19.
//  Copyright © 2016年 LiuDan. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"
@interface CycleScrollView ()

@property (nonatomic, strong)UIScrollView * scrollView; // 滑动视图
@property (nonatomic, strong)UIPageControl * pageControl;
@property (nonatomic, strong)NSTimer * animationTimer;  // 定时器
@property (nonatomic, assign)NSTimeInterval animationDuration;  // 时间间隔
@property (nonatomic, strong)NSMutableArray * contentViews;  // 用来存放内容视图
@property (nonatomic, assign)NSInteger cunrrentPageIndex;  // 当前页数

@end

@implementation CycleScrollView

#pragma mark ---- 初始化方法 ----
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置子视图自动调整布局
        self.autoresizesSubviews = YES;
        self.cunrrentPageIndex = 0;  // 默认显示的是第一页
        
        // 创建UIScrollView
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        // 居中显示
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3*CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);  // 显示中间的位置
        self.scrollView.pagingEnabled = YES;  // 整页翻动
        self.scrollView.bounces = NO;  // 不允许反弹
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;  // 设置代理
        [self addSubview:self.scrollView];
        
        // 创建UIPageControl
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame) - 100, CGRectGetHeight(self.scrollView.frame) - 30, 100, 30)];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

// 自定义初始化方法
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration{
    
    self = [self initWithFrame:frame];
    
    // 创建定时器
    if (animationDuration > 0.0f) {
        self.animationDuration = animationDuration;
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(animationTimeDidFired:) userInfo:nil repeats:YES];
//        [self.animationTimer invalidate];  // 销毁定时器
        
        // 暂停
        [self.animationTimer pauseTimer];
    }
    return self;
}

#pragma mark ---- NSTimer的定时方法 ----
-(void)animationTimeDidFired:(NSTimer *)timer{
    CGPoint newPoint = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newPoint animated:YES];
}

// 重写totalPageControl的set方法
- (void)setTotalPageCount:(NSInteger)totalPageCount{
    
    _totalPageCount = totalPageCount;
    if (_totalPageCount > 0) {
        // 配置内容页面
        [self configContentViews];
        
        // 开启定时器
        [self.animationTimer resumeTimerAfterTimeinteval:self.animationDuration];
        
    }
    
}

// 配置内容页面
- (void)configContentViews {
    
    // 将scrollView上的视图全部移除
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 设置scrollView的内容数据
    [self setScrollViewContentDataSource];
    
    // 遍历数组
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        
        // 添加单击手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tap];
        
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame)*(counter++), 0);
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    // 始终显示在中间的位置
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0)];
}

// 设置scrollView的内容数据
- (void)setScrollViewContentDataSource {
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    // 获取上一个页面位置和下一个页面位置
    NSInteger beforePageIndex = [self getNextPageIndex:self.cunrrentPageIndex - 1];
    NSInteger afterPageIndex = [self getNextPageIndex:self.cunrrentPageIndex + 1];
    // 回调
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(beforePageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_cunrrentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(afterPageIndex)];
    }
}

// 获取下一个页面位置
- (NSInteger)getNextPageIndex:(NSInteger)nextPageIndex {
    if (nextPageIndex == -1) {
        return self.totalPageCount - 1;
    }else if (nextPageIndex == self.totalPageCount) {
        return 0;
    }else{
        return nextPageIndex;
    }
}

// 点击页面,进行回调
- (void)contentViewTapAction:(UITapGestureRecognizer *)gesture{
    
    if (self.TapActionBlock) {
        self.TapActionBlock(self.cunrrentPageIndex);
    }
    
}

#pragma mark ---- UIScrollView的代理方法 ----
// 开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    // 滑动视图时讲定时器暂停，防止手动滑动与自动滑动冲突
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 手动滑动结束后，定时器继续
    [self.animationTimer resumeTimerAfterTimeinteval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int contentOffSetX = scrollView.contentOffset.x;
    // 如果是最后一页
    if (contentOffSetX >= 2*CGRectGetWidth(scrollView.frame)) {
        self.cunrrentPageIndex = [self getNextPageIndex:self.cunrrentPageIndex + 1];
        [self configContentViews];
    }
    // 如果是第一页
    if (contentOffSetX <= 0) {
        self.cunrrentPageIndex = [self getNextPageIndex:self.cunrrentPageIndex - 1];
        [self configContentViews];
    }
    
    // pageControl
    _pageControl.currentPage = self.cunrrentPageIndex;
}

// 滚动完之后,显示在中间位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
    
}


@end
