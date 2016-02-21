//
//  Tip.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/16.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "Tip.h"

@implementation Tip

- (instancetype)initWithTipColor:(UIColor *)tipColor andTipDetail:(NSString *)tipDetail {
    self = [super init];
    if (self) {
        _tipColor = tipColor;
        _tipDetail = tipDetail;
    }
    return self;
}

@end
