//
//  NetworkHandler.h
//  LibrarySeats
//
//  Created by 阿澤🍀 on 16/1/11.
//  Copyright © 2016年 阿澤. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkHandlerDelegate <NSObject>

- (void)requestSuccess:(NSDictionary *)responseMessage;
- (void)requestError:(NSError *)error;

@end

@class AFURLSessionManager;
@interface NetworkHandler : NSObject

@property (nonatomic) id<NetworkHandlerDelegate> delegate;
@property (strong, nonatomic) AFURLSessionManager *sessionManager;

+ (instancetype)sharedNetworkHandler;
- (void)responseMessageFromURL:(NSURL *)url;

@end
