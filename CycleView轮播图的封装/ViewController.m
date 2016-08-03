//
//  ViewController.m
//  CycleView轮播图的封装
//
//  Created by LiuDan on 16/1/19.
//  Copyright © 2016年 LiuDan. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()

@property (nonatomic, strong)CycleScrollView * cycleScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /**
     *  创建网络连接图片
     */
    NSString *string = @"http://img2.a0bi.com/upload/ttq/20140722/1405995619576_middle.jpg";
    NSString *string1 = @"http://ww2.sinaimg.cn/mw600/c6c1d258jw1e5r59ttpkcj20gu0gsmyh.jpg";
    NSString *string2 = @"http://ww1.sinaimg.cn/mw600/bce7ca57gw1e4rg0coeqqj20dw099myu.jpg";
    NSString *string3 = @"http://imgsrc.baidu.com/forum/w%3D580/sign=7fc5b239b9a1cd1105b672288912c8b0/51b0f603738da977be0bd022b351f8198618e3b7.jpg";
    NSMutableArray * urlArray = [NSMutableArray arrayWithObjects:string,string1,string2,string3, nil];
    self.cycleScrollView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 240) animationDuration:3];
    [self.view addSubview:self.cycleScrollView];
    
    // view数组
    NSMutableArray * viewArray = [@[]mutableCopy];
    for (int i = 0; i < urlArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:_cycleScrollView.bounds];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlArray[i]]];
        [viewArray addObject:imageView];
    }
    
    self.cycleScrollView.totalPageCount = viewArray.count;
    
    // 刷新页面
    self.cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex) {
        return viewArray[pageIndex];
    };
    
    // 点击页面
    self.cycleScrollView.TapActionBlock = ^(NSInteger pageIndex) {
         NSLog(@"当前页面点击的是%ld",pageIndex);
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
