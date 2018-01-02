//
//  LYSlideMenuView.m
//  OC版
//
//  Created by jjs on 2018/1/2.
//  Copyright © 2018年 iOS-LeiYu. All rights reserved.
//

#import "LYSlideMenuView.h"


#define ButtonSpace 30
#define MenuBlankWidth 50

@interface LYSlideMenuView()

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) NSInteger animationCount;

@end

@implementation LYSlideMenuView
{
    UIVisualEffectView *blurView;
    UIView *helperSideView;
    UIView *helperCenterView;
    UIWindow *keyWindow;
    BOOL triggered;
    CGFloat diff;
    UIColor *_menuColor;
    CGFloat menuButtonHeight;
}

- (instancetype)initWithTitles:(NSArray *)titles{
    
}
- (instancetype)initWithTitles:(NSArray *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style{
    
}

@end
