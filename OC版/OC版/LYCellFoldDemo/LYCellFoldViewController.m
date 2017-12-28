//
//  LYCellFoldViewController.m
//  OC版
//
//  Created by jjs on 2017/12/25.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "LYCellFoldViewController.h"
#import "UIViewController+title.h"

@interface LYCellFoldViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSIndexPath *selectIndex;

@property (nonatomic, assign)BOOL isOpen;
@property (nonatomic, assign) NSInteger selectSection;

@end


@implementation LYCellFoldViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self getTitle];
    
    _isOpen=YES;
    _dataArray=[[NSMutableArray alloc]initWithObjects:@"open 0",@"open 1",@"open 2",@"open 3",@"open 4",@"open 5",@"open 6", nil];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectIndex.row == indexPath.row && _selectIndex!=nil) {
        if (_isOpen) {
            return 120;
        }
        return 50;
    }
    return 50;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"CELLID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (_selectIndex.row == indexPath.row && _selectIndex!=nil ) {
        if (_isOpen) {
            //可自定义当前cell样式
            cell.textLabel.text = _dataArray[indexPath.row];
            cell.backgroundColor=[UIColor cyanColor];
        }else {
            //恢复原状（定义原cell并填充）
            cell.textLabel.text=@"关闭";
            cell.backgroundColor=[UIColor whiteColor];
        }
        
    }else {
        cell.textLabel.text=@"关闭";
        cell.backgroundColor=[UIColor whiteColor];
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //更改选中cell的状态 用以 刷新页面是进行折叠和展开
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    if (_selectIndex!=nil &&indexPath.row ==_selectIndex.row) {
        _isOpen=!_isOpen;
        
    }else if (_selectIndex!=nil && indexPath.row!=_selectIndex.row) {
        indexPaths = [NSArray arrayWithObjects:indexPath,_selectIndex, nil];
        _isOpen=YES;
    }
    _selectIndex=indexPath;
    //刷新
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}


#pragma mark - layz

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
    
}

@end
