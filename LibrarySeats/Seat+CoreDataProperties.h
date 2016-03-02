//
//  Seat+CoreDataProperties.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/2/26.
//  Copyright © 2016年 阿澤. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Seat.h"

NS_ASSUME_NONNULL_BEGIN

@interface Seat (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *deadLineTime;
@property (nullable, nonatomic, retain) NSNumber *iD;
@property (nullable, nonatomic, retain) NSNumber *isBooked;
@property (nullable, nonatomic, retain) NSNumber *seatNum;
@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) NSNumber *venueID;
@property (nullable, nonatomic, retain) Venue *venue;

@end

NS_ASSUME_NONNULL_END
