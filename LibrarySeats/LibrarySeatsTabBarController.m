//
//  LibrarySeatsTabBarController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/7.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "LibrarySeatsTabBarController.h"
#import "NoticesViewController.h"
#import "SignInQRCodeViewController.h"
#import "SeatsViewController.h"
#import "BookingViewController.h"
#import "MineViewController.h"
#import "CMPopTipView.h"

@interface LibrarySeatsTabBarController () <CMPopTipViewDelegate>
@property (strong, nonatomic) UIView *transparentView;
@property (strong, nonatomic) CMPopTipView *navBarLeftButtonPopTipView;
@property (nonatomic) bool flag;
@end

@implementation LibrarySeatsTabBarController

# pragma - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewControllers = @[[self ViewControlWithTabBarItemTitle:@"座位"
                                                     andItemImage:[UIImage imageNamed:@"main_home"]
                                                    selectedImage:[UIImage imageNamed:@"main_homeh"]],
                             [self ViewControlWithTabBarItemTitle:@"公告"
                                                     andItemImage:[UIImage imageNamed:@"main_message"]
                                                    selectedImage:[UIImage imageNamed:@"main_messageh"]],
                             [self ViewControlWithTabBarItemTitle:nil andItemImage:nil selectedImage:nil],
                             [self ViewControlWithTabBarItemTitle:@"占座"
                                                     andItemImage:[UIImage imageNamed:@"main_booking"]
                                                    selectedImage:[UIImage imageNamed:@"main_bookingh"]],
                             [self ViewControlWithTabBarItemTitle:@"我的"
                                                     andItemImage:[UIImage imageNamed:@"main_mine"]
                                                    selectedImage:[UIImage imageNamed:@"main_mineh"]]];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"lock"] backgroundImage:[UIImage imageNamed:@"background"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - OtherFunction
- (UIViewController *) ViewControlWithTabBarItemTitle:(NSString *)title andItemImage:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"公告"]) {
        viewController = [[NoticesViewController alloc] init];
    } else if ([title isEqualToString:@"座位"]){
        viewController = [[SeatsViewController alloc] init];
    } else if ([title isEqualToString:@"我的"]) {
        viewController = [[MineViewController alloc] init];
    } else {
        viewController = [[BookingViewController alloc] init];
    }
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    viewController.tabBarItem = item;
    return viewController;
}


- (void) addCenterButtonWithImage:(UIImage *)image backgroundImage:(UIImage *)backgroundImage {
    UIImageView *view = [[UIImageView alloc] initWithImage:backgroundImage];
    CGFloat heightDifference = backgroundImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference > 0) {
        CGPoint center = self.tabBar.center;
        center.y -= heightDifference/2.0;
        view.center = center;
    } else {
        view.center = self.tabBar.center;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    button.center = self.tabBar.center;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(lock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view];
    [self.view addSubview:button];
}

- (void)lock {
    SignInQRCodeViewController *signIn = [[SignInQRCodeViewController alloc] init];
    [signIn setTitle:@"锁定位置"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signIn];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)showOrHideTip {
    if (!self.flag) {
        [self.navBarLeftButtonPopTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    } else {
        [self.navBarLeftButtonPopTipView dismissAnimated:YES];
    }
    self.flag = !self.flag;
}

#pragma mark - CMPopViewDelegate
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    self.flag = !self.flag;
}

#pragma mark - setter & getter
- (CMPopTipView *)navBarLeftButtonPopTipView {
    if (!_navBarLeftButtonPopTipView) {
        _navBarLeftButtonPopTipView = [[CMPopTipView alloc] initWithMessage:@""];
        _navBarLeftButtonPopTipView.delegate = self;
        _navBarLeftButtonPopTipView.dismissTapAnywhere = YES;
    }
    return _navBarLeftButtonPopTipView;
}

- (void)setTipMessage:(NSString *)tipMessage {
    _tipMessage = tipMessage;
    self.navBarLeftButtonPopTipView.message = tipMessage;
}

- (void)setShowTipMessageButton:(bool)showTipMessageButton {
    if (!showTipMessageButton) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        UIBarButtonItem *tipBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showOrHideTip)];
        self.navigationItem.rightBarButtonItem = tipBarButton;
        self.flag = NO;
    }
}

@end
