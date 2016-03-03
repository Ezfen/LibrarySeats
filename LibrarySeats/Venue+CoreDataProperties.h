//
//  Venue+CoreDataProperties.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/3/3.
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

@end

NS_ASSUME_NONNULL_END
