//
//  LYDragCellCollectionView.m
//  OC版
//
//  Created by jjs on 2017/12/25.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYDragCellCollectionView.h"

#pragma mark - UICollectionView (LYDragCellCollectionViewRect)
@implementation UICollectionView (LYDragCellCollectionViewRect_LYRect)

- (CGRect)LYDragCellCollectionView_rectForSection:(NSInteger)section{
    NSInteger sectionNum = [self.dataSource collectionView:self numberOfItemsInSection:section];
    if (sectionNum <= 0) {
        return CGRectZero;
    }
    CGRect firstRect = [self LYDragCellCollectionView_rectForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    CGRect lastRect = [self LYDragCellCollectionView_rectForRowAtIndexPath:[NSIndexPath indexPathForItem:sectionNum - 1 inSection:section]];
    
    if (((UICollectionViewFlowLayout *)self.collectionViewLayout).scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return CGRectMake(CGRectGetMinX(firstRect), 0, CGRectGetMaxX(lastRect) - CGRectGetMinX(firstRect), CGRectGetHeight(self.frame));
    } else {
        return CGRectMake(0, CGRectGetMinY(firstRect), CGRectGetWidth(self.frame), CGRectGetMaxY(lastRect) - CGRectGetMidY(firstRect));
    }
}

- (CGRect)LYDragCellCollectionView_rectForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self layoutAttributesForItemAtIndexPath:indexPath].frame;
}

@end

@interface LYDragCellCollectionView()

@property (nonatomic, strong, nullable) UILongPressGestureRecognizer *longGesture; ///< 长按手势
@property (nonatomic, strong, nullable) UIView *snapedView;                        ///< 截图快照
@property (nonatomic, strong, nullable) CADisplayLink *edgeTimer;                  ///< 定时器
@property (nonatomic, strong, nullable) NSIndexPath *oldIndexPath;                 ///< 旧的IndexPath
@property (nonatomic, strong, nullable) NSIndexPath *currentIndexPath;             ///< 当前路径
@property (nonatomic, assign) CGPoint oldPoint;                                    ///< 旧的位置
@property (nonatomic, assign) CGPoint lastPoint;                                   ///< 最后的触摸点
@property (nonatomic, assign) BOOL isEndDrag;                                      ///< 是否正在拖动

@end

@implementation LYDragCellCollectionView

@dynamic delegate, dataSource;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self initConfiguration];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfiguration];
    }
    return self;
}


#pragma mark - 私有方法

- (void)initConfiguration {
    _canDrag = YES;
    _minimumPressDuration = 0.5f;
    _dragCellAlpha = 1.0;
    _dragZoomScale = 1.2;
    
    [self addGestureRecognizer:self.longGesture];
    
    // iOS 10 新特性 对UICollectionView做了优化，但是这里如果使用了会导致bug
    // https://developer.apple.com/documentation/uikit/uicollectionview/1771771-prefetchingenabled
    // https://sxgfxm.github.io/blog/2016/10/18/uicollectionview-ios10-new-features/
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        super.prefetchingEnabled = NO;
    }
}

- (void)setEdgeTimer{
    if (!_edgeTimer) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopEdgeTimer{
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}
- (void)edgeScroll{
    
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (_isEndDrag) {
        cell.hidden = NO;
    }else{
        cell.hidden = (self.oldIndexPath && self.oldIndexPath.item == indexPath.item && self.oldIndexPath.section == indexPath.section);
    }
    return cell;
}

- (NSIndexPath *)getChangedIndexPath{
    __block NSIndexPath *index = nil;
    CGPoint point = [self.longGesture locationInView:self];
    
    //遍历拖拽的cell的中心点在哪一个cell里面
    [[self visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            index = [self indexPathForCell:obj];
            *stop = YES;
        }
    }];
    // 找到而且不是当前的CEll就返回此 index
    if (index) {
        if ((index.item == self.oldIndexPath.item) && (index.row == self.oldIndexPath.row)) {
            return nil;
        }
        return index;
    }
    
    // 获取最应该交换的cell
    __block CGFloat width = MAXFLOAT;
    __weak typeof (self) weakSelf = self;
    [[self visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            index = [self indexPathForCell:obj];
            *stop = YES;
        }
        __strong typeof (weakSelf) self = weakSelf;
        CGPoint p1 = self.snapedView.center;
        CGPoint p2 = obj.center;
        
        // 计算距离
        CGFloat distance = sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2));
        if (distance < width) {
            width = distance;
            index = [self indexPathForCell:obj];
        }
    }];
    if (!index) {
        return nil;
    }
    
    if ((index.item == self.oldIndexPath.item) && (index.row == self.oldIndexPath.row)) {
      // 最近的就是隐藏的Cell时,return nil
        return nil;
    }
    return index;
}

- (void)updateSourceData{
    NSMutableArray *array = [self.dataSource dataSourceWithDragCellColletcionView:self].mutableCopy;
    
    BOOL dataTypeCheck = ([self numberOfSections] != 1 || ([self numberOfSections] == 1 && [array[0] isKindOfClass:NSArray.class]));
    if (dataTypeCheck) {
        for (int i = 0 ; i < array.count ; i++) {
            [array replaceObjectAtIndex:i withObject:[array[i] mutableCopy]];
        }
    }
    
    if (_currentIndexPath.section == _oldIndexPath.section) {
        NSMutableArray *orignalSection  = dataTypeCheck ? (NSMutableArray *)array[_oldIndexPath.section] : (NSMutableArray *)array;
        if (_currentIndexPath.item > _oldIndexPath.item) {
            for (NSUInteger i = _oldIndexPath.item; i<_oldIndexPath.item; i++) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
        }else{
            for (NSUInteger i = _oldIndexPath.item; i > _currentIndexPath.item ; i --) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        }
    }else{
        NSMutableArray *orignalSection = array[_oldIndexPath.section];
        NSMutableArray *currentSection = array[_currentIndexPath.section];
        [currentSection insertObject:orignalSection[_oldIndexPath.item] atIndex:_currentIndexPath.item];
        [orignalSection removeObject:orignalSection[_oldIndexPath.item]];
    }
    // 更新外面的数据源
    [self.delegate dragCellCollectionView:self newDataArrayAfterMove:array];
}




#pragma mark - 事件响应
- (void)handleLongGesture:(UILongPressGestureRecognizer *)longGesture{
    CGPoint point = [longGesture locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.userInteractionEnabled = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionView:beganDragAtPoint:indexPath:)]) {
                [self.delegate dragCellCollectionView:self beganDragAtPoint:point indexPath:indexPath];
            }
            // 手势开始 判断手势落在位置是否在Item上
            _oldIndexPath = indexPath;
            // 没有按在cell 上就 break
            if (_oldIndexPath == nil) {
                self.longGesture.enabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_canDrag) {
                        self.longGesture.enabled = YES;
                    }
                });
                break;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionViewShouldBeginMove:indexPath:)]) {
                if (![self.delegate dragCellCollectionViewShouldBeginMove:self indexPath:_oldIndexPath]) {
                    _oldIndexPath = nil;
                    self.longGesture.enabled = NO;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_canDrag) {
                            self.longGesture.enabled = YES;
                        }
                    });
                    break;
                }
            }
            self.isEndDrag = NO;
            // 取出正在长按的cell
            UICollectionViewCell *cell = [self cellForItemAtIndexPath:_oldIndexPath];
            self.oldPoint = cell.center;
            
            if (_snapedView) {
                _snapedView = nil;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionView:startDragAtIndexPath:)]) {
                [self.delegate dragCellCollectionView:self startDragAtIndexPath:indexPath];
            }
            if (!_snapedView) {
                _snapedView = [cell snapshotViewAfterScreenUpdates:NO];
            }
            
            if (_dragSnapedViewBackgroundColor) {
                _snapedView.backgroundColor = _dragSnapedViewBackgroundColor;
            }
            
            // 让外面做一些处理
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionView:dragView:indexPath:)]) {
                [self.delegate dragCellCollectionView:self dragView:_snapedView indexPath:indexPath];
            }
            
            // 设置frame
            _snapedView.frame = cell.frame;
            [self addSubview:_snapedView];
            cell.hidden = YES;
            CGPoint currentPoint = point;
            [UIView animateWithDuration:0.25 animations:^{
                _snapedView.transform = CGAffineTransformMakeScale(_dragZoomScale, _dragZoomScale);
                _snapedView.center = CGPointMake(currentPoint.x, currentPoint.y);
                _snapedView.alpha = _dragCellAlpha;
            }];
            // 开启collectionView的边缘自动滚动检测
            [self setEdgeTimer];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionView:changedDragAtPoint:indexPath:)]) {
                [self.delegate dragCellCollectionView:self changedDragAtPoint:point indexPath:indexPath];
            }
            //当前手势
            _lastPoint = point;
            // 截图视图位置移动
            [UIView animateWithDuration:0.1 animations:^{
                _snapedView.center = _lastPoint;
            }];
            
            NSIndexPath *index = [self getChangedIndexPath];
            // 没有取到或者距离隐藏的最近时就返回
            if (!index) {
                break;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionViewShouldBeginExchange:sourceIndexPath:toIndexPath:)]) {
                if (![self.delegate dragCellCollectionViewShouldBeginExchange:self sourceIndexPath:_oldIndexPath toIndexPath:indexPath]) {
                    break;
                };
            }
            
            _currentIndexPath = index;
            self.oldPoint = [self cellForItemAtIndexPath:_currentIndexPath].center;
            
            [self updateSourceData];
            
            // 移动会调用willMoveToIndexPath方法更新数据源
            [self moveItemAtIndexPath:_oldIndexPath toIndexPath:_currentIndexPath];
            _oldIndexPath = _currentIndexPath;
            [self reloadItemsAtIndexPaths:@[_oldIndexPath]];
            break;
        }
        default:{
            self.userInteractionEnabled = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionView:endedDragAtPoint:indexPath:)]) {
                [self.delegate dragCellCollectionView:self endedDragAtPoint:point indexPath:indexPath];
            }
            
            if (longGesture.isEnabled) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionView:endedDragAutomaticOperationAtPoint:section:indexPath:)]) {
                    NSInteger section = -1;
                    NSInteger sec = [self.dataSource numberOfSectionsInCollectionView:self];
                    for (NSInteger i = 0; i < sec; i++) {
                        if (CGRectContainsPoint([self LYDragCellCollectionView_rectForSection:i], point)) {
                            section = i;
                            break;
                        }
                    }
                    if (![self.delegate dragCellCollectionView:self endedDragAutomaticOperationAtPoint:point section:section indexPath:indexPath]) {
                        return;
                    }
                }
                if (!self.oldIndexPath) {
                    return ;
                }
                
                UICollectionViewCell *cell = [self cellForItemAtIndexPath:_oldIndexPath];
                // 结束动画过程中停止交互，防止出问题
                self.userInteractionEnabled = NO;
                // 结束拖拽
                self.isEndDrag = YES;
                //给截图视图一个动画移动到隐藏Cell的位置
                [UIView animateWithDuration:0.25 animations:^{
                    if (!cell) {
                        _snapedView.center = _oldPoint;
                    }else{
                        _snapedView.center = cell.center;
                    }
                } completion:^(BOOL finished) {
                   // 移除截图视图 显示隐藏cell并开启交互
                    [_snapedView removeFromSuperview];
                    _snapedView = nil;
                    cell.hidden = NO;
                    self.userInteractionEnabled = YES;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionViewDidEndDrag:)]) {
                        [self.delegate dragCellCollectionViewDidEndDrag:self];
                    }
                }];
            }
            // 关闭定时器
            self.oldIndexPath = nil;
            [self stopEdgeTimer];
        }
            break;
    }
}

#pragma mark - getters setters
- (UILongPressGestureRecognizer *)longGesture{
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
        _longGesture.minimumPressDuration = _minimumPressDuration;
    }
    return _longGesture;
}






@end
