//
//  RollingImageScrollView.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/8.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "RollingImageScrollView.h"

@interface RollingImageScrollView () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) NSMutableDictionary *imageInfo;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) NSMutableArray *labelArray; //of contentLabels
@end

@implementation RollingImageScrollView

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadImage];
        [self layoutUI];
    }
    return self;
}

#pragma mark - setter & getter
- (void)setContents:(NSArray<NSString *> *)contents {
    _contents = contents;
    [self addContentLabel];
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [[NSMutableArray alloc] init];
    }
    return _labelArray;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheImage)];
    }
    return _tapGesture;
}

#pragma mark - Private Function
- (void)loadImage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"imageInfo" ofType:@"plist"];
    _imageInfo = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    _imageCount = _imageInfo.count;
}

- (void)layoutUI {
    self.delegate = self;
    self.contentSize = CGSizeMake(3*[UIScreen mainScreen].bounds.size.width , self.frame.size.height);
    self.pagingEnabled = YES;
    [self setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:NO];
    self.showsHorizontalScrollIndicator = NO;
    
    //添加ImageViews
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, self.frame.size.height)];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_leftImageView];
    _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, self.frame.size.height)];
    _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _centerImageView.userInteractionEnabled = YES;
    [_centerImageView addGestureRecognizer:self.tapGesture];
    [self addSubview:_centerImageView];
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * screenWidth, 0, screenWidth, self.frame.size.height)];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_rightImageView];
    
    //设置默认图片
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_imageCount-1]];
    _centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",0]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",1]];
    _currentImageIndex = 0;
}

- (void)changeImage {
    int leftImageIndex, rightImageIndex;
    _currentImageIndex = (_currentImageIndex + 1) % _imageCount;
    _centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_currentImageIndex]];
    leftImageIndex = (_currentImageIndex + _imageCount - 1) % _imageCount;
    rightImageIndex = (_currentImageIndex + 1) % _imageCount;
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",leftImageIndex]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",rightImageIndex]];
    if (self.labelArray.count == _imageCount) {
        [_leftImageView addSubview:self.labelArray[leftImageIndex]];
        [_centerImageView addSubview:self.labelArray[_currentImageIndex]];
        [_rightImageView addSubview:self.labelArray[rightImageIndex]];
    }
    if ([_rollingImageDelegate respondsToSelector:@selector(rollDidEndDecelerating)]) {
        [_rollingImageDelegate rollDidEndDecelerating];
    }
}

- (void)addContentLabel {
    [_contents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *content = (NSString *)obj;
        CGRect rect = CGRectMake(0, self.frame.origin.y + self.frame.size.height / 2.0, self.frame.size.width, self.frame.size.height / 2.0);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        label.text = content;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        [self.labelArray addObject:view];
    }];
    if (self.labelArray.count == _imageCount) {
        [_leftImageView addSubview:self.labelArray[_imageCount - 1]];
        [_centerImageView addSubview:self.labelArray[0]];
        [_rightImageView addSubview:self.labelArray[1]];
    }
}

- (void)tapTheImage {
    if ([_rollingImageDelegate respondsToSelector:@selector(tapImageView:)]) {
        [_rollingImageDelegate tapImageView:_currentImageIndex];
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImage];
    [self setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:NO];
    if ([_rollingImageDelegate respondsToSelector:@selector(rollDidEndDecelerating)]) {
        [_rollingImageDelegate rollDidEndDecelerating];
    }
}

- (void)reloadImage {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int leftImageIndex, rightImageIndex;
    CGPoint offset = [self contentOffset];
    if (offset.x > screenWidth) {
        //向右滑动
        _currentImageIndex = (_currentImageIndex + 1) % _imageCount;
    } else if (offset.x < screenWidth) {
        //向左滑动
        _currentImageIndex = (_currentImageIndex + _imageCount - 1) % _imageCount;
    }
    _centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_currentImageIndex]];
    leftImageIndex = (_currentImageIndex + _imageCount - 1) % _imageCount;
    rightImageIndex = (_currentImageIndex + 1) % _imageCount;
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",leftImageIndex]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",rightImageIndex]];
    if (self.labelArray.count == _imageCount) {
        [_leftImageView addSubview:self.labelArray[leftImageIndex]];
        [_centerImageView addSubview:self.labelArray[_currentImageIndex]];
        [_rightImageView addSubview:self.labelArray[rightImageIndex]];
    }
}

@end
