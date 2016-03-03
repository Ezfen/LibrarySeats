//
//  CustomBookingView.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/4.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomBookingView.h"
#import "SeatsProgressView.h"
#import "Library.h"
#import "Venue.h"
#import "TipsView.h"
#import "Tip.h"

@interface CustomBookingView() <UIAlertViewDelegate>
//Gesture集合
@property (strong, nonatomic) NSMutableArray* tapGestures;
@property (strong, nonatomic) NSMutableArray* seatsProgressViews;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *venues;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@end

@implementation CustomBookingView

#pragma mark - setter and getter
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

- (NSMutableArray *)tapGestures {
    if (!_tapGestures) {
        _tapGestures = [[NSMutableArray alloc] init];
    }
    return _tapGestures;
}

- (NSMutableArray *)seatsProgressViews {
    if (!_seatsProgressViews) {
        _seatsProgressViews = [[NSMutableArray alloc] init];
    }
    return _seatsProgressViews;
}

- (void)awakeFromNib {
//    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.6];
//    self.backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.4];
    self.backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
    self.backgroundView.layer.borderWidth = 2;
    self.backgroundView.layer.cornerRadius = 10;
    self.backgroundView.clipsToBounds = YES;
    self.managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).librarySeatContext;
    if (!self.managedObjectContext) {
        [[NSNotificationCenter defaultCenter] addObserverForName:LibrarySeatDatabaseAvailabilityNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          self.managedObjectContext = note.userInfo[LibrarySeatDatabaseAvailabilityContext];
                                                      }];
        
    }
}

- (void)configureVenueSelectView {
    //添加提示View
    self.tipView.backgroundColor = [UIColor whiteColor];
    self.tipView.layer.borderWidth = 0.5;
    self.tipView.layer.borderColor = [UIColor grayColor].CGColor;
    Tip *green = [[Tip alloc] initWithTipColor:[UIColor greenColor] andTipDetail:@"空闲"];
    Tip *yellow = [[Tip alloc] initWithTipColor:[UIColor yellowColor] andTipDetail:@"紧张"];
    Tip *red = [[Tip alloc] initWithTipColor:[UIColor redColor] andTipDetail:@"拥挤"];
    NSDictionary *dic = @{@(1):green,@(2):yellow,@(3):red};
    self.tipView.tips = dic;
    
    //添加场馆Buttons
    CGFloat screenWidth = self.seatScrollView.frame.size.width;
    CGPoint origin = CGPointMake(0, 0);
    [self twoProgressViewsPerRow:&origin];
    self.seatScrollView.showsVerticalScrollIndicator = NO;
    self.seatScrollView.contentSize = CGSizeMake(screenWidth, origin.y);
}

- (void)twoProgressViewsPerRow:(CGPoint *)RowOrigin {
    CGFloat screenWidth = self.seatScrollView.frame.size.width;
    for (int i = 0; i < self.venues.count; ++i) {
        Venue *venue = self.venues[i];
        CGRect rect = CGRectMake(RowOrigin->x, RowOrigin->y, screenWidth / 2.0, screenWidth / 2.0);
        SeatsProgressView *view = [[SeatsProgressView alloc] initWithFrame:rect andTotal:[venue.totalSeatNum intValue] andCount:[venue.bookedSeatNum intValue]];
        view.title = venue.name;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSeatsView:)];
        [self.tapGestures addObject:tap];
        [view addGestureRecognizer:tap];
        [self.seatsProgressViews addObject:view];
        [self.seatScrollView addSubview:view];
        if (i % 2 == 0) {
            RowOrigin->x += screenWidth / 2.0;
            if (i == self.venues.count - 1) {
                RowOrigin->y += screenWidth / 2.0;
            }
        }
        if (i % 2 != 0) {
            RowOrigin->x = 0;
            RowOrigin->y += screenWidth / 2.0;
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
}

- (void)tapSeatsView:(UITapGestureRecognizer *)sender{
    NSUInteger index = [self.tapGestures indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(customBookingView:chooseVenueAtIndex:)]) {
        [self.delegate customBookingView:self chooseVenueAtIndex:index];
    }
}

- (void)drawRect:(CGRect)rect {
    [self configureVenueSelectView];
}

@end
