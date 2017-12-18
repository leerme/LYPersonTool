//
//  LYRollingNoticeViewController.m
//  OC版
//
//  Created by jjs on 2017/12/15.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYRollingNoticeViewController.h"
#import "LYRollingNoticeView.h"



typedef enum : NSUInteger {
    RollingNoticeEasy,
    RollingNoticeComplex
} RollingNotice;

@interface LYRollingNoticeViewController ()<LYRollingNoticeViewDelegate,LYRollingNoticeViewDataSource>

@property (strong, nonatomic) NSArray *arr0;
@property (strong, nonatomic) NSArray *arr1;

@property (strong, nonatomic) LYRollingNoticeView *rollingNoticeView0;
@property (strong, nonatomic) LYRollingNoticeView *rollingNoticeView1;

@end

@implementation LYRollingNoticeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    float width = [[UIScreen mainScreen] bounds].size.width;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, width, 100)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"滚动公告、广告，支持自定义cell";
    [self.view addSubview:label];
    
    _arr0 = @[@"小米千元全面屏：抱歉，久等！625献上",
              @"可怜狗狗被抛弃，苦苦等候主人半年",
              @"三星中端新机改名，全面屏火力全开",
              @"学会这些，这5种花不用去花店买了",
              @"华为nova2S发布，剧透了荣耀10？"
              ];
    
    _arr1 = @[
              @{@"arr": @[@{@"tag": @"手机", @"title": @"小米千元全面屏：抱歉，久等！625献上"}, @{@"tag": @"萌宠", @"title": @"可怜狗狗被抛弃，苦苦等候主人半年"}], @"img": @"tb_icon2"},
              @{@"arr": @[@{@"tag": @"手机", @"title": @"三星中端新机改名，全面屏火力全开"}, @{@"tag": @"围观", @"title": @"主人假装离去，狗狗直接把孩子推回去了"}], @"img": @"tb_icon3"},
              @{@"arr": @[@{@"tag": @"园艺", @"title": @"学会这些，这5种花不用去花店买了"}, @{@"tag": @"手机", @"title": @"华为nova2S发布，剧透了荣耀10？"}], @"img": @"tb_icon5"},
              @{@"arr": @[@{@"tag": @"开发", @"title": @"iOS 内购最新讲解"}, @{@"tag": @"博客", @"title": @"技术博客那些事儿"}], @"img": @"tb_icon6"},
              @{@"arr": @[@{@"tag": @"招聘", @"title": @"招聘XX高级开发工程师"}, @{@"tag": @"资讯", @"title": @"如何写一篇好的技术博客"}], @"img": @"tb_icon7"}
              ];
    
    [self creatRollingViewWithArray:_arr0 type:RollingNoticeEasy];
//    [self creatRollingViewWithArray:_arr1 type:RollingNoticeComplex];
}

- (void)creatRollingViewWithArray:(NSArray *)arr type:(RollingNotice)type
{
    float w = [[UIScreen mainScreen] bounds].size.width;
    CGRect frame = CGRectMake(0, 150, w, 50);
    if (type == RollingNoticeComplex) {
        frame = CGRectMake(0, 250, w, 30);
    }
    
    LYRollingNoticeView *noticeView = [[LYRollingNoticeView alloc]initWithFrame:frame];
    noticeView.delegate = self;
    noticeView.dataSource = self;
    [self.view addSubview:noticeView];
    noticeView.backgroundColor = [UIColor lightGrayColor];
    [noticeView registerClass:[LYNotiveViewCell class] forCellReuseIdentifier:@"LYNotiveViewCell"];
    
    [noticeView reloadDataAndStartRoll];
}

- (NSInteger)numberOfRowsForRollingNoticeView:(LYRollingNoticeView *)rollingView
{
    return 3;
}

- (LYNotiveViewCell *)rollingNoticeView:(LYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index{
    LYNotiveViewCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"LYNotiveViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"第%lu种cell%@",(unsigned long)index,_arr0[index]];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    if (index % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor greenColor];
    }
    return cell;
}

@end
