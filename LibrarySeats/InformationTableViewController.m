//
//  InformationTableViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/13.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "InformationTableViewController.h"
#import "AvatorTableViewCell.h"
#import "User.h"

@interface InformationTableViewController ()
@property (strong, nonatomic)User *user;
@property (strong, nonatomic)NSArray *array;
@end

@implementation InformationTableViewController

- (User *)user {
    if (!_user) {
        _user = [User sharedUser];
    }
    return _user;
}

- (NSArray *)array {
    return @[@"大头贴",@"名字",@"性别",@"联系方式",@"学号",@"学院",@"专业",@"年级"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"个人资讯"];
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AvatorTableViewCell class]) owner:nil options:nil] lastObject];
        ((AvatorTableViewCell *)cell).avatorUrl = self.user.avatorURL;
    } else {
        NSString *identifier = @"DefaultCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        int index = 0;
        if (indexPath.section == 1) {
            index = 4;
        }
        cell.textLabel.text = self.array[index + indexPath.row];
        cell.detailTextLabel.text = [self.user valueForIndex:index + indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 88;
    } else return 44;
}

@end
