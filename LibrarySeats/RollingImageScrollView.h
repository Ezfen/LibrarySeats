//
//  RollingImageScrollView.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/8.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RollingImageScrollViewDelegate <NSObject>
@required
//当滑动图片结束时调用
- (void)rollDidEndDecelerating;
@optional
- (void)tapImageView:(NSInteger)imageIndex;
@end

@interface RollingImageScrollView : UIScrollView
@property (nonatomic) int currentImageIndex; //当前页数
@property (nonatomic) int imageCount; //总图片数
@property (strong, nonatomic) NSArray<NSString *> *contents; //每张图片所对应的内容(NSString)
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) id<RollingImageScrollViewDelegate> rollingImageDelegate; //delagate

- (void)changeImage;//变换图片

@end
