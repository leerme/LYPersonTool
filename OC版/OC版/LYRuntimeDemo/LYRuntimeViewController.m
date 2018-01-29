//
//  LYRuntimeDemoController.m
//  OC版
//
//  Created by jjs on 2018/1/23.
//  Copyright © 2018年 iOS-LeiYu. All rights reserved.
//

#import "LYRuntimeViewController.h"

@interface NSObject (Sark)
+ (void)foo;
@end

@implementation NSObject (Sark)

- (void)foo {
    NSLog(@"IMP: -[NSObject (Sark) foo]");
}
@end


@interface Sark : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name1;
@property (nonatomic, copy) NSString *name2;
@end
@implementation Sark
- (void)speak {
    NSLog(@"my name's %@", self.name);
    NSLog(@"my name's %@", self.name1);
    NSLog(@"my name's %p", &self.name2);
}
@end

@interface LYRuntimeViewController ()

@end

@implementation LYRuntimeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    id cls = [Sark class];
    void *obj = &cls;
    
    [(__bridge id)obj speak];
//    [Sark foo];
//    [[Sark new] foo];
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
