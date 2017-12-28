//
//  LYLineChartViewController.m
//  OC版
//
//  Created by jjs on 2017/12/19.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYLineChartViewController.h"
#import "LYLineChartView.h"
#import "UIViewController+title.h"

@interface LYLineChartViewController ()

@end

@implementation LYLineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self getTitle];
    
    NSArray *arr = @[@"922",@"345",@"256",@"546",@"955",@"351",@"421",@"220",@"304",@"553",@"656",@"158"];
    
    LYLineChartView *lineChartView = [[LYLineChartView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 300) withArray:arr];
    [self.view addSubview:lineChartView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
