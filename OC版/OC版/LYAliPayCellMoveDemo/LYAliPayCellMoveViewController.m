//
//  LYAliPayCellMoveViewController.m
//  OC版
//
//  Created by jjs on 2017/12/26.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYAliPayCellMoveViewController.h"
#import "LYDragCellCollectionView.h"
#import "UIViewController+title.h"
#import "LYAlipayModel.h"
#import "LYAlipayCell.h"

#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface LYAliPayCellMoveViewController ()<LYDragCellCollectionViewDelegate, LYDragCellCollectionViewDataSource>
@property (weak, nonatomic) IBOutlet LYDragCellCollectionView *dragCellCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (strong, nonatomic) NSMutableArray <LYAlipayModel *>*dataSourceArray;

@end

static NSString *reuseIdentifier = @"reuseIdentifier";

@implementation LYAliPayCellMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self getTitle];
    self.dragCellCollectionView.delegate = self;
    self.dragCellCollectionView.dataSource = self;
    self.dragCellCollectionView.collectionViewLayout = self.collectionViewFlowLayout;
    [self.dragCellCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass(LYAlipayCell.class) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - UICollectionView DataSource AND Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(LYAlipayCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    cell.model = self.dataSourceArray[indexPath.row];
}
- (NSArray *)dataSourceWithDragCellColletcionView:(nonnull LYDragCellCollectionView *)dragCellCollctionView {
    return self.dataSourceArray;
}

- (void)dragCellCollectionView:(nonnull LYDragCellCollectionView *)dragCellCollectionView newDataArrayAfterMove:(nullable NSArray *)newDataArray {
    self.dataSourceArray = [newDataArray mutableCopy];
}



#pragma mark - lazy loading

- (UICollectionViewFlowLayout *)collectionViewFlowLayout{
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionViewFlowLayout.minimumLineSpacing = 1;
        _collectionViewFlowLayout.minimumInteritemSpacing = 1;
        _collectionViewFlowLayout.itemSize =  CGSizeMake((WIDTH-4)/4.0, (WIDTH-4)/4.0);
    }
    return _collectionViewFlowLayout;
}

- (NSMutableArray<LYAlipayModel *> *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [@[] mutableCopy];
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"转账" iconName:@"转账"]];
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"信用卡还款" iconName:@"信用卡"]];
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"充值中心" iconName:@"充值中心"]];
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"芝麻信用" iconName:@"芝麻信用"]];
        
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"共享单车" iconName:@"共享单车"]];
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"花呗" iconName:@"花呗"]];
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"滴滴出行" iconName:@"滴滴出行"]];
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"火车票机票" iconName:@"火车票"]];
      
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"来分期" iconName:@"分期"]];
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"商家服务" iconName:@"商家服务2"]];
        [_dataSourceArray addObject:[LYAlipayModel modelWithTitle:@"ofo小黄车" iconName:@"ofo共享单车"]];
    }
    return _dataSourceArray;
}



@end
