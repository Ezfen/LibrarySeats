//
//  SeatTableHeaderView.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/10.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "SeatTableHeaderView.h"

@interface SeatTableHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@end

@implementation SeatTableHeaderView

- (void)setFloor:(NSString *)floor {
    _floor = floor;
    self.floorLabel.text = floor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
