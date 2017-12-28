//
//  LYAlipayModel.h
//  OC版
//
//  Created by jjs on 2017/12/26.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYAlipayModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *iconName;

+ (instancetype)modelWithTitle:(NSString *)title iconName:(NSString *)iconName;

@end
