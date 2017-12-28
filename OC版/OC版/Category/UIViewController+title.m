//
//  UIViewController+title.m
//  OC版
//
//  Created by jjs on 2017/12/26.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "UIViewController+title.h"

@implementation UIViewController (title)
- (NSString *)getTitle{
    return [[NSStringFromClass(self.class) stringByReplacingOccurrencesOfString:@"LY" withString:@""] stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
}
@end
