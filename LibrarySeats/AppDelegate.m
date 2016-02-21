//
//  AppDelegate.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/7.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:23/255.0 green:180/255.0 blue:237/255.0 alpha:1]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self changeViewController];
    return YES;
}

- (void)changeViewController {
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:USERNAME];
    
    NSString *controllId = data ? @"TabBar" : @"Login";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllId];
    
    if (!data) {
//        ((UINavigationController *)self.window.rootViewController).navigationBarHidden = YES;
        self.window.rootViewController = controller;
//        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
    } else {
        User *user = [User sharedUser];
        [user setUser:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
//        [(UINavigationController *) self.window.rootViewController pushViewController:controller animated:YES];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
