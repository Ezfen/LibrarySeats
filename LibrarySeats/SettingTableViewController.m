//
//  SettingTableViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/10.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "SettingTableViewController.h"
#import "MineFooterView.h"
#import "AppDelegate.h"

@interface SettingTableViewController ()
@property (nonatomic, strong, readonly) NSArray *menuNameArray;
@property (nonatomic, strong, readonly) NSArray *menuImageArray;
@end

@implementation SettingTableViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        _menuNameArray = @[@"告诉我们"];
        _menuImageArray = @[@"message"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:240.0/255 alpha:1];
    [self setTitle:@"设置"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LibrarySettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = _menuNameArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_menuImageArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)logout {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定解绑该账号？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return ;
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERNAME];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate changeViewController];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MineFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MineFooterView class]) owner:nil options:nil] lastObject];
    [footerView.logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}
@end
