//
//  SeatsProgressView.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/11.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SeatsProgressView.h"

@interface SeatsProgressView ()
@property (strong, nonatomic) UILabel *label;   //比率
@property (strong, nonatomic) UILabel *titleLabel;//标题
@property (strong, nonatomic) UILabel *detailLabel;//简单细节
@end

static const int kCOMPLETED_LINE_WIDTH = 3;  //完成进度的线条宽度
static const int kLINE_WIDTH = 1; //线条宽度

@implementation SeatsProgressView

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 160, 160) andTotal:100 andCount:0];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andTotal:100 andCount:0];
}

- (instancetype)initWithFrame:(CGRect)frame andTotal:(NSInteger)total andCount:(NSInteger)count {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.6];
        self.layer.borderWidth = .5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        _clockwise = YES;
        [self addLabel];
        [self setProgressTotal:total];
        [self setProgressCount:count];
    }
    return self;
}

#pragma mark - setter
- (void)setProgressTotal:(NSInteger)progressTotal {
    _progressTotal = progressTotal;
    _detailLabel.text = [NSString stringWithFormat:@"座位总数:%i",_progressTotal];
    [self setNeedsDisplay];
}

- (void)setProgressCount:(NSInteger)progressCount {
    _progressCount = progressCount;
    _label.text = [NSString stringWithFormat:@"%i",_progressCount];
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

#pragma mark - OtherFunction 
- (void)addLabel {
    //设置中心字体
    UIFont *font = [UIFont systemFontOfSize:64];
    CGFloat maxWidth = self.bounds.size.width * .3;
    while (font.pointSize > maxWidth) {
        font = [font fontWithSize:font.pointSize - 1];
    }
    //添加progressView中间的Label
    CGFloat horizontalPadding = self.bounds.size.width * 1.0 / 4.0;
    CGFloat offset = horizontalPadding + kCOMPLETED_LINE_WIDTH + 10;
    CGFloat width = self.bounds.size.width - offset;
    CGFloat height = self.bounds.size.height - offset;
    _label = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + offset, self.bounds.origin.y + offset, width, height)];
    CGPoint center = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2.0, self.bounds.origin.y + self.bounds.size.height / 2.0);
    _label.center = center;
    _label.font = font;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.adjustsFontSizeToFitWidth = YES;
    _label.textColor = [UIColor grayColor];
    _label.numberOfLines = 0;
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
    
    //设置标题和详细Label字体
    maxWidth = self.bounds.size.width * .1;
    while (font.pointSize > maxWidth) {
        font = [font fontWithSize:font.pointSize - 1];
    }
    //添加progressView标题Label
    CGFloat minY = CGRectGetMinY(_label.frame);
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, minY - 10, self.bounds.size.width, 10)];
    _titleLabel.font = font;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 0;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    
    //添加progressView简单概要Label
    CGFloat maxY = CGRectGetMaxY(_label.frame);
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, maxY, self.bounds.size.width, 10)];
    _detailLabel.font = font;
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.textColor = [UIColor blackColor];
    _detailLabel.numberOfLines = 0;
    _detailLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_detailLabel];
}

#pragma mark - draw
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (_progressTotal <= 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize size = self.bounds.size;
    CGPoint center = CGPointMake(size.width / 2.0, size.height / 2.0);
    
    CGFloat horizontalPadding = self.bounds.size.width * 1.0 / 4.0;
    CGFloat radius = size.width / 2.0 - horizontalPadding;
    [self drawSlices:self.progressTotal completed:self.progressCount radius:radius center:center inContext:context];
    
}

- (void)drawSlices:(NSInteger)total completed:(NSInteger)completed radius:(CGFloat)radius center:(CGPoint)center inContext:(CGContextRef)context {
    BOOL clockwise = !_clockwise;
    //画两个圆弧，一个代表已完成的进度，另一个代表未完成的进度
    float originAngle = -M_PI_2, endAngle = originAngle + 2 * M_PI;   //起点和终点
    float sliceAngle = 2 * M_PI / self.progressTotal; //根据总数将圆弧分段
    float progressAngle = sliceAngle * self.progressCount + originAngle;
    //绘制未完成的进度条
    if (self.progressCount < self.progressTotal) {
        CGContextSetLineWidth(context, kLINE_WIDTH);
        CGContextAddArc(context, center.x, center.y, radius, progressAngle, endAngle, clockwise);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextDrawPath(context, kCGPathStroke);
    }
    //绘制完成的进度条
    CGContextAddArc(context, center.x, center.y, radius, originAngle, progressAngle, clockwise);
    if (!self.lineColor) {
        UIColor *color;
        float percent = (float)self.progressCount / (float)self.progressTotal;
        if (percent < 0.6) {
            color = [UIColor colorWithRed:0 green:205 blue:0 alpha:1];
        } else if (percent > 0.8) {
            color = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
        } else {
            color = [UIColor colorWithRed:255 green:165 blue:0 alpha:1];
        }
        CGContextSetStrokeColorWithColor(context, color.CGColor);
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    }
    CGContextSetLineWidth(context, kCOMPLETED_LINE_WIDTH);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    
}



@end
