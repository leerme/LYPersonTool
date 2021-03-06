//
//  ViewController.m
//  OC版
//
//  Created by jjs on 2017/12/14.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "ViewController.h"
#import "DelegateManager.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *informationArray;
@property (strong, nonatomic) DelegateManager *delegateManager;

@end

@implementation ViewController

#pragma mark - Lift Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _informationArray = @[@"RollingNoticeDemo",
                          @"WaveDemo",
                          @"LineChartDemo",
                          @"CellFoldDemo",
                          @"AliPayCellMoveDemo",
                          @"SlideMenuDemo",
                          @"RuntimeDemo",
                          @"UIFoldDemo",
                          @"ScrollNavigabarDemo"];
    self.tableView.rowHeight = 40;
    self.tableView.delegate = self.delegateManager;
    self.tableView.dataSource = self.delegateManager;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (DelegateManager *)delegateManager{
    if (!_delegateManager) {
        _delegateManager = [DelegateManager delegateManagerWithInformations:self.informationArray navigationController:self.navigationController];
    }
    return _delegateManager;
}

@end

