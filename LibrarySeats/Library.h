//
//  Library.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/11.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Venue;

@interface Library : NSObject
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *venues;
@property (strong, nonatomic) NSMutableArray *firsrFloor;
@property (strong, nonatomic) NSMutableArray *secondFloor;
@property (strong, nonatomic) NSMutableArray *thirdFloor;
@property (strong, nonatomic) NSMutableArray *fourthFloor;
@property (strong, nonatomic) NSMutableArray *fifthFloor;

+ (instancetype)sharedLibrary;
- (void)classifyVenueByFloor:(Venue *)venue;
- (void)cleanData;
- (NSMutableArray *)allVenues;

@end
