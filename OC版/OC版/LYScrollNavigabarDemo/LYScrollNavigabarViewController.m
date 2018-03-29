//
//  LYScrollNavigabarViewController.m
//  OC版
//
//  Created by jjs on 2018/3/29.
//  Copyright © 2018年 iOS-LeiYu. All rights reserved.
//

#import "LYScrollNavigabarViewController.h"
#import "LYHorseRaceLampView.h"

@interface LYScrollNavigabarViewController ()

@end

@implementation LYScrollNavigabarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    LYHorseRaceLampView* paomav = [[LYHorseRaceLampView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-150, 44) title:@"雷雨用来测试滚动的Navigation的一个小demo需要一个很长很长很长很长的title"];
    paomav.textColor = [UIColor orangeColor];
    self.navigationItem.titleView = paomav;
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
