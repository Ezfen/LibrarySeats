//
//  Tip.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/16.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tip : NSObject
@property (strong ,nonatomic) UIColor *tipColor;
@property (strong, nonatomic) NSString *tipDetail;

- (instancetype)initWithTipColor:(UIColor *)tipColor andTipDetail:(NSString *)tipDetail;

@end
