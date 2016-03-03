//
//  SeatsViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/12.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "AppDelegate.h"
#import "SeatsViewController.h"
#import "SeatTableViewCell.h"
#import "SeatTableHeaderView.h"
#import "DetailViewController.h"
#import "NetworkHandler.h"
#import "PQFCustomLoaders/PQFBouncingBalls.h"
#import "Venue.h"
#import "Library.h"
#import "LibrarySeatsTabBarController.h"

@interface SeatsViewController () <UITableViewDataSource,UITableViewDelegate,NetworkHandlerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedRequestController;
@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) Library *library;
@property (strong, nonatomic) NetworkHandler *networkHandler;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@end

@implementation SeatsViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self.bouncingBalls show];
    [self getVenueSituation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.parentViewController.title = @"座位情况";
    ((LibrarySeatsTabBarController *)self.parentViewController).showTipMessageButton = YES;
    ((LibrarySeatsTabBarController *)self.parentViewController).tipMessage = @"点击进入各个场馆，可快速查看心仪位置的锁定情况，并不代表座位使用情况喔~";
}

#pragma mark - setter & getter
- (PQFBouncingBalls *)bouncingBalls {
    if (!_bouncingBalls) {
        _bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
        _bouncingBalls.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return _bouncingBalls;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    if (_managedObjectContext) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Venue"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"floor" ascending:YES];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"libraryID == %d",1];
        [fetchRequest setPredicate:predicate];
        self.fetchedRequestController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"floor" cacheName:@"VenueCache"];
        NSError *error;
        [self.fetchedRequestController performFetch:&error];
        if (!error) {
            [self.bouncingBalls remove];
            [self.tableView reloadData];
        }
    }
}

- (NSString *)requestURL {
    return @"/venue/venueinfo.action";
}

- (Library *)library {
    if (!_library) {
        _library = [Library sharedLibrary];
    }
    return _library;
}

- (NetworkHandler *)networkHandler {
    if (!_networkHandler) {
        _networkHandler = [NetworkHandler sharedNetworkHandler];
        _networkHandler.delegate = self;
    }
    return _networkHandler;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 113)
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedRequestController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedRequestController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"VenueCell";
    SeatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SeatTableViewCell class]) owner:nil options:nil] lastObject];
    }
    Venue *venue = [self.fetchedRequestController objectAtIndexPath:indexPath];
    cell.venueName = venue.name;
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
    headerView.floor = [[self.fetchedRequestController sections] objectAtIndex:section].name;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:240.0/255 alpha:1];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Venue *venue = [self.fetchedRequestController objectAtIndexPath:indexPath];
    if (venue.totalSeatNum != 0) {
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.total = [venue.totalSeatNum intValue];
        detail.venueID = [venue.iD intValue];
        detail.category = YES;
        detail.title = venue.name;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - network
- (void)getVenueSituation {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?libraryName=本部图书馆",WEBSITE, [self requestURL]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.networkHandler responseMessageFromURL:url];
}

#pragma mark - networkHandlerDelegate
- (void)requestSuccess:(NSDictionary *)responseMessage {
    if ([responseMessage[@"response"] isEqualToString:@"success"]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Venue"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"libraryID == %d",1];
        [fetchRequest setPredicate:predicate];
        NSError *error = nil;
        NSArray<Venue *> *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSArray *datas = responseMessage[@"datas"];
        if (!error && array.count > 0) {
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                for (int i = 0; i < array.count; ++i) {
                    Venue *venue = array[i];
                    if ([venue.iD intValue] == [dic[@"intID"] intValue]) {
                        venue.bookedSeatNum = @([dic[@"intBookedSeatNum"] intValue]);
                        break;
                    }
                }
            }];
            [self.managedObjectContext save:nil];
        }
    }
}

- (void)requestError:(NSError *)error {
    
}


@end
