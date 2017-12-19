//
//  LYRollingNoticeViewController.m
//  OC版
//
//  Created by jjs on 2017/12/15.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYRollingNoticeViewController.h"
#import "LYRollingNoticeView.h"
#import "LYRollingCell2.h"


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
    
    [self addRollingNoticeView];
}

- (void)addRollingNoticeView{
    float width = [[UIScreen mainScreen] bounds].size.width;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, width, 100)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"滚动公告、广告，支持自定义cell";
    [self.view addSubview:label];
    
    _arr0 = @[@"快速排序（Quicksort）是对冒泡排序的一种改进",
              @"快速排序由C. A. R. Hoare在1962年提出。",
              @"它的基本思想是：通过一趟排序将要排序的数据",
              @"分割成独立的两部分",
              @"其中一部分的所有数据都比另外一部分"
              ];
    
    _arr1 = @[
              @{@"arr": @[@{@"tag": @"快排", @"title": @"1．先从数列中取出一个数作为基准数"},
                          @{@"tag": @"思想", @"title": @"2．分区过程，将比这个数大的数全放到它的右边"}], @"img": @"tb_icon2"},
              @{@"arr": @[@{@"tag": @"手机", @"title": @"3．再对左右区间重复第二步"},
                          @{@"tag": @"围观", @"title": @"直到各区间只有一个数。"}], @"img": @"tb_icon3"},
              @{@"arr": @[@{@"tag": @"园艺", @"title": @"简单地理解就是,找一个基准数"},
                          @{@"tag": @"手机", @"title": @"待排序的任意数,一般都是选定首元素"}], @"img": @"tb_icon5"},
              @{@"arr": @[@{@"tag": @"开发", @"title": @"因为相比冒泡排序"},
                          @{@"tag": @"博客", @"title": @"每次交换是跳跃式的"}], @"img": @"tb_icon1"},
              @{@"arr": @[@{@"tag": @"招聘", @"title": @"这样在每次交换的时"},
                          @{@"tag": @"资讯", @"title": @"交换的距离就大的多了"}], @"img": @"tb_icon4"}
              ];
    
    [self creatRollingViewWithArray:_arr0 type:RollingNoticeEasy];
    [self creatRollingViewWithArray:_arr1 type:RollingNoticeComplex];
}

- (void)creatRollingViewWithArray:(NSArray *)arr type:(RollingNotice)type
{
    float w = [[UIScreen mainScreen] bounds].size.width;
    CGRect frame = CGRectMake(0, 150, w, 30);
    if (type == RollingNoticeComplex) {
        frame = CGRectMake(0, 250, w, 50);
    }
    
    LYRollingNoticeView *noticeView = [[LYRollingNoticeView alloc]initWithFrame:frame];
    
    noticeView.delegate = self;
    noticeView.dataSource = self;
    [self.view addSubview:noticeView];
    noticeView.backgroundColor = [UIColor lightGrayColor];
    [noticeView registerClass:[LYNotiveViewCell class] forCellReuseIdentifier:@"LYNotiveViewCell"];
    [noticeView registerNib:[UINib nibWithNibName:@"LYRollingCell2" bundle:nil] forCellReuseIdentifier:@"LYRollingCell2"];
    
    if (type == RollingNoticeEasy) {
        self.rollingNoticeView0 = noticeView;
    }else if (type == RollingNoticeComplex){
        self.rollingNoticeView1 = noticeView;
        noticeView.stayInterVal = 4;
        noticeView.animateInterVal = 1;
    }
    
    [noticeView reloadDataAndStartRoll];
}

- (NSInteger)numberOfRowsForRollingNoticeView:(LYRollingNoticeView *)rollingView
{
    if (rollingView == self.rollingNoticeView0) {
        return _arr0.count;
    }else if (rollingView == self.rollingNoticeView1){
        return  _arr1.count;
    }
    return 0;
}

- (LYNotiveViewCell *)rollingNoticeView:(LYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index{
    if (rollingView == self.rollingNoticeView0){
        LYNotiveViewCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"LYNotiveViewCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%lu %@",(unsigned long)index,_arr0[index]];
        cell.contentView.backgroundColor = [UIColor yellowColor];
        if (index % 2 == 0) {
            cell.contentView.backgroundColor = [UIColor cyanColor];
        }
        return cell;
    }else{
        LYRollingCell2 *cell = [rollingView dequeueReusableCellWithIdentifier:@"LYRollingCell2"];
        [cell noticeCellWithArr:_arr1 forIndex:index];
        return cell;
    }
}

@end
