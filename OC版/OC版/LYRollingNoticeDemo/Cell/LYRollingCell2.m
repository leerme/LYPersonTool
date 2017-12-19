//
//  LYRollingCell2.m
//  
//
//  Created by jjs on 2017/12/18.
//

#import "LYRollingCell2.h"

@interface LYRollingCell2 ()

@property (weak, nonatomic) IBOutlet UIImageView *trailIconImgView;

@property (weak, nonatomic) IBOutlet UILabel *tagLab0;
@property (weak, nonatomic) IBOutlet UILabel *titleLab0;

@property (weak, nonatomic) IBOutlet UILabel *tagLab1;
@property (weak, nonatomic) IBOutlet UILabel *titleLab1;

@end


@implementation LYRollingCell2

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _tagLab0.layer.borderColor = [UIColor orangeColor].CGColor;
    _tagLab0.layer.borderWidth = 0.5;
    _tagLab0.layer.cornerRadius = 3;
    
    _tagLab1.layer.borderColor = [UIColor orangeColor].CGColor;
    _tagLab1.layer.borderWidth = 0.5;
    _tagLab1.layer.cornerRadius = 3;
}

- (void)noticeCellWithArr:(NSArray *)arr forIndex:(NSUInteger)index
{
    NSDictionary *dic = arr[index];
    _trailIconImgView.image = [UIImage imageNamed:dic[@"img"]];
    
    _tagLab0.text = [dic[@"arr"] firstObject][@"tag"];
    _titleLab0.text = [dic[@"arr"] firstObject][@"title"];
    
    _tagLab1.text = [dic[@"arr"] lastObject][@"tag"];
    _titleLab1.text = [dic[@"arr"] lastObject][@"title"];
    
}

@end
