//
//  LocationHandler.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/4.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationHandler.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationHandler () <CLLocationManagerDelegate>
//定位
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationHandler

+ (LocationHandler *)sharedLocationHandler {
    //单例模式创建LocationHandler
    static LocationHandler *handler;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (CLLocationManager *)locationManager {
    if (_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        //iOS8以上需要请求用户授予权限
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
        //设置代理
        _locationManager.delegate = self;
        //设置定位精确度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位频率
        CLLocationDistance distance = 10;
        _locationManager.distanceFilter = distance;
        
    }
    return _locationManager;
}

- (void)startUpdatingLocation {
    if ([CLLocationManager locationServicesEnabled] && !([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
        [self.locationManager startUpdatingLocation];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前定位服务未能使用，请前往设置打开以便检测当前位置" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil
                                                   message:[NSString stringWithFormat:@"经度:%f,纬度:%f",coordinate.longitude,coordinate.latitude]
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [view show];
}

@end
