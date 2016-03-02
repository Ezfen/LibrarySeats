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
    self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:240.0/255 alpha:1];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
    label.textColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1];
    [view addSubview:label];
    switch (section) {
        case 0:
            label.text = @"个人信息";
            break;
        default:
            label.text = @"专业信息";
            break;
    }
    return view;
}
@end
