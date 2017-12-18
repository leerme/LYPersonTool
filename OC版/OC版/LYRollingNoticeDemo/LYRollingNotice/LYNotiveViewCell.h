//
//  LYNotiveViewCell.h
//  OC版
//
//  Created by jjs on 2017/12/15.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYNotiveViewCell : UIView

@property (nonatomic, readonly, strong) UIView *contentView;
@property (nonatomic, readonly, strong) UILabel *textLabel;
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end
