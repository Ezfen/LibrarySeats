//
//  SeatTableViewCell.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/9.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeatTableViewCell : UITableViewCell
@property (strong, nonatomic) NSString *venueName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *openTime;
@property (nonatomic) NSInteger index;
@end
