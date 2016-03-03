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
#import "NetworkHandler.h"
#import "AppDelegate.h"
#import "Notice.h"
#import "YALSunnyRefreshControl.h"

@interface NoticesViewController () <RollingImageScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, NetworkHandlerDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) RollingImageScrollView *rollingImageView;
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) WebViewController *webViewController;
@property (strong, nonatomic) NetworkHandler *networkHandler;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedRequestController;
@end

@implementation NoticesViewController

#pragma mark - setter & getter
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    if (_managedObjectContext) {
        self.fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Notice"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastUpdate" ascending:NO];
        self.fetchRequest.sortDescriptors = @[sortDescriptor];
        self.fetchedRequestController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        self.fetchedRequestController.delegate = self;
        NSError *error;
        [self.fetchedRequestController performFetch:&error];
        if (!error) {
            [self.tableView reloadData];
        }
    }
}

- (YALSunnyRefreshControl *)sunnyRefreshControl {
    if (!_sunnyRefreshControl) {
        _sunnyRefreshControl = [YALSunnyRefreshControl new];
        [_sunnyRefreshControl addTarget:self action:@selector(sunnyControlDidStartAnimation) forControlEvents:UIControlEventValueChanged];
    }
    return _sunnyRefreshControl;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
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
    return @"/notice/list.action";
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webViewController = [[WebViewController alloc] init];
    [self.sunnyRefreshControl attachToScrollView:self.tableView];
    self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:240.0/255 alpha:1];
    [self.view addSubview:self.tableView];
    self.managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).librarySeatContext;
    if (!self.managedObjectContext) {
        [[NSNotificationCenter defaultCenter] addObserverForName:LibrarySeatDatabaseAvailabilityNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          self.managedObjectContext = note.userInfo[LibrarySeatDatabaseAvailabilityContext];
                                                      }];
    }
    [self noticeInfo];
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
    [self noticeInfo];
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
    self.webViewController.urlStr = urlStrs[imageIndex];
    self.webViewController.title = contents[imageIndex];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:self.webViewController];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedRequestController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedRequestController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"noticeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Notice *notice = [self.fetchedRequestController objectAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:240.0/255 alpha:1];
    cell.textLabel.text = notice.title;
    cell.detailTextLabel.text = notice.lastUpdate;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - network
- (void)noticeInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",WEBSITE, [self requestURL]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.networkHandler responseMessageFromURL:url];
}

#pragma mark - networkHandlerDelegate
- (void)requestSuccess:(NSDictionary *)responseMessage {
    NSError *error = nil;
    NSArray *existNotices = [self.managedObjectContext executeFetchRequest:self.fetchRequest error:&error];
    if (!error) {
        if ([responseMessage[@"response"] isEqualToString:@"success"]) {
            NSArray *array = responseMessage[@"datas"];
            __weak NoticesViewController *weakSelf = self;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                Boolean flag = NO;
                /*
                 {"dtLastUpdate":"2016-01-08T22:55:37","intID":1,"vcContent":"1月7日上午，省长朱小丹在广州珠岛宾馆，向新聘的省政府参事和省政府文史研究馆馆员颁发聘书。省委常委、常务副省长徐少华宣读省政府聘任通知。\n\n我校经济与管理学院刘纪显教授、外国语言文化学院周榕教授被聘任为广东省人民政府参事，文学院陈剑晖教授被聘任为广东省人民政府文史研究馆馆员。\n\n参事主要从民主党派成员和无党派人士中聘任，主要发挥参政议政、建言献策、咨询国是、民主监督、统战联谊的作用。文史馆员工作主要是开展文史研究、编辑书刊，从事书画艺术创作，以及参加各类学术探讨、学术交流、社会公益事业活动等。","vcImageUrl":null,"vcTitle":"我校三位教授获聘省政府参事和文史研究馆馆员"}
                 */
                for (Notice *notice in existNotices) {
                    if ([notice.iD intValue] == [dic[@"intID"] intValue]) {
                        flag = YES;
                        break;
                    }
                }
                if (!flag) {
                    Notice *notice = [NSEntityDescription insertNewObjectForEntityForName:@"Notice" inManagedObjectContext:weakSelf.managedObjectContext];
                    notice.iD = @([dic[@"intID"] intValue]);
                    notice.title = dic[@"vcTitle"];
                    notice.content = dic[@"vcContent"];
                    notice.lastUpdate = dic[@"dtLastUpdate"];
                    [weakSelf.managedObjectContext save:nil];
                }
            }];
            [self.tableView reloadData];
        }
    }
    [self.sunnyRefreshControl endRefreshing];
}

- (void)requestError:(NSError *)error {
    [self showAlertView:@"网络拥挤，请稍后刷新"];
    [self.sunnyRefreshControl endRefreshing];
}

- (void)showAlertView:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}



// NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}



@end
