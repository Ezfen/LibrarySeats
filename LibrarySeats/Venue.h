//
//  Venue.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/11.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSInteger libraryID;
@property (nonatomic) NSInteger totalSeatNum;
@property (nonatomic) NSInteger bookedSeatNum;
@property (nonatomic) NSInteger usedSeatNum;
@property (strong, nonatomic) NSString *venueName;
@property (strong, nonatomic) NSString *floor;
@property (strong, nonatomic) NSString *openTime;
@property (strong, nonatomic) NSString *seatDistribution;
@property (strong, nonatomic) NSString *direction;

@end
