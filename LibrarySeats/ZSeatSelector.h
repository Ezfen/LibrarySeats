//
//  ZSeatSelector.h
//  
//
//  Created by Ricardo Zertuche on 7/30/15.
//
//

#import <UIKit/UIKit.h>
#import "ZSeat.h"

@class ZSeatSelector;
@protocol ZSeatSelectorDelegate <NSObject>
- (void)seatSelected:(ZSeat *)seat;
@optional
- (void)getSelectedSeats:(NSMutableArray *)seats;
@end

@interface ZSeatSelector : UIScrollView <UIScrollViewDelegate>{
    float seat_width;
    float seat_height;
    NSMutableArray *selected_seats;
    UIView *zoomable_view;
}

@property (nonatomic, retain) UIImage *available_image;
@property (nonatomic, retain) UIImage *long_time_image;
@property (nonatomic, retain) UIImage *middle_time_image;
@property (nonatomic, retain) UIImage *short_time_image;
@property (nonatomic, retain) UIImage *disabled_image;
@property (nonatomic, retain) UIImage *selected_image;
@property (nonatomic) int selected_seat_limit;

@property (strong, nonatomic) NSArray *seats;

@property (nonatomic) float seat_price;
@property (retain) id seat_delegate;

-(void)setSeatSize:(CGSize)size;
-(void)setMap:(NSString*)map;

-(void)setAvailableImage:(UIImage*)available_image andLongTimeImage:(UIImage*)long_time_image andMiddleImage:(UIImage *)middle_time_image andShortTimeImage:(UIImage *)short_time_image andDisabledImage:(UIImage*)disabled_image andSelectedImage:(UIImage*)selected_image;

@end
