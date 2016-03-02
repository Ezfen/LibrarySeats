//
//  Venue+CoreDataProperties.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/2/26.
//  Copyright © 2016年 阿澤. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Venue.h"

NS_ASSUME_NONNULL_BEGIN

@interface Venue (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *bookedSeatNum;
@property (nullable, nonatomic, retain) NSString *direction;
@property (nullable, nonatomic, retain) NSString *floor;
@property (nullable, nonatomic, retain) NSNumber *iD;
@property (nullable, nonatomic, retain) NSNumber *libraryID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *openTime;
@property (nullable, nonatomic, retain) NSNumber *totalSeatNum;
@property (nullable, nonatomic, retain) Library *library;
@property (nullable, nonatomic, retain) NSSet<Seat *> *seats;

@end

@interface Venue (CoreDataGeneratedAccessors)

- (void)addSeatsObject:(Seat *)value;
- (void)removeSeatsObject:(Seat *)value;
- (void)addSeats:(NSSet<Seat *> *)values;
- (void)removeSeats:(NSSet<Seat *> *)values;

@end

NS_ASSUME_NONNULL_END
