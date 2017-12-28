//
//  LYWaveViewController.m
//  OC版
//
//  Created by jjs on 2017/12/19.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYWaveViewController.h"
#import "LYWaveView.h"
#import "UIViewController+title.h"


@interface LYWaveViewController ()

@end

@implementation LYWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self getTitle];
    
    LYWaveView * waveView = [[LYWaveView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    waveView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:waveView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:label];
    
    label.text = @"往下拉";
    label.font = [UIFont systemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = self.view.center;
}



@end
