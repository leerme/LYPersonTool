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
    [self.buttonColor set];
    CGContextFillPath(context);
    
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:rect.size.height/2];
    [self.buttonColor setFill];
    [roundedRectanglePath fill];
    [[UIColor whiteColor] setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attr = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:24.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGSize size = [self.buttonTitle sizeWithAttributes:attr];
    CGRect r = CGRectMake(rect.origin.x,
                          rect.origin.y + (rect.size.height - size.height)/2.0,
                          rect.size.width,
                          size.height);
    [self.buttonTitle drawInRect:r withAttributes:attr];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            self.buttonClickBlock();
            break;
            
        default:
            break;
    }
}


@end
