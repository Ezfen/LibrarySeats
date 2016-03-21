//
//  ZSeatSelector.m
//  
//
//  Created by Ricardo Zertuche on 7/30/15.
//
//

#import "ZSeatSelector.h"
#import "CMPopTipView.h"
#import "LeftTimeView.h"
#import "Seat.h"

@interface ZSeatSelector () <CMPopTipViewDelegate>
@property (strong, nonatomic) CMPopTipView *roundRectButtonPopTipView;
@property (strong, nonatomic) LeftTimeView *leftTimeView;
@property (nonatomic) bool flag;
@property (strong, nonatomic) NSMutableArray *seatButtonArray;
@end

@implementation ZSeatSelector

#pragma mark - Init and Configuration

- (NSMutableArray *)seatButtonArray {
    if (!_seatButtonArray) {
        _seatButtonArray = [NSMutableArray new];
    }
    return _seatButtonArray;
}

- (LeftTimeView *)leftTimeView {
    if (!_leftTimeView) {
        _leftTimeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LeftTimeView class]) owner:nil options:nil] lastObject];
        _leftTimeView.dateStr = @"2016-1-16 00:00:00";
    }
    return _leftTimeView;
}

- (CMPopTipView *)roundRectButtonPopTipView {
    if (!_roundRectButtonPopTipView) {
        _roundRectButtonPopTipView = [[CMPopTipView alloc] initWithCustomView:self.leftTimeView];
        _roundRectButtonPopTipView.delegate = self;
        _roundRectButtonPopTipView.backgroundColor = [UIColor lightGrayColor];
        _roundRectButtonPopTipView.textColor = [UIColor darkTextColor];
        _roundRectButtonPopTipView.dismissTapAnywhere = YES;
        self.flag = NO;
    }
    return _roundRectButtonPopTipView;
}
- (void)setSeatSize:(CGSize)size{
    seat_width = size.width;
    seat_height = size.height;
}
- (void)setMap:(NSString*)map{
    
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    zoomable_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    int initial_seat_x = 0;
    int initial_seat_y = 0;
    int final_width = 0;
    int row = 1,column = 1;
    bool isChangeRow = NO;
    
    for (int i = 0; i<map.length; i++) {
        char seat_at_position = [map characterAtIndex:i];
        
        if (seat_at_position == 'A') {
            [self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:YES isDisabled:NO row:row column:column];
            initial_seat_x += 1;
            column += 1;
        } else if (seat_at_position == 'D') {
            [self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:YES isDisabled:YES row:row column:column];
            initial_seat_x += 1;
            column += 1;
        } else if (seat_at_position == 'U') {
            [self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:NO isDisabled:NO row:row column:column];
            initial_seat_x += 1;
            column += 1;
        } else if(seat_at_position=='_'){
            initial_seat_x += 1;
            column += 1;
        } else {
            isChangeRow = YES;
            if (initial_seat_x>final_width) {
                final_width = initial_seat_x;
            }
            initial_seat_x = 0;
            initial_seat_y += 1;
        }
    }
    if (!isChangeRow) {
        if (initial_seat_x>final_width) {
            final_width = initial_seat_x;
        }
    }
    initial_seat_y += 2;
    float viewWidth = final_width*seat_width, viewHeight = initial_seat_y*seat_height + 20;
    if (viewWidth >= [UIScreen mainScreen].bounds.size.width) {
        zoomable_view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    } else {
        zoomable_view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - viewWidth)/2, 0, viewWidth, viewHeight);
    }
    [self setContentSize:zoomable_view.frame.size];
    selected_seats = [[NSMutableArray alloc]init];
    [self addSubview:zoomable_view];
    
}
- (void)createSeatButtonWithPosition:(int)initial_seat_x and:(int)initial_seat_y isAvailable:(BOOL)available isDisabled:(BOOL)disabled row:(int)row column:(int)column{
    
    ZSeat *seatButton = [[ZSeat alloc]initWithFrame:CGRectMake(initial_seat_x*seat_width, initial_seat_y*seat_height, seat_width, seat_height)];
    if (available && disabled) {
        [self setSeatAsDisabled:seatButton];
    } else if (available && !disabled) {
        [self setSeatAsAvaiable:seatButton];
    } else {
        [self setSeatAsUnavaiable:seatButton];
    }
    seatButton.tag = initial_seat_x;
    [seatButton setAvailable:available];
    [seatButton setDisabled:disabled];
    [seatButton setRow:row];
    [seatButton setColumn:column];
    [seatButton setPrice:self.seat_price];
    [seatButton addTarget:self action:@selector(seatSelected:) forControlEvents:UIControlEventTouchUpInside];
    [zoomable_view addSubview:seatButton];
    UILabel *seatNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(seatButton.frame.origin.x, CGRectGetMaxY(seatButton.frame) + 2, seat_width, 15)];
    seatNumLabel.text = [NSString stringWithFormat:@"%d",(row - 1) * 8 + column];
    seatNumLabel.textColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1];
    seatNumLabel.textAlignment = NSTextAlignmentCenter;
    [zoomable_view addSubview:seatNumLabel];
    [self.seatButtonArray addObject:seatButton];
}

#pragma mark - Seat Selector Methods

- (void)seatSelected:(ZSeat*)sender{
    if (!sender.selected_seat && sender.available) {
        if (self.selected_seat_limit) {
            [self checkSeatLimitWithSeat:sender];
        } else {
            [self setSeatAsSelected:sender];
            [selected_seats addObject:sender];
        }
        [self.seat_delegate seatSelected:sender];
    } else {
        [selected_seats removeObject:sender];
        if (sender.available && sender.disabled) {
            [self setSeatAsDisabled:sender];
        } else if (sender.available && !sender.disabled) {
            [self setSeatAsAvaiable:sender];
        }
    }
    
    //[self.seat_delegate getSelectedSeats:selected_seats];
}

- (void)checkSeatLimitWithSeat:(ZSeat*)sender{
    if ([selected_seats count]<self.selected_seat_limit) {
        [self setSeatAsSelected:sender];
        [selected_seats addObject:sender];
    } else {
        ZSeat *seat_to_make_avaiable = [selected_seats objectAtIndex:0];
        if (seat_to_make_avaiable.disabled)
            [self setSeatAsDisabled:seat_to_make_avaiable];
        else
            [self setSeatAsAvaiable:seat_to_make_avaiable];
        [selected_seats removeObjectAtIndex:0];
        [self setSeatAsSelected:sender];
        [selected_seats addObject:sender];
    }
}

#pragma mark - Seat Images & Availability

- (void)setAvailableImage:(UIImage *)available_image andUnavailableImage:(UIImage *)unavailable_image andDisabledImage:(UIImage *)disabled_image andSelectedImage:(UIImage *)selected_image{
    self.available_image    = available_image;
    self.unavailable_image  = unavailable_image;
    self.disabled_image     = disabled_image;
    self.selected_image     = selected_image;
}
- (void)setSeatAsUnavaiable:(ZSeat*)sender{
    [sender setImage:self.unavailable_image forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [sender setSelected_seat:YES];
}
- (void)setSeatAsAvaiable:(ZSeat*)sender{
    [sender setImage:self.available_image forState:UIControlStateNormal];
    [sender setSelected_seat:NO];
}
- (void)setSeatAsDisabled:(ZSeat*)sender{
    [sender setImage:self.disabled_image forState:UIControlStateNormal];
    [sender setSelected_seat:YES];
}
- (void)setSeatAsSelected:(ZSeat*)sender{
    [sender setImage:self.selected_image forState:UIControlStateNormal];
    [sender setSelected_seat:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    // NSLog(@"didZoom");
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [self.subviews objectAtIndex:0];
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    //NSLog(@"scrollViewWillBeginZooming");
}


#pragma mark popView
- (void)buttonAction:(id)sender {
    // Toggle popTipView when a standard UIButton is pressed
    if (!self.flag) {
        ZSeat *button = (ZSeat *)sender;
        int index = [self.seatButtonArray indexOfObject:button];
        Seat *seat = self.seats[index];
        self.leftTimeView.dateStr = seat.deadLineTime;
        [self.roundRectButtonPopTipView presentPointingAtView:button inView:self animated:YES];
    } else {
        // Dismiss
        [self.roundRectButtonPopTipView dismissAnimated:YES];
    }
    self.flag = !self.flag;
}

#pragma mark CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // User can tap CMPopTipView to dismiss it
    self.flag = !self.flag;
}
@end
