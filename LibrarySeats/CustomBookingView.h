//
//  CustomBookingView.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/4.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomBookingView;

@protocol CustomBookingViewDelegate <NSObject>

@required
- (void)customBookingView:(CustomBookingView *)view chooseVenueAtIndex:(NSInteger)index;

@end

@class TipsView;

@interface CustomBookingView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *seatScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TipsView *tipView;
@property (weak, nonatomic) id<CustomBookingViewDelegate> delegate;
@end
