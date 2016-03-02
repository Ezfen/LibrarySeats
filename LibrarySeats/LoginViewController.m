//
//  LoginViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/28.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "PQFCustomLoaders/PQFBouncingBalls.h"
#import "NetworkHandler.h"

@interface LoginViewController () <UIAlertViewDelegate, UITextFieldDelegate, NetworkHandlerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *loginTitle;
@property (weak, nonatomic) IBOutlet UILabel *loginSubtitle;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NetworkHandler *networkHandler;
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@property (strong, nonatomic) UIAlertView *alertView;
@end

@implementation LoginViewController

- (User *)user {
    if (!_user) {
        _user = [User sharedUser];
    }
    return _user;
}

- (PQFBouncingBalls *)bouncingBalls {
    if (!_bouncingBalls) {
        _bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
        _bouncingBalls.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return _bouncingBalls;
}

- (NetworkHandler *)networkHandler {
    if (!_networkHandler) {
        _networkHandler = [NetworkHandler sharedNetworkHandler];
        _networkHandler.delegate = self;
    }
    return _networkHandler;
}

- (NSString *)requestURL {
    return @"/user/bind.action";
}

- (void)setNumberTextField:(UITextField *)numberTextField {
    _numberTextField = numberTextField;
    _numberTextField.delegate = self;
}

- (void)setPhoneTextField:(UITextField *)phoneTextField {
    _phoneTextField = phoneTextField;
    _phoneTextField.delegate = self;
}

- (UIAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    return _alertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDoneEditing:(id)sender {
    if (sender == self.numberTextField) {
        [self.phoneTextField becomeFirstResponder];
    }
    if (sender == self.phoneTextField) {
        [self.phoneTextField resignFirstResponder];
    }
}

- (void)backgroundTap {
    [self.numberTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

- (IBAction)login:(id)sender {
    if ([self.numberTextField.text isEqualToString:@""] || [self.phoneTextField.text isEqualToString:@""]) {
        [self.alertView show];
        return ;
    }
    [self.bouncingBalls show];
    [self bind];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    if ([self.numberTextField.text isEqualToString:@""]) {
        [self.numberTextField becomeFirstResponder];
        return ;
    }
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [self.phoneTextField becomeFirstResponder];
        return ;
    }
}

#pragma mark - textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 50);
    if (offset <= 0) {
        self.loginTitle.hidden = YES;
        self.loginSubtitle.hidden = YES;
        [UIView animateWithDuration:.3f animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.loginTitle.hidden = NO;
    self.loginSubtitle.hidden = NO;
    [UIView animateWithDuration:.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}

#pragma mark - network
- (void)bind {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?studentNum=%@&phoneNum=%@",WEBSITE, [self requestURL], self.numberTextField.text, self.phoneTextField.text];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.networkHandler responseMessageFromURL:url];
}

#pragma mark - networkHandlerDelegate
- (void)requestSuccess:(NSDictionary *)responseMessage {
    if ([responseMessage[@"response"] isEqualToString:@"success"]) {
        NSArray *array = responseMessage[@"datas"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            self.user.ID = @([dic[@"intID"] intValue]);
            self.user.sex = ([dic[@"intSex"] intValue] == 1) ? @(YES) : @(NO);
            self.user.academy = dic[@"vcAcademy"];
            self.user.avatorURL = dic[@"vcAvatorUrl"];
            self.user.grade = dic[@"vcGrade"];
            self.user.major = dic[@"vcMajor"];
            self.user.name = dic[@"vcName"];
            self.user.number = dic[@"vcNum"];
            self.user.phoneNumber = dic[@"vcPhoneNum"];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.user];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"USERNAME"];
        }];
        AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate changeViewController];
    } else {
        NSString *describe = responseMessage[@"describe"];
        [self showAlertView:describe];
    }
    [self.bouncingBalls remove];
}

- (void)requestError:(NSError *)error {
    [self.bouncingBalls remove];
    [self showAlertView:@"网络拥挤，请稍后再试"];
}

- (void)showAlertView:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
