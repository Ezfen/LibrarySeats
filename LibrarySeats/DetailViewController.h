//
//  DetailViewController.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/13.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger venueID;    //场馆ID
@property (nonatomic) BOOL category;        //判断是从座位界面调用还是占座界面调用,YES:座位,NO:占座
@property (nonatomic) id sourceViewController; 
@end
