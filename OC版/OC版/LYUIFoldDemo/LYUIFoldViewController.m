//
//  LYUIFoldViewController.m
//  OC版
//
//  Created by jjs on 2018/3/6.
//  Copyright © 2018年 iOS-LeiYu. All rights reserved.
//

#import "LYUIFoldViewController.h"

@interface LYUIFoldViewController ()

@end

@implementation LYUIFoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.backgroundColor = [UIColor greenColor];
    [button1 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
     button1.frame = CGRectMake(100, 150, 100, 100);
    [self.view addSubview:button1];
    
   
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blueColor];
    view.frame = CGRectMake(100, 300, 100, 100);
    [self.view addSubview:view];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.backgroundColor = [UIColor greenColor];
    [button3 addTarget:self action:@selector(click3) forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(50, 50, 100, 50);
    [view addSubview:button3];
    
    UIImage *I = [[UIImage alloc] init];
    UIImage *d = [UIImage imageNamed:@"imageNamed"];
}

- (void)click1{
    NSLog(@"1");
}

- (void)click2{
    NSLog(@"2");
}

- (void)click3{
    NSLog(@"3");
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
