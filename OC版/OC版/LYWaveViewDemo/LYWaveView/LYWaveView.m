//
//  LYWaveView.m
//  OC版
//
//  Created by jjs on 2017/12/19.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYWaveView.h"

#define DEVICE_WIDTH    ([[UIScreen mainScreen] bounds].size.width)                  // 屏幕宽度
#define DEVICE_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)                 // 屏幕长度
#define MIN_HEIGHT          64

@interface LYWaveView()

@property (nonatomic, assign) CGFloat mHeight;
//红色哪个点得坐标的x值
@property (nonatomic, assign) CGFloat curveX;
//红色哪个点的坐标的Y值
@property (nonatomic, assign) CGFloat curveY;
//对应哪个红色的点对应的视图
@property (nonatomic, strong) UIView *curveView;
//性状对应的layer
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
//这个东西的主要作用是让上面的shapelayer运行多次
@property (nonatomic, strong) CADisplayLink *displayLink;
//上面哪个东西是否运行
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation LYWaveView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor cyanColor].CGColor;
        [self.layer addSublayer:_shapeLayer];
        
        _curveX = DEVICE_WIDTH/2.0;
        _curveY = MIN_HEIGHT;
        _curveView = [[UIView alloc] initWithFrame:CGRectMake(_curveX, _curveY, 3, 3)];
        _curveView.backgroundColor = [UIColor redColor];
        [self addSubview:_curveView];
        _mHeight = 100;
        _isAnimating = NO;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:pan];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calulatePath)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink.paused = YES;
    }
    [self updateShapeLayerPath];
    return self;
}

- (void)handlePanAction:(UIPanGestureRecognizer *)pan{
    if (!_isAnimating) {
        if (pan.state == UIGestureRecognizerStateChanged) {
            CGPoint point = [pan translationInView:self];
            
            _mHeight = point.y * 0.7 + MIN_HEIGHT;
            _curveX = DEVICE_WIDTH / 2.0 + point.x  ;
            _curveY = _mHeight > MIN_HEIGHT ? _mHeight : MIN_HEIGHT;
            _curveView.frame = CGRectMake(_curveX, _curveY, _curveView.frame.size.width, _curveView.frame.size.height);;
            
//           更新_shapeLayer的形状
            [self updateShapeLayerPath];
        }else if (pan.state == UIGestureRecognizerStateCancelled ||
                  pan.state == UIGestureRecognizerStateEnded ||
                  pan.state == UIGestureRecognizerStateFailed){
            _isAnimating = YES;
            _displayLink.paused = NO;
            
            [UIView animateWithDuration:1.0
                                  delay:0.0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 _curveView.frame = CGRectMake(DEVICE_WIDTH/2, MIN_HEIGHT, 3, 3);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     _displayLink.paused = YES;
                                     _isAnimating = NO;
                                 }
                             }];
        }
    }
}


#pragma mark 每次更新的时候，都初始化一个path，然后重新绘制shapelayer
- (void)updateShapeLayerPath{
//   更新_shapeLayer形状
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(DEVICE_WIDTH, 0)];
    [path addLineToPoint:CGPointMake(DEVICE_WIDTH, MIN_HEIGHT)];
    [path addQuadCurveToPoint:CGPointMake(0, MIN_HEIGHT) controlPoint:CGPointMake(_curveX, _curveY)];
    [path closePath];
    _shapeLayer.path = path.CGPath;
}

- (void)calulatePath{
    CALayer *layer = _curveView.layer.presentationLayer;
    _curveX = layer.position.x;
    _curveY = layer.position.y;
    [self updateShapeLayerPath];
}


@end
