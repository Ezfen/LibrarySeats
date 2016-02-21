//
//  BookingViewController.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/28.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingViewController : UIViewController
@property (nonatomic) NSInteger selectedSeatID;  //选择座位的id

- (void)subViewDismiss;
@end
