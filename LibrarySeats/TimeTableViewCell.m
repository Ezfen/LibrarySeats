//
//  TimeTableViewCell.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/10.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "TimeTableViewCell.h"
#import "User.h"
#import <JDFlipNumberView/JDDateCountdownFlipView.h>

@interface TimeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UIView *timeCounter;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) JDDateCountdownFlipView *dataCountdownFlipView;
@end

@implementation TimeTableViewCell

- (User *)user {
    if (!_user) {
        _user = [User sharedUser];
    }
    return _user;
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    [self setupDateCountdownFlipView:dateStr];
}

- (void)awakeFromNib {
    // Initialization code
    self.venueLabel.text = self.user.selectedVenue;
    self.numLabel.text = self.user.selecetdSeat ? [NSString stringWithFormat:@"第%@号座位",self.user.selecetdSeat] : @"";
    [self setupDateCountdownFlipView:self.user.deadLineTime];
}

- (void)setupDateCountdownFlipView:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date;
    if (!dateStr) {
        date = [NSDate date];
    } else date = [dateFormatter dateFromString:dateStr];
    
    if (_dataCountdownFlipView) {
        [_dataCountdownFlipView removeFromSuperview];
        _dataCountdownFlipView = nil;
    }
    _dataCountdownFlipView = [[JDDateCountdownFlipView alloc] initWithDayDigitCount:0];
    _dataCountdownFlipView = [[JDDateCountdownFlipView alloc] initWithFrame:CGRectMake(0, 5, self.timeCounter.frame.size.width, self.timeCounter.frame.size.height)];
    [self.timeCounter addSubview:_dataCountdownFlipView];
    
    _dataCountdownFlipView.targetDate = date;
    [_dataCountdownFlipView start];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
