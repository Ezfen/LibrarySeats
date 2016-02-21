//
//  NoticesViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/17.
//  Copyright © 2015年 阿澤. All rights reserved.
//
#import "LibrarySeatsTabBarController.h"
#import "NoticesViewController.h"
#import "RollingImageScrollView.h"
#import "WebViewController.h"
#import "YALSunnyRefreshControl.h"

@interface NoticesViewController () <RollingImageScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) RollingImageScrollView *rollingImageView;
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;
@property (strong, nonatomic) UIPageControl *pageControl;
@end

@implementation NoticesViewController

#pragma mark - setter & getter
- (YALSunnyRefreshControl *)sunnyRefreshControl {
    if (!_sunnyRefreshControl) {
        _sunnyRefreshControl = [YALSunnyRefreshControl new];
        [_sunnyRefreshControl addTarget:self action:@selector(sunnyControlDidStartAnimation) forControlEvents:UIControlEventValueChanged];
    }
    return _sunnyRefreshControl;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.sunnyRefreshControl attachToScrollView:_tableView];
    }
    return _tableView;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_rollingImageView.timer invalidate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.parentViewController.title = @"公告";
    ((LibrarySeatsTabBarController *)self.parentViewController).showTipMessageButton = NO;
    _rollingImageView.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:_rollingImageView selector:@selector(changeImage) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - otherFunction
-(void)sunnyControlDidStartAnimation{
    // start loading something
    [self.sunnyRefreshControl endRefreshing];
}

#pragma mark - RollingImageScrollViewDelegate
- (void)rollDidEndDecelerating {
    int index = _rollingImageView.currentImageIndex;
    _pageControl.currentPage = index;
}

- (void)tapImageView:(NSInteger)imageIndex {
    NSArray *urlStrs = @[@"http://lib.scnu.edu.cn/zhinan/ggsz.asp",
                         @"http://lib.scnu.edu.cn/zhinan/gcfb.asp",
                         @"http://lib.scnu.edu.cn/zhinan/time.asp"];
    NSArray *contents = @[@"机构设置",@"馆藏分布",@"开放时间"];
    WebViewController *webViewController = [[WebViewController alloc] init];
    webViewController.urlStr = urlStrs[imageIndex];
    webViewController.title = contents[imageIndex];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"noticeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"aaaa";
    cell.detailTextLabel.text = @"bbbb";
    return cell;
}

#pragma mark - TableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 140)];
    NSArray *contents = @[@"机构设置",@"馆藏分布",@"开放时间"];
    _rollingImageView = [[RollingImageScrollView alloc] initWithFrame:headerView.frame];
    _rollingImageView.rollingImageDelegate = self;
    _rollingImageView.contents = contents;
    [headerView addSubview:_rollingImageView];
    //添加PageControl
    _pageControl = [[UIPageControl alloc] init];
    CGSize size = [_pageControl sizeForNumberOfPages:_rollingImageView.imageCount];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(_rollingImageView.frame.size.width - size.width / 2.0, _rollingImageView.frame.size.height - 5);
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    _pageControl.numberOfPages = _rollingImageView.imageCount;
    [headerView addSubview:_pageControl];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 140;
}

@end
