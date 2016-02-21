//
//  SeatTableViewCell.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/9.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "SeatTableViewCell.h"

@interface SeatTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLocationLabel;
@property (weak, nonatomic) IBOutlet UITextView *openTimeTextView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@end

@implementation SeatTableViewCell

- (void)setIndex:(NSInteger)index {
    [self setUI:index+1];
}

- (void)setUI:(NSInteger)index {
    self.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"seat-background%i",index]];
    self.backgroundImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundImageView.layer.borderWidth = 1;
    self.backgroundImageView.layer.cornerRadius = 10;
    self.backgroundImageView.clipsToBounds = YES;
    self.openTimeTextView.text = self.openTime;
    self.openTimeTextView.font = [UIFont systemFontOfSize:18];
    self.openTimeTextView.textColor = [UIColor whiteColor];
    self.venueNameLabel.text = self.venueName;
    self.venueLocationLabel.text = self.location;
}

@end
