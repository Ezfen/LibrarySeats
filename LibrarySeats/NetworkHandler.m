//
//  NetworkHandler.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/11.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import "NetworkHandler.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkHandler ()

@end

@implementation NetworkHandler

static int netWorkTasksCount = 0;

+ (instancetype)sharedNetworkHandler {
    static NetworkHandler *networkHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkHandler = [[NetworkHandler alloc] init];
    });
    return networkHandler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)responseMessageFromURL:(NSURL *)url {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NetworkHandler *networkHandler = [NetworkHandler sharedNetworkHandler];
    AFURLSessionManager *sessinManager = networkHandler.sessionManager;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    netWorkTasksCount ++;
    
    NSURLSessionDataTask *dataTask = [sessinManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *responseMessage = (NSDictionary *)responseObject[@"responseMessage"];
            if ([self.delegate respondsToSelector:@selector(requestSuccess:)]) {
                [self.delegate requestSuccess:responseMessage];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(requestError:)]) {
                [self.delegate requestError:error];
            }
        }
        netWorkTasksCount --;
        if (netWorkTasksCount == 0) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
    [dataTask resume];

}

@end
