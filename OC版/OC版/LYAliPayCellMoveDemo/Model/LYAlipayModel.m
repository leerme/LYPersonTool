//
//  LYAlipayModel.m
//  OC版
//
//  Created by jjs on 2017/12/26.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYAlipayModel.h"

@implementation LYAlipayModel

+ (instancetype)modelWithTitle:(NSString *)title iconName:(NSString *)iconName{
    LYAlipayModel *model = [[LYAlipayModel alloc] init];
    model.title = title;
    model.iconName = iconName;
    return model;
}
@end
