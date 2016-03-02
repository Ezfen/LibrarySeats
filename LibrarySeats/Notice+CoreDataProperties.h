//
//  Notice+CoreDataProperties.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/3/2.
//  Copyright © 2016年 阿澤. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Notice.h"

NS_ASSUME_NONNULL_BEGIN

@interface Notice (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *iD;
@property (nullable, nonatomic, retain) NSString *lastUpdate;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
