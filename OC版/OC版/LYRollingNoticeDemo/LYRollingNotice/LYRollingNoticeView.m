//
//  LYRollingNoticeView.m
//  OC版
//
//  Created by jjs on 2017/12/15.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYRollingNoticeView.h"
#import "LYNotiveViewCell.h"

@interface LYRollingNoticeView ()

@property (strong, nonatomic) NSMutableDictionary *cellClsDict;
@property (strong, nonatomic) NSMutableArray *reuseCells;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@property (strong, nonatomic) LYNotiveViewCell *currentCell;
@property (strong, nonatomic) LYNotiveViewCell *willShowCell;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int currentIndex;

@end

@implementation LYRollingNoticeView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        _stayInterVal = 2;
        _animateInterVal = 0.5;
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _stayInterVal = 2;
        _animateInterVal = 0.5;
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier{
    [self.cellClsDict setObject:NSStringFromClass(cellClass) forKey:identifier];
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier{
    [self.cellClsDict setObject:nib forKey:identifier];
}

- (LYNotiveViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    for (LYNotiveViewCell *cell in self.reuseCells) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            return cell;
        }
    }
    
    id cellClass = self.cellClsDict[identifier];
    if ([cellClass isKindOfClass:[UINib class]]) {
        UINib *nib = (UINib *)cellClass;
        NSArray *arr = [nib instantiateWithOwner:nil options:nil];
        LYNotiveViewCell *cell = [arr firstObject];
        [cell setValue:identifier forKeyPath:@"reuseIdentifier"];
        return cell;
    }else{
        Class cellCls = NSClassFromString(self.cellClsDict[identifier]);
        LYNotiveViewCell *cell = [[cellCls alloc] initWithReuseIdentifier:identifier];
        return cell;
    }
    return nil;
}


#pragma mark- rolling

- (void)reloadDataAndStartRoll{
    [self stopRoll];
    [self layoutCurrentCellAndWillShowCell];
    
    NSInteger count = [self.dataSource numberOfRowsForRollingNoticeView:self];
    if (count && count < 2) {return;}
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_stayInterVal target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


- (void)layoutCurrentCellAndWillShowCell{
    
    int count = (int)[self.dataSource numberOfRowsForRollingNoticeView:self];
    if (_currentIndex > count - 1) {_currentIndex = 0;}
    
    int willShowIndex = _currentIndex + 1;
    if (willShowIndex > count - 1) {willShowIndex = 0;}
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    if (!_currentCell) {
        _currentCell = [self.dataSource rollingNoticeView:self cellAtIndex:_currentIndex];
        _currentCell.frame = CGRectMake(0, 0, width, height);
        [self addSubview:_currentCell];
        return ;
    }
    
    _willShowCell = [self.dataSource rollingNoticeView:self cellAtIndex:willShowIndex];
    _willShowCell.frame = CGRectMake(0, height, width, height);
    [self addSubview:_willShowCell];
    
    [self.reuseCells removeObject:_currentCell];
    [self.reuseCells removeObject:_willShowCell];
}

- (void)timerHandle{
    [self layoutCurrentCellAndWillShowCell];
    _currentIndex ++;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    [UIView animateWithDuration:_animateInterVal animations:^{
        _currentCell.frame = CGRectMake(0, -height, width, height);
        _willShowCell.frame = CGRectMake(0, 0, width, height);
    }completion:^(BOOL finished) {
        if (_currentCell && _willShowCell) {
            [self.reuseCells addObject:_currentCell];
            [_currentCell removeFromSuperview];
            _currentCell = _willShowCell;
        }
    }];
}

- (void)stopRoll{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _currentIndex = 0;
    [_currentCell removeFromSuperview];
    [_willShowCell removeFromSuperview];
    _currentCell = nil;
    _willShowCell = nil;
    [self.reuseCells removeAllObjects];
}


#pragma mark- Action
- (void)handleCellTapAction
{
    int count = (int)[self.dataSource numberOfRowsForRollingNoticeView:self];
    if (_currentIndex > count - 1) {
        _currentIndex = 0;
    }
    if ([self.delegate respondsToSelector:@selector(didClickRollingNoticeView:forIndex:)]) {
        [self.delegate didClickRollingNoticeView:self forIndex:_currentIndex];
    }
}




#pragma mark- lazy
- (NSMutableDictionary *)cellClsDict{
    if (!_cellClsDict) {
        _cellClsDict = [[NSMutableDictionary alloc] init];
    }
    return _cellClsDict;
}

- (NSMutableArray *)reuseCells{
    if (!_reuseCells) {
        _reuseCells = [[NSMutableArray alloc] init];
    }
    return _reuseCells;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellTapAction)];
    }
    return _tapGesture;
}
@end
