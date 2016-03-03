//
//  Seat.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/2/26.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Venue;

@interface Seat : NSObject

@property (nonatomic, strong) NSString *deadLineTime;
@property (nonatomic, strong) NSNumber *iD;
@property (nonatomic, strong) NSNumber *isBooked;
@property (nonatomic, strong) NSNumber *seatNum;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *venueID;
@property (nonatomic, strong) Venue *venue;

@end

