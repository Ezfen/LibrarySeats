//
//  SeatsProgressView.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/11.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeatsProgressView : UIView

//标题
@property (strong, nonatomic) NSString *title;
//总数
@property (nonatomic) NSInteger progressTotal;
//当前数量
@property (nonatomic) NSInteger progressCount;
//progressView是否按照顺时针转动,默认为YES
@property (nonatomic) BOOL clockwise;
//线条颜色，0-60：green，61-80：orange，81-100：red
@property (strong, nonatomic) UIColor *lineColor;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andTotal:(NSInteger)total andCount:(NSInteger)count;

@end
