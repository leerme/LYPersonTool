//
//  SlideMenuButton.m
//  OC版
//
//  Created by jjs on 2018/1/3.
//  Copyright © 2018年 iOS-LeiYu. All rights reserved.
//

#import "SlideMenuButton.h"

@interface SlideMenuButton()

@property (nonatomic, strong) NSString *buttonTitle;

@end

@implementation SlideMenuButton

- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.buttonTitle = title;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
}


@end
