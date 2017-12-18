//
//  DelegateManager.h
//  OC版
//
//  Created by jjs on 2017/12/15.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DelegateManager : NSObject <UITableViewDelegate, UITableViewDataSource>

+ (instancetype)delegateManagerWithInformations:(NSArray*)informationArray navigationController:(UINavigationController *)navigationController;

@end
