//
//  MineViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/23.
//  Copyright © 2015年 阿澤. All rights reserved.
//
#import "LibrarySeatsTabBarController.h"
#import "MineViewController.h"
#import "SettingTableViewController.h"
#import "InformationTableViewController.h"
#import "TimeTableViewCell.h"
#import "YALSunnyRefreshControl.h"
#import "NetworkHandler.h"
#import "User.h"

@interface MineViewController () <UIAlertViewDelegate, NetworkHandlerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NetworkHandler *networkHandler;
@property (strong, nonatomic) User *user;
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;
@property (nonatomic, strong, readonly) NSArray *menuNameArray;
@property (nonatomic, strong, readonly) NSArray *menuImageArray;
@end

@implementation MineViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NetworkHandler *)networkHandler {
    if (!_networkHandler) {
        _networkHandler = [NetworkHandler sharedNetworkHandler];
        _networkHandler.delegate = self;
    }
    return _networkHandler;
}

- (NSString *)requestURL {
    return @"/user/seatinfo.action";
}

- (User *)user {
    if (!_user) {
        _user = [User sharedUser];
    }
    return _user;
}

- (YALSunnyRefreshControl *)sunnyRefreshControl {
    if (!_sunnyRefreshControl) {
        _sunnyRefreshControl = [YALSunnyRefreshControl new];
        [_sunnyRefreshControl addTarget:self action:@selector(sunnyControlDidStartAnimation) forControlEvents:UIControlEventValueChanged];
    }
    return _sunnyRefreshControl;
}

-(void)sunnyControlDidStartAnimation{
    // start loading something
    [self seatInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setTitle:@"我的"];
    _menuNameArray = @[@"设置"];
    _menuImageArray = @[@"setting"];
    [self seatInfo];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ((LibrarySeatsTabBarController *)self.parentViewController).showTipMessageButton = NO;
    self.parentViewController.title = @"我的";
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self.sunnyRefreshControl attachToScrollView:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 1;
        default:
            return _menuNameArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LibraryMineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = self.user.name;
            cell.detailTextLabel.text = self.user.number;
            cell.imageView.image = [UIImage imageNamed:@"scnu"];
        }
        break;
        case 1:
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TimeTableViewCell class]) owner:nil options:nil] lastObject];
        }
        break;
        case 2:
        {
            cell.textLabel.text = _menuNameArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:_menuImageArray[indexPath.row]];
        }
        break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 88;
        case 1:
            return 123;
        default:
            return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            InformationTableViewController *ivc = [[InformationTableViewController alloc] initWithNibName:NSStringFromClass([InformationTableViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:ivc animated:YES];
        }
            break;
        case 2:
        {
            SettingTableViewController *setting = [[SettingTableViewController alloc] init];
            [self.navigationController pushViewController:setting animated:YES];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - network
- (void)seatInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?studentNum=%@",WEBSITE, [self requestURL], self.user.number];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.networkHandler responseMessageFromURL:url];
}

#pragma mark - networkHandlerDelegate
- (void)requestSuccess:(NSDictionary *)responseMessage {
    if ([responseMessage[@"response"] isEqualToString:@"success"]) {
        NSArray *array = responseMessage[@"datas"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            //{"responseMessage":{"datas":[{"seatNum":"1","venueName":"电子资源中心、学习共享空间","deadLineTIme":"2016-01-14 11:34:14"}],"describe":null,"response":"success"},"userInfoById":"info"}
            self.user.selectedVenue = dic[@"venueName"];
            self.user.selecetdSeat = dic[@"seatNum"];
            self.user.deadLineTime = dic[@"deadLineTIme"];
        }];
        [self.tableView reloadData];
    } else {
        self.user.selectedVenue = @"暂无";
        self.user.selecetdSeat = 0;
        self.user.deadLineTime = nil;
    }
    [self.sunnyRefreshControl endRefreshing];
}

- (void)requestError:(NSError *)error {
    [self showAlertView:@"网络拥挤，获取占座信息失败，请刷新"];
    [self.sunnyRefreshControl endRefreshing];
}

- (void)showAlertView:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
