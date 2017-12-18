//
//  LYRollingNoticeView.h
//  OC版
//
//  Created by jjs on 2017/12/15.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYNotiveViewCell.h"

@class LYRollingNoticeView ;

@protocol LYRollingNoticeViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsForRollingNoticeView:(LYRollingNoticeView *)rollingView;
- (LYNotiveViewCell *)rollingNoticeView:(LYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index;
@end

@protocol LYRollingNoticeViewDelegate <NSObject>
@optional
- (void)didClickRollingNoticeView:(LYRollingNoticeView *)rollingView forIndex:(NSUInteger)index;
@end


@interface LYRollingNoticeView : UIView

@property (weak, nonatomic) id<LYRollingNoticeViewDataSource> dataSource;
@property (weak, nonatomic) id<LYRollingNoticeViewDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval stayInterVal; // 停留时间 默认3秒
@property (nonatomic, assign) NSTimeInterval animateInterVal; // 动画时间 默认0.5秒

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (__kindof LYNotiveViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)reloadDataAndStartRoll;
- (void)stopRoll; 

@end
