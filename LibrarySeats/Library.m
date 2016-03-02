//
//  Library.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/2/26.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "Library.h"
#import "Venue.h"

@implementation Library

// Insert code here to add functionality to your managed object subclass

+ (instancetype)sharedLibrary {
    static Library *library;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        library = [Library new];
    });
    return library;
}

- (NSMutableArray *)allVenues {
    if (!self.venues) return nil;
    NSMutableArray *allVenues = [[NSMutableArray alloc] init];
    for (Venue *venue in self.venues) {
        if (venue.totalSeatNum != 0) {
            [allVenues addObject:venue];
        }
    }
    return allVenues;
}

@end
