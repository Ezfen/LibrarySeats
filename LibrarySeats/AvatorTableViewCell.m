//
//  AvatorTableViewCell.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/13.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "AvatorTableViewCell.h"

@interface AvatorTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@end

@implementation AvatorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
