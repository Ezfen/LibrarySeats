//
//  LeftTimeView.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/12.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "LeftTimeView.h"
#import <JDFlipNumberView/JDDateCountdownFlipView.h>

@interface LeftTimeView ()
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (strong, nonatomic) JDDateCountdownFlipView *dataCountdownFlipView;
@end

@implementation LeftTimeView

- (void)awakeFromNib {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.clockView.backgroundColor = [UIColor clearColor];
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    [self setupDateCountdownFlipView:dateStr];
}

- (void)setupDateCountdownFlipView:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    if (_dataCountdownFlipView) {
        [_dataCountdownFlipView removeFromSuperview];
        _dataCountdownFlipView = nil;
    }
    _dataCountdownFlipView = [[JDDateCountdownFlipView alloc] initWithDayDigitCount:0];
    _dataCountdownFlipView = [[JDDateCountdownFlipView alloc] initWithFrame:CGRectMake(0, 5, self.clockView.frame.size.width, self.clockView.frame.size.height)];
    [self.clockView addSubview:_dataCountdownFlipView];
    
    _dataCountdownFlipView.targetDate = date;
    [_dataCountdownFlipView start];
}

@end
