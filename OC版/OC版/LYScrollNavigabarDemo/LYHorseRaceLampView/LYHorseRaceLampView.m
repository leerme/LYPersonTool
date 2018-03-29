//
//  LYHorseRaceLampView.m
//  OC版
//
//  Created by jjs on 2018/3/29.
//  Copyright © 2018年 iOS-LeiYu. All rights reserved.
//

#import "LYHorseRaceLampView.h"


@interface LYHorseRaceLampView()

@property (nonatomic, strong)UILabel *textLabel;
@property (nonatomic, strong)UILabel *reserveTextLabel;
@property (nonatomic, assign)NSTimeInterval timeInterval;//时间

@end

@implementation LYHorseRaceLampView{
    CGRect rectMark1;//标记第一个位置
    CGRect rectMark2;//标记第二个位置
    
    NSMutableArray* labelArr;
    
    BOOL isStop;//停止
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        title = [NSString stringWithFormat:@"  %@  ",title];//间隔
        
        self.timeInterval = [self displayDurationForString:title];
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        //
        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel = textLabel;
        textLabel.textColor = DEFAULT_TEXT_COLOR;
        textLabel.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONTSIZE];
        textLabel.text = title;
        
        //计算textLb大小
        CGSize sizeOfText = [textLabel sizeThatFits:CGSizeZero];
        
        rectMark1 = CGRectMake(0, 0, sizeOfText.width, self.bounds.size.height);
        rectMark2 = CGRectMake(rectMark1.origin.x+rectMark1.size.width, 0, sizeOfText.width, self.bounds.size.height);
        
        textLabel.frame = rectMark1;
        [self addSubview:textLabel];
        
        labelArr = [NSMutableArray arrayWithObject:textLabel];
        
        
        //判断是否需要reserveTextLb
        BOOL useReserve = sizeOfText.width > frame.size.width ? YES : NO;
        
        if (useReserve) {
            //alloc reserveTextLb ...
            
            UILabel* reserveTextLabel = [[UILabel alloc] initWithFrame:rectMark2];
            self.reserveTextLabel = reserveTextLabel;
            reserveTextLabel.textColor = DEFAULT_TEXT_COLOR;
            reserveTextLabel.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONTSIZE];
            reserveTextLabel.text = title;
            [self addSubview:reserveTextLabel];
            
            [labelArr addObject:reserveTextLabel];
            
            [self paomaAnimate];
        }else{
            textLabel.center = CGPointMake(self.center.x, textLabel.center.y);
        }
    }
    return self;
}

- (void)setTextColor:(UIColor *)textColor{
    self.textLabel.textColor = textColor;
    self.reserveTextLabel.textColor = textColor;
}

- (void)setFontSize:(CGFloat)fontSize{
    self.textLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    self.reserveTextLabel.font = [UIFont boldSystemFontOfSize:fontSize];
}

- (void)paomaAnimate{
    
    if (!isStop) {
        UILabel* lbindex0 = labelArr[0];
        UILabel* lbindex1 = labelArr[1];
        
        [UIView transitionWithView:self duration:self.timeInterval options:UIViewAnimationOptionCurveLinear animations:^{
            lbindex0.frame = CGRectMake(-rectMark1.size.width, 0, rectMark1.size.width, rectMark1.size.height);
            lbindex1.frame = CGRectMake(lbindex0.frame.origin.x+lbindex0.frame.size.width, 0, lbindex1.frame.size.width, lbindex1.frame.size.height);
            
        } completion:^(BOOL finished) {
            lbindex0.frame = rectMark2;
            lbindex1.frame = rectMark1;
            
            [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
            [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
            //            [self stop];
            //
            [self performSelector:@selector(start) withObject:nil afterDelay:2];
            
            //            [self paomaAnimate];
        }];
    }
}


- (void)start{
    isStop = NO;
    UILabel* lbindex0 = labelArr[0];
    UILabel* lbindex1 = labelArr[1];
    lbindex0.frame = rectMark2;
    lbindex1.frame = rectMark1;
    
    [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
    [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
    
    [self paomaAnimate];
    
}
- (void)stop{
    isStop = YES;
}

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    return string.length/3;
}


@end
