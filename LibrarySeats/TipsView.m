//
//  TipsView.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/16.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Tip.h"
#import "TipsView.h"

@interface TipsView()
@property (nonatomic) NSUInteger count;
@end

const static int padding = 25;

@implementation TipsView

- (void)setTips:(NSDictionary *)tips {
    _tips = tips;
    _count = _tips.count;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat screenWidth = self.frame.size.width;
    CGFloat drawWidth = screenWidth - 2 * padding;
    CGFloat offset = drawWidth / _count, __block origin = padding;
    CGFloat rectHeight = self.bounds.size.height- 10;
    CGContextRef context = UIGraphicsGetCurrentContext();
    TipsView __weak *weakSelf = self;
    [_tips enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        Tip *tip = (Tip *)obj;
        CGContextSetFillColorWithColor(context, tip.tipColor.CGColor);
        CGContextFillRect(context, CGRectMake(origin, 5, rectHeight, rectHeight));
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(origin + rectHeight, 5, offset - rectHeight, rectHeight)];
        label.text = [NSString stringWithFormat:@":%@",tip.tipDetail];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [weakSelf addSubview:label];
        origin += offset;
    }];
    
}


@end