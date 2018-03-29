//
//  LYHorseRaceLampView.h
//  OC版
//
//  Created by jjs on 2018/3/29.
//  Copyright © 2018年 iOS-LeiYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_TEXT_COLOR [UIColor whiteColor]
#define DEFAULT_TEXT_FONTSIZE 16

@interface LYHorseRaceLampView : UIView

@property (nonatomic, strong)UIColor *textColor;

@property (nonatomic, assign)CGFloat fontSize;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;

- (void)start;//开始跑马
- (void)stop;//停止跑马

@end
