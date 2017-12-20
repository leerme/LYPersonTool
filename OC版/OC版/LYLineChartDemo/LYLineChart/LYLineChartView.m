//
//  LYLineChartView.m
//  OC版
//
//  Created by jjs on 2017/12/19.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYLineChartView.h"

CGFloat s_x = 30.0;
CGFloat s_y = 50.0;

@interface LYLineChartView()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGFloat maxValue;

@end

@implementation LYLineChartView

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUpSizeWithArray:array];
        [self creatXAlxe];
        [self creatYAxle];
        [self drawDottedLine];
        
        [self drawLineWithArray:array];
    }
    return self;
}

/*根据传进来的数组，获取最大的y轴*/
- (void)setUpSizeWithArray:(NSArray *)arr{
    NSMutableArray *marr = [NSMutableArray array];
    
    for (NSString *v in arr) {
        CGFloat vNum = [v doubleValue];
        [marr addObject:[NSNumber numberWithFloat:vNum]];
    }
    
    //获取最大的数字
    CGFloat maxValue = [[marr valueForKeyPath:@"@max.floatValue"] doubleValue];
    
    NSString *max = [NSString stringWithFormat:@"%0.2lf",maxValue];
    
    //获取最大数的整数部分
    NSString *maxInt = [max componentsSeparatedByString:@"."][0];
    
    //获取第一位的数字的大小
    NSRange r = {0,1};
    NSString *f = [maxInt substringWithRange:r];
    
    NSString *maxStr = @"";
    NSString *newMax = @"";
    if ([f integerValue] < 9) {
        int maxCount = [f intValue] + 1;
        newMax = [NSString stringWithFormat:@"%d",maxCount];
    }else{
        newMax = @"10";
    }
    
    NSString *zero = @"000000";
    
    NSRange suRang = {0,maxInt.length - 1};
    NSString *subZero = [zero substringWithRange:suRang];
    
    maxStr = [NSString stringWithFormat:@"%@%@",newMax,subZero];
    
    self.maxValue = [maxStr integerValue];
    
    CGSize size = [self sizeWithTextContent:maxStr withFont:[UIFont systemFontOfSize:10]];
    if (size.width > 30) {
        s_x = size.width + 10;
    }
    
}

//获取字符串的宽度
- (CGSize)sizeWithTextContent:(NSString *)contentText withFont:(UIFont *)font{
    
    CGSize maxSize = CGSizeMake(self.frame.size.width, 15);
    NSDictionary *attributes = @{NSFontAttributeName:font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    
    CGSize contentTextSize = [contentText boundingRectWithSize:maxSize options:options attributes:attributes context:NULL].size;
    
    return contentTextSize;
}

/*获取坐标轴*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //开启绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线宽
    CGContextSetLineWidth(context, 1.0);
    //绘制线条的颜色
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
    
    //绘制起点
    CGContextMoveToPoint(context, s_x, s_x);
    CGContextAddLineToPoint(context, s_x, rect.size.height - s_y);
    CGContextAddLineToPoint(context, rect.size.width - s_x, rect.size.height - s_y);
    
    CGContextStrokePath(context);
}

/*绘制x轴*/
- (void)creatXAlxe{
    
    CGFloat month = 12;
    
    CGFloat y = self.frame.size.height - s_y + 10;
    CGFloat w = (self.frame.size.width - 2 * s_x)/month;
    
    for (NSInteger i = 0; i < month; i ++) {
        
        CGFloat x = (self.frame.size.width - 2 * s_x)/month * i;
        
        UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake(x + s_x, y, w, s_y/2)];
        
        LabelMonth.tag = 1000 + i;
        LabelMonth.text = [NSString stringWithFormat:@"%ld月",i+1];
        LabelMonth.font = [UIFont systemFontOfSize:10];
        LabelMonth.numberOfLines = 0;
        
        [self addSubview:LabelMonth];
    }
}

/*绘制Y轴*/
- (void)creatYAxle{
    
    for (NSInteger i = 0; i < 6; i++) {
        UILabel * label = (UILabel*)[self viewWithTag:2000 + i];
        [label removeFromSuperview];
    }
    
    CGFloat yDiv = 6;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 6; i ++) {
        CGFloat yValue = self.maxValue / 6.0 * i + self.maxValue / 6.0;
        
        NSString *yValueStr = [NSString stringWithFormat:@"%0lf",yValue];
        [arr addObject:yValueStr];
    }
    
    for (NSInteger i = 0; i < yDiv; i++) {
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height - 2 * s_y)/yDiv *i + s_x, s_x, s_y/2.0)];
        labelYdivision.tag = 2000 + i;
        labelYdivision.text = [NSString stringWithFormat:@"%ld",[arr[5-i] integerValue]];
        labelYdivision.font = [UIFont systemFontOfSize:10];
        labelYdivision.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelYdivision];
    }
}

/*绘制折线*/
- (void)drawLineWithArray:(NSArray *)arr{
    
    for (NSInteger i = 0; i < 12; i++) {
        UILabel * label = (UILabel*)[self viewWithTag:3000 + i];
        [label removeFromSuperview];
    }
    
    [self.shapeLayer removeFromSuperlayer];
    
    
    //获取第一个点数据的坐标
    UILabel *startLabel = (UILabel *)[self viewWithTag:1000];
    
    //创建贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    
    //绘制颜色
    UIColor *color = [UIColor greenColor];
    
    [color set];
    
    //获取第一个点
    CGPoint point = CGPointMake(startLabel.frame.origin.x + 0.5 * startLabel.frame.size.width, (self.maxValue -[arr[0] doubleValue])/ self.maxValue * (self.frame.size.height - s_y * 2) + s_x + s_y / 4.0);
    CGFloat startY = [arr[0] doubleValue];
    
    //显示出第一个点得数值
    UILabel *staValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(startLabel.frame.origin.x, (self.maxValue - startY) / self.maxValue * (self.frame.size.height - s_y * 2) + s_x + 5 + s_y / 4.0, 30, 15)];
    staValueLabel.tag = 3000;
    staValueLabel.font = [UIFont systemFontOfSize:8];
    staValueLabel.text = arr[0];
    [self addSubview:staValueLabel];
    
    [path moveToPoint:point];
    
    //创建折线点
    for (NSInteger i = 1; i < 12; i ++) {
        
        CGFloat y = [arr[i] doubleValue];
        
        UILabel *label = (UILabel *)[self viewWithTag:1000 + i];
        [path addLineToPoint:CGPointMake(label.frame.origin.x + 0.5 * label.frame.size.width , (self.maxValue - y) / self.maxValue * (self.frame.size.height - s_y * 2) + s_x + s_y / 4.0)];
        
        //显示数据
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, (self.maxValue - y) / self.maxValue * (self.frame.size.height - s_y * 2) + s_x + 5 + s_y / 4.0, 30, 15)];
        valueLabel.tag = 3000 + i;
        valueLabel.font = [UIFont systemFontOfSize:8];
        valueLabel.text = arr[i];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:valueLabel];
    }
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineWidth = 2;
    self.shapeLayer.lineCap = kCALineCapRound;
    
    self.shapeLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:self.shapeLayer];
    
}

- (void)drawDottedLine{
    for (NSInteger i = 0;i < 6; i++ ) {
        CAShapeLayer * dashLayer = [CAShapeLayer layer];
        dashLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        dashLayer.fillColor = [[UIColor clearColor] CGColor];
        // 默认设置路径宽度为0，使其在起始状态下不显示
        dashLayer.lineWidth = 0.5;
        UILabel * label1 = (UILabel*)[self viewWithTag:2000 + i];
        
        UIBezierPath * path = [[UIBezierPath alloc]init];
        path.lineWidth = 0.5;
        UIColor * color = [UIColor blueColor];
        
        [color set];
        [path moveToPoint:CGPointMake(CGRectGetMaxX(label1.frame), label1.frame.origin.y + label1.frame.size.height * 0.5)];
        
        [path addLineToPoint:CGPointMake(self.frame.size.width - s_x,label1.frame.origin.y + label1.frame.size.height * 0.5)];
        CGFloat dash[] = {10,10};
        [path setLineDash:dash count:2 phase:CGRectGetMaxX(label1.frame)];
        [path stroke];
        dashLayer.path = path.CGPath;
        [self.layer addSublayer:dashLayer];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 12; i ++) {
        CGFloat a = arc4random()%10000;
        NSString *str = [NSString stringWithFormat:@"%0.0lf",a];
        [arr addObject:str];
    }
    
    [self setUpSizeWithArray:arr];
    [self creatYAxle];
    [self drawLineWithArray:arr];
    
    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.keyPath = @"strokeEnd";
    anima.duration = 3;
    anima.repeatCount = 1;
    anima.removedOnCompletion = YES;
    anima.fromValue = [NSNumber numberWithFloat:0.0f];
    anima.toValue = [NSNumber numberWithFloat:1.0f];
    
    [self.shapeLayer addAnimation:anima forKey:@"strokeEnd"];
    
}

@end
