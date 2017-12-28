//
//  DelegateManager.m
//  OC版
//
//  Created by jjs on 2017/12/15.
//  Copyright © 2017年 iOS-LeiYu. All rights reserved.
//

#import "DelegateManager.h"

@interface DelegateManager()

@property (strong, nonatomic) NSArray *informationArray;
@property (strong, nonatomic) UINavigationController *navigationController;

@end


@implementation DelegateManager

+ (instancetype)delegateManagerWithInformations:(NSArray*)informationArray navigationController:(UINavigationController *)navigationController{
    DelegateManager * delegateManager = [[DelegateManager alloc] init];
    delegateManager.informationArray = informationArray;
    delegateManager.navigationController = navigationController;
    return delegateManager;
}

#pragma mark - TableView Delegate And DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.informationArray[indexPath.row];
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor groupTableViewBackgroundColor] : [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.informationArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *str = [@"LY" stringByAppendingString:[self.informationArray[indexPath.row] stringByReplacingOccurrencesOfString:@"Demo" withString:@"ViewController"]];
    
    UIViewController *viewController = [NSClassFromString(str) new];
    if (!viewController) {
        viewController = [[UIViewController alloc] initWithNibName:str bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
