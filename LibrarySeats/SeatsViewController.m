//
//  SeatsViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/12.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "SeatsViewController.h"
#import "SeatTableViewCell.h"
#import "SeatTableHeaderView.h"
#import "DetailViewController.h"
#import "NetworkHandler.h"
#import "Venue.h"
#import "Library.h"
#import "YALSunnyRefreshControl.h"
#import "LibrarySeatsTabBarController.h"
#import "PQFCustomLoaders/PQFCustomLoaders.h"

@interface SeatsViewController () <UITableViewDataSource,UITableViewDelegate,NetworkHandlerDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NetworkHandler *networkHandler;
@property (strong, nonatomic) Library *library;
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@end

@implementation SeatsViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutUI];
    [self.bouncingBalls show];
    [self venueInfoByLibraryName:@"本部图书馆"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.parentViewController.title = @"座位情况";
    ((LibrarySeatsTabBarController *)self.parentViewController).showTipMessageButton = YES;
    ((LibrarySeatsTabBarController *)self.parentViewController).tipMessage = @"点击进入各个场馆，可快速查看心仪位置的锁定情况，并不代表座位使用情况喔~";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter & getter
- (YALSunnyRefreshControl *)sunnyRefreshControl {
    if (!_sunnyRefreshControl) {
        _sunnyRefreshControl = [YALSunnyRefreshControl new];
        [_sunnyRefreshControl addTarget:self action:@selector(sunnyControlDidStartAnimation) forControlEvents:UIControlEventValueChanged];
    }
    return _sunnyRefreshControl;
}

- (PQFBouncingBalls *)bouncingBalls {
    if (!_bouncingBalls) {
        _bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
        _bouncingBalls.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return _bouncingBalls;
}

- (Library *)library {
    if (!_library) {
        _library = [Library sharedLibrary];
    }
    return _library;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 100)
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:240.0/255 alpha:1];
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
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
    return @"/venue/venueinfo.action";
}

#pragma mark - OtherFunction
- (void)layoutUI {
    self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:240.0/255 alpha:1];
    [self.sunnyRefreshControl attachToScrollView:self.tableView];
}


-(void)sunnyControlDidStartAnimation{
    // start loading something
    [self venueInfoByLibraryName:@"本部图书馆"];
    [self.tableView reloadData];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.library.venues.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.library.venues[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"VenueCell";
    SeatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SeatTableViewCell class]) owner:nil options:nil] lastObject];
    }
    NSMutableArray *floor = self.library.venues[indexPath.section];
    Venue *venue = floor[indexPath.row];
    cell.venueName = venue.venueName;
    cell.location = [venue.floor stringByAppendingString:venue.direction];
    cell.openTime = venue.openTime;
    cell.index = (indexPath.section + indexPath.row) % 5;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 216;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SeatTableHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SeatTableHeaderView class]) owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    switch (section) {
        case 0:
            headerView.floor = @"一楼";
            break;
        case 1:
            headerView.floor = @"二楼";
            break;
        case 2:
            headerView.floor = @"三楼";
            break;
        case 3:
            headerView.floor = @"四楼";
            break;
        case 4:
            headerView.floor = @"五楼";
            break;
        default:
            break;
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:240.0/255 alpha:1];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Venue *venue = self.library.venues[indexPath.section][indexPath.row];
    if (venue.totalSeatNum != 0) {
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.total = venue.totalSeatNum;
        detail.venueID = venue.ID;
        detail.category = YES;
        detail.title = venue.venueName;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - network
- (void)venueInfoByLibraryName:(NSString *)libraryName {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?libraryName=%@",WEBSITE, [self requestURL], libraryName];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.networkHandler responseMessageFromURL:url];
}

#pragma mark - networkHandlerDelegate
- (void)requestSuccess:(NSDictionary *)responseMessage {
    if ([responseMessage[@"response"] isEqualToString:@"success"]) {
        [self.library cleanData];
        NSArray *array = responseMessage[@"datas"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            Venue *venue = [Venue new];
            venue.ID = [dic[@"intID"] intValue];
            venue.libraryID = [dic[@"intLibraryID"] intValue];
            venue.totalSeatNum = [dic[@"intTotalSeatNum"] intValue];
            venue.usedSeatNum = [dic[@"intUsedSeatNum"] intValue];
            venue.bookedSeatNum = [dic[@"intBookedSeatNum"] intValue];
            venue.venueName = dic[@"vcVenueName"];
            venue.floor = dic[@"vcFloor"];
            venue.openTime = dic[@"vcOpenTime"];
            venue.seatDistribution = dic[@"vcSeatDistribution"];
            venue.direction = dic[@"vcDirection"];
            [self.library classifyVenueByFloor:venue];
        }];
        [self.tableView reloadData];
    } else {
        NSString *describe = responseMessage[@"describe"];
        [self showAlertView:describe];
    }
    [self.bouncingBalls remove];
    [self.sunnyRefreshControl endRefreshing];
}

- (void)requestError:(NSError *)error {
    [self.bouncingBalls remove];
    [self.sunnyRefreshControl endRefreshing];
    [self showAlertView:@"网络拥挤，请稍后再试"];
}

- (void)showAlertView:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
