//
//  User.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/23.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *ID;             //ID
@property (strong, nonatomic) NSString *number;         //学号
@property (strong, nonatomic) NSString *name;           //姓名
@property (strong, nonatomic) NSString *phoneNumber;    //手机号码
@property (strong, nonatomic) NSString *academy;        //学院
@property (strong, nonatomic) NSString *major;          //专业
@property (strong, nonatomic) NSString *grade;          //年级
@property (strong, nonatomic) NSNumber *sex;            //性别
@property (strong, nonatomic) NSString *avatorURL;      //头像地址
@property (strong, nonatomic) NSString *selectedVenue;  //占座场馆
@property (strong, nonatomic) NSNumber *selecetdSeat;   //占座座位号
@property (strong, nonatomic) NSString *deadLineTime;   //座位到期时间

+ (instancetype)sharedUser;
- (NSString *)valueForIndex:(int)index;
- (void)setUser:(User *)user;
@end
