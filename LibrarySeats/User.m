//
//  User.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/23.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "User.h"
#import "NetworkHandler.h"

@implementation User

+ (instancetype)sharedUser {
    static User *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [User new];
    });
    return user;
}

- (void)setUser:(User *)user {
    self.name = user.name;
    self.ID = user.ID;
    self.number = user.number;
    self.phoneNumber = user.phoneNumber;
    self.academy = user.academy;
    self.major = user.major;
    self.grade = user.grade;
    self.sex = user.sex;
    self.avatorURL = user.avatorURL;
    self.selectedVenue = user.selectedVenue;
    self.selecetdSeat = user.selecetdSeat;
    self.deadLineTime = user.deadLineTime;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.number = [aDecoder decodeObjectForKey:@"number"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        self.academy = [aDecoder decodeObjectForKey:@"academy"];
        self.major = [aDecoder decodeObjectForKey:@"major"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.avatorURL = [aDecoder decodeObjectForKey:@"avatorURL"];
        self.selectedVenue = [aDecoder decodeObjectForKey:@"selectedVenue"];
        self.selecetdSeat = [aDecoder decodeObjectForKey:@"selectedSeat"];
        self.deadLineTime = [aDecoder decodeObjectForKey:@"deadLineTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.number forKey:@"number"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:self.academy forKey:@"academy"];
    [aCoder encodeObject:self.major forKey:@"major"];
    [aCoder encodeObject:self.grade forKey:@"grade"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.avatorURL forKey:@"avatorURL"];
    [aCoder encodeObject:self.selectedVenue forKey:@"selectedVenue"];
    [aCoder encodeObject:self.selecetdSeat forKey:@"selectedSeat"];
    [aCoder encodeObject:self.deadLineTime forKey:@"deadLineTime"];
}

- (NSString *)valueForIndex:(int)index{
    switch (index) {
        case 0:
            return self.avatorURL;
        case 1:
            return self.name;
        case 2:
            if ([self.sex integerValue] == 1) {
                return @"男";
            } else return @"女";
        case 3:
            return self.phoneNumber;
        case 4:
            return self.number;
        case 5:
            return self.academy;
        case 6:
            return self.major;
        case 7:
            return self.grade;
    }
    return nil;
}

@end
