//
//  Library.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/11.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "Library.h"
#import "Venue.h"

@implementation Library

+ (instancetype)sharedLibrary {
    static Library *library;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        library = [Library new];
    });
    return library;
}

- (void)cleanData {
    [self.firsrFloor removeAllObjects];
    [self.secondFloor removeAllObjects];
    [self.thirdFloor removeAllObjects];
    [self.fourthFloor removeAllObjects];
    [self.fifthFloor removeAllObjects];
}

- (void)classifyVenueByFloor:(Venue *)venue {
    NSString *floor = venue.floor;
    if ([floor isEqualToString:@"一楼"]) {
        [self.firsrFloor addObject:venue];
        return ;
    }
    if ([floor isEqualToString:@"二楼"]) {
        [self.secondFloor addObject:venue];
        return ;
    }
    if ([floor isEqualToString:@"三楼"]) {
        [self.thirdFloor addObject:venue];
        return ;
    }
    if ([floor isEqualToString:@"四楼"]) {
        [self.fourthFloor addObject:venue];
        return ;
    }
    if ([floor isEqualToString:@"五楼"]) {
        [self.fifthFloor addObject:venue];
        return ;
    }
}

- (NSMutableArray *)venues {
    if (!_venues) {
        _venues = [NSMutableArray new];
        for (NSMutableArray *array in @[self.firsrFloor,self.secondFloor,self.thirdFloor,self.fourthFloor,self.fifthFloor]) {
            [_venues addObject:array];
        }
    }
    return _venues;
}

- (NSMutableArray *)firsrFloor {
    if (!_firsrFloor) {
        _firsrFloor = [NSMutableArray new];
    }
    return _firsrFloor;
}

- (NSMutableArray *)secondFloor {
    if (!_secondFloor) {
        _secondFloor = [NSMutableArray new];
    }
    return _secondFloor;
}

- (NSMutableArray *)thirdFloor {
    if (!_thirdFloor) {
        _thirdFloor = [NSMutableArray new];
    }
    return _thirdFloor;
}

- (NSMutableArray *)fourthFloor {
    if (!_fourthFloor) {
        _fourthFloor = [NSMutableArray new];
    }
    return _fourthFloor;
}

- (NSMutableArray *)fifthFloor {
    if (!_fifthFloor) {
        _fifthFloor = [NSMutableArray new];
    }
    return _fifthFloor;
}

- (NSMutableArray *)allVenues {
    NSMutableArray *allVenues = [[NSMutableArray alloc] init];
    for (NSMutableArray *floor in self.venues) {
        for (Venue *venue in floor) {
            if (venue.totalSeatNum != 0) {
                [allVenues addObject:venue];
            }
        }
    }
    return allVenues;
}

@end
