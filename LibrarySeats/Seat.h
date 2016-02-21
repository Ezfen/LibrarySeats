//
//  Seat.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/12.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Seat : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSInteger venueID;
@property (nonatomic) NSInteger seatNum;
@property (nonatomic) NSInteger userID;
@property (nonatomic, getter=isUsed) BOOL used;
@property (nonatomic, getter=isBooked) BOOL booked;
@property (strong, nonatomic) NSString *deadLineTime;

@end
