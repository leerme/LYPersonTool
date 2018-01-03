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
    return [self initWithTitles:titles withButtonHeight:40.0f withMenuColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1] withBackBlurStyle:UIBlurEffectStyleDark];
}
- (instancetype)initWithTitles:(NSArray *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style{
    self = [super init];
    if (self) {
        keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        blurView = [[UIVisualEffectView  alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
        blurView.frame = keyWindow.frame;
        blurView.alpha = 0.0f;
        
        helperSideView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
        helperSideView.backgroundColor = [UIColor redColor];
        helperSideView.hidden = YES;
        [keyWindow addSubview:helperSideView];
        
        helperCenterView = [[UIView alloc] initWithFrame:CGRectMake(-40, CGRectGetHeight(keyWindow.frame)/2 - 20, 40, 40)];
        helperCenterView.backgroundColor = [UIColor yellowColor];
        helperCenterView.hidden = YES;
        [keyWindow addSubview:helperCenterView];
        
        self.frame = CGRectMake(-keyWindow.frame.size.width/2 - MenuBlankWidth, 0, keyWindow.frame.size.width/2 + MenuBlankWidth, keyWindow.frame.size.width);
        self.backgroundColor = [UIColor clearColor];
        [keyWindow insertSubview:self belowSubview:helperSideView];
        
        _menuColor = menuColor;
        menuButtonHeight = height;
        [self addButtons:titles];
    }
    return self;
}

- (void)addButtons:(NSArray *)titles{
    if (titles.count % 2 == 0) {
        NSInteger index_down = titles.count / 2;
        NSInteger index_up = -1;
        for (NSInteger i = 0; i < titles.count; i++) {
            NSString *title = titles[i];
            
        }
        
    }
}


@end
