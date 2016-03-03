//
//  BookingViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/28.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "AppDelegate.h"
#import "Venue.h"
#import "NetworkHandler.h"
#import "LibrarySeatsTabBarController.h"
#import "PQFCustomLoaders/PQFBouncingBalls.h"
#import "BookingViewController.h"
#import "CustomBookingView.h"
#import "DetailViewController.h"

@interface BookingViewController () <CustomBookingViewDelegate, NetworkHandlerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) UISegmentedControl *segmentControl;
@property (strong, nonatomic) CustomBookingView *fastBookingView;
@property (strong, nonatomic) CustomBookingView *detailBookingView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *venues;
@property (nonatomic) int bookVenueID;
@property (strong, nonatomic) NetworkHandler *networkHandler;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@end

@implementation BookingViewController

#pragma mark - setter & getter
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    if (_managedObjectContext) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"libraryID=%d && totalSeatNum<>0", 1];
        [fetchRequest setPredicate:predicate];
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"floor"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        self.venues = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }
}

- (NSString *)requestURL:(int)choose {
    if (choose == 1) return @"/seat/fastbooking.action";
    else return @"/seat/custombooking.action";
}

- (PQFBouncingBalls *)bouncingBalls {
    if (!_bouncingBalls) {
        _bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
        _bouncingBalls.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return _bouncingBalls;
}

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        NSArray *array = @[@"快速",@"自选"];
        _segmentControl = [[UISegmentedControl alloc] initWithItems:array];
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.momentary = NO;
        _segmentControl.apportionsSegmentWidthsByContent = YES;
        _segmentControl.tintColor = [UIColor whiteColor];
        [_segmentControl addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (CustomBookingView *)fastBookingView {
    if (!_fastBookingView) {
        _fastBookingView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomBookingView class]) owner:nil options:nil] lastObject];
        _fastBookingView.frame = [UIScreen mainScreen].bounds;
        _fastBookingView.delegate = self;
        _fastBookingView.titleLabel.text = @"快速占座";
        [_fastBookingView setNeedsDisplay];
    }
    return _fastBookingView;
}

- (CustomBookingView *)detailBookingView {
    if (!_detailBookingView) {
        _detailBookingView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CustomBookingView class]) owner:nil options:nil] lastObject];
        _detailBookingView.frame = [UIScreen mainScreen].bounds;
        _detailBookingView.delegate = self;
        _detailBookingView.titleLabel.text = @"自定义占座";
        [_detailBookingView setNeedsDisplay];
    }
    return _detailBookingView;
}


- (NetworkHandler *)networkHandler {
    if (!_networkHandler) {
        _networkHandler = [NetworkHandler sharedNetworkHandler];
        _networkHandler.delegate = self;
    }
    return _networkHandler;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"k"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    self.managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).librarySeatContext;
    if (!self.managedObjectContext) {
        [[NSNotificationCenter defaultCenter] addObserverForName:LibrarySeatDatabaseAvailabilityNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          self.managedObjectContext = note.userInfo[LibrarySeatDatabaseAvailabilityContext];
                                                      }];
        
    }
    [self.view addSubview:imageView];
    [self.view addSubview:self.fastBookingView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.titleView = self.segmentControl;
    ((LibrarySeatsTabBarController *)self.parentViewController).showTipMessageButton = YES;
    ((LibrarySeatsTabBarController *)self.parentViewController).tipMessage = @"快速占座，系统会帮你快速抢占座位；当然也可以自定义选择抢占自己心仪的座位。但是由于图书馆是公共场所，所以此功能只能在闭馆后开馆前使用喔~";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.parentViewController.navigationItem.titleView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - otherFunctoin
- (void)selected:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            [self.detailBookingView removeFromSuperview];
            [self.view addSubview:self.fastBookingView];
            break;
        }
        case 1:
        {
            [self.fastBookingView removeFromSuperview];
            [self.view addSubview:self.detailBookingView];
            break;
        }
    }
}

- (void)subViewDismiss {
    [self.bouncingBalls show];
    [self customBookSeat];
}

#pragma mark - CustomBookingViewDelegate
- (void)customBookingView:(CustomBookingView *)view chooseVenueAtIndex:(NSInteger)index {
    Venue *venue = self.venues[index];
    self.bookVenueID = [venue.iD intValue];
    if ([view.titleLabel.text isEqualToString:@"快速占座"]) {
        NSString *alertStr = [NSString stringWithFormat:@"你将预约%@",venue.name];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:alertStr delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
    } else {
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.total = [venue.totalSeatNum intValue];
        detail.venueID = [venue.iD intValue];
        detail.category = NO;
        detail.title = venue.name;
        detail.sourceViewController = self;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self.bouncingBalls show];
        [self fastBookSeat];
    }
}

#pragma mark - network
- (void)fastBookSeat {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?venueID=%i&userID=1",WEBSITE, [self requestURL:1], self.bookVenueID];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.networkHandler responseMessageFromURL:url];
}

- (void)customBookSeat {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?seatID=%i&userID=1",WEBSITE, [self requestURL:2], self.selectedSeatID];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.networkHandler responseMessageFromURL:url];
}

#pragma mark - networkHandlerDelegate
- (void)requestSuccess:(NSDictionary *)responseMessage {
    if ([responseMessage[@"response"] isEqualToString:@"success"]) {
        NSString *describe = responseMessage[@"describe"];
        [self showAlertView:[NSString stringWithFormat:@"占座成功，座位号为:%i",[describe intValue]]];
    } else {
        NSString *describe = responseMessage[@"describe"];
        [self showAlertView:describe];
    }
    [self.bouncingBalls remove];
}

- (void)requestError:(NSError *)error {
    [self.bouncingBalls remove];
    [self showAlertView:@"网络拥挤，请稍后再试"];
    
}

- (void)showAlertView:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
