//
//  LocationHandler.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/4.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocationManager;

@interface LocationHandler : NSObject

+ (LocationHandler *)sharedLocationHandler;

- (void)startUpdatingLocation;

@end
