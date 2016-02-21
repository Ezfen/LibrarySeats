//
//  DetailViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/13.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "DetailViewController.h"
#import "BookingViewController.h"
#import "NetworkHandler.h"
#import "ZSeatSelector.h"
#import "Seat.h"
#import "PQFCustomLoaders/PQFCustomLoaders.h"

@interface DetailViewController () <NetworkHandlerDelegate,ZSeatSelectorDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) ZSeatSelector *seatSelector;
@property (strong, nonatomic) NSMutableString *map;
@property (strong, nonatomic) NetworkHandler *networkHandler;
@property (strong, nonatomic) NSMutableArray *seats;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@end

@implementation DetailViewController

- (NSMutableString *)map {
    if (!_map) {
        _map = [[NSMutableString alloc] init];
    }
    return _map;
}

- (NSMutableArray *)seats {
    if (!_seats) {
        _seats = [NSMutableArray new];
    }
    return _seats;
}

- (ZSeatSelector *)seatSelector {
    if (!_seatSelector) {
        _seatSelector = [[ZSeatSelector alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
        [_seatSelector setSeatSize:CGSizeMake(32, 32)];
        [_seatSelector setAvailableImage:[UIImage imageNamed:@"A"]
             andUnavailableImage:[UIImage imageNamed:@"U"]
                andDisabledImage:[UIImage imageNamed:@"D"]
                andSelectedImage:[UIImage imageNamed:@"S"]];
        _seatSelector.seat_delegate = self;
        _seatSelector.selected_seat_limit = 1;
        _seatSelector.backgroundColor = [UIColor colorWithRed:1 green:1 blue:240.0/255 alpha:1];
    }
    return _seatSelector;
}

- (NetworkHandler *)networkHandler {
    if (!_networkHandler) {
        _networkHandler = [NetworkHandler sharedNetworkHandler];
        _networkHandler.delegate = self;
    }
    return _networkHandler;
}

- (NSString *)requestURL {
    return @"/seat/allseats.action";
}

- (PQFBouncingBalls *)bouncingBalls {
    if (!_bouncingBalls) {
        _bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
        _bouncingBalls.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return _bouncingBalls;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.seatSelector];
    [self getSeatsInfoByVenueID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.bouncingBalls show];
}


#pragma mark - OtherFunction
- (void)getSeatsInfoByVenueID {
    if (!self.venueID) {
        return ;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?venueID=%i",WEBSITE, [self requestURL], self.venueID];
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
            //"deadLineTime":"2016-01-12 01:47:03","dtLastUpdate":"2016-01-12T01:17:03","intBooked":0,"intID":16,"intSeatNum":1,"intUserID":1,"intUsing":0,"intVenueID":1
            Seat *seat = [Seat new];
            seat.ID = [dic[@"intID"] intValue];
            seat.userID = [dic[@"intUserID"] intValue];
            seat.venueID = [dic[@"intVenueID"] intValue];
            seat.seatNum = [dic[@"intSeatNum"] intValue];
            seat.used = [dic[@"intUsing"] intValue] == 1 ? YES : NO;
            seat.booked = [dic[@"intBooked"] intValue] == 1 ? YES : NO;
            seat.deadLineTime = dic[@"deadLineTime"];
            [self.seats addObject:seat];
            [self addSeatToMap:seat];
        }];
        [self changeLine];
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


- (void)addSeatToMap:(Seat *)seat {
    if (seat.booked) {
        [self.map appendString:@"U"];
    } else {
        if (self.category) [self.map appendString:@"D"];
        else [self.map appendString:@"A"];
    }
}

- (void)changeLine {
    int counter = 0;
    for (int i = 1; i <= self.total; ++i) {
        if (i % 8 == 0) {
            [self.map insertString:@"/" atIndex:i + counter];
            [self.map insertString:@"/" atIndex:i + counter];
            counter += 2;
        }
    }
    [self.seatSelector setSeats:self.seats];
    [self.seatSelector setMap:self.map];
}

- (void)seatSelected:(ZSeat *)seat {
    int selectedNum = (seat.row - 1) * 8 + seat.column;
    Seat *selectedSeat = self.seats[selectedNum - 1];
    ((BookingViewController *)self.sourceViewController).selectedSeatID = selectedSeat.ID;
    NSString *str = [NSString stringWithFormat:@"你将预约%@的第%i号座位",self.title,selectedNum];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择座位" message:str delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        [((BookingViewController *)self.sourceViewController) subViewDismiss];
    }
}


@end
