//
//  LYSlideMenuView.h
//  OC版
//
//  Created by jjs on 2018/1/2.
//  Copyright © 2018年 iOS-LeiYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuButtonClickedBlock)(NSInteger index,NSString *title,NSInteger titleCounts);

@interface LYSlideMenuView : UIView

- (instancetype)initWithTitles:(NSArray *)titles;

- (instancetype)initWithTitles:(NSArray *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style;

- (void)trigger;

@property (copy, nonatomic) MenuButtonClickedBlock menuClickBlock;

@end
