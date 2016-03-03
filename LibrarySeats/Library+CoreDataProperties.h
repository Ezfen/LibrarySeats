//
//  Library+CoreDataProperties.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/3/3.
//  Copyright © 2016年 阿澤. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Library.h"

NS_ASSUME_NONNULL_BEGIN

@interface Library (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *iD;
@property (nullable, nonatomic, retain) NSString *libraryAddress;
@property (nullable, nonatomic, retain) NSString *libraryName;
@property (nullable, nonatomic, retain) NSSet<Venue *> *venues;

@end

@interface Library (CoreDataGeneratedAccessors)

- (void)addVenuesObject:(Venue *)value;
- (void)removeVenuesObject:(Venue *)value;
- (void)addVenues:(NSSet<Venue *> *)values;
- (void)removeVenues:(NSSet<Venue *> *)values;

@end

NS_ASSUME_NONNULL_END
