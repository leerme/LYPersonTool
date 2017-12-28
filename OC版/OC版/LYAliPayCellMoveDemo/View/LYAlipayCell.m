//
//  LYAlipayCell.m
//  OC版
//
//  Created by jjs on 2017/12/26.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYAlipayCell.h"


@interface LYAlipayCell()

@property (weak, nonatomic) IBOutlet UIView *myBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation LYAlipayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.myBackgroundView.layer.cornerRadius = 10;
    self.myBackgroundView.layer.masksToBounds = YES;
}

- (void)setModel:(LYAlipayModel *)model{
    if (model == _model) {
        return;
    }
    _model = model;
    self.nameLabel.text = model.title;
    self.iconImageView.image = [UIImage imageNamed:model.iconName];
}

@end
