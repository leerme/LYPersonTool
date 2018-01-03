//
//  SlideMenuButton.h
//  OC版
//
//  Created by jjs on 2018/1/3.
//  Copyright © 2018年 iOS-LeiYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuButton : UIView

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic, strong) UIColor *buttonColor;

@property (nonatomic, copy) void (^buttonClickBlock)(void);

@end
