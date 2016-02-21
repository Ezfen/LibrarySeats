//
//  SignInQRCodeViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/9.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "SignInQRCodeViewController.h"
#import "NetworkHandler.h"
#import "PQFBouncingBalls.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SignInQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate, NetworkHandlerDelegate>
//AVFoundation扫描二维码
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) NetworkHandler *networkHandler;

//UI
@property (strong, nonatomic) UIImageView *scanLine;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL upOrDown;  //scanLine移动方向，YES向上，NO向下
@property (nonatomic) NSInteger num;  //scanLine每次移动的单位距离
@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;
@end

@implementation SignInQRCodeViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    [self setupAVFoundation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer invalidate];
    [_session stopRunning];
    _upOrDown = NO;
    _num = 0;
}

#pragma mark - setter getter
- (NetworkHandler *)networkHandler {
    if (!_networkHandler) {
        _networkHandler = [NetworkHandler sharedNetworkHandler];
        _networkHandler.delegate = self;
    }
    return _networkHandler;
}

- (NSString *)requestURL {
    return @"/seat/lockseat.action";
}

- (PQFBouncingBalls *)bouncingBalls {
    if (!_bouncingBalls) {
        _bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:self.view];
        _bouncingBalls.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    return _bouncingBalls;
}

#pragma mark - OtherFunction
- (void)layoutUI {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width,screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, screenWidth, 110)];
    view1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    [self.view addSubview:view1];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 130, (screenWidth - 280) / 2.0, 280)];
    view2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    [self.view addSubview:view2];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake((screenWidth + 280) / 2.0, 130, (screenWidth - 280) / 2.0, 280)];
    view3.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    [self.view addSubview:view3];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 410, screenWidth, screenHeight - 390)];
    view4.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    [self.view addSubview:view4];
    
    //添加提示Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, [UIScreen mainScreen].bounds.size.width - 30, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"请将二维码图像置于方框内";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)/2.0, 120, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg.png"];
    [self.view addSubview:imageView];
    
    _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 220)/2.0, 130, 220, 2)];
    _scanLine.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_scanLine];
    
    _upOrDown = NO;
    _num = 0;
}

- (void)animation {
    if (!_upOrDown) {
        _num ++;
        _scanLine.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 220)/2.0, 130 + 2 * _num, 220, 2);
        if (2 * _num == 280) {
            _upOrDown = YES;
        }
    } else {
        _num --;
        _scanLine.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 220)/2.0, 130 + 2 * _num, 220, 2);
        if (2 * _num == 0) {
            _upOrDown = NO;
        }
    }
}

- (void)setupAVFoundation {
    //session
    _session = [[AVCaptureSession alloc] init];
    //device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //input
    NSError *error;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        return ;
    }
    //output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_session addOutput:_output];
    //原点在右上角，且x轴和y轴调换
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width,screenHeight = [UIScreen mainScreen].bounds.size.height;
    [_output setRectOfInterest:CGRectMake(130.0/screenHeight, ((screenWidth - 300)/2.0 + 10)/screenWidth, 280.0/screenHeight, 280/screenWidth)];
    [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //add preview layer
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    //start
    [_session startRunning];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AVCaptureMetaDataOutputDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue = nil;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        stringValue = metadataObject.stringValue;
    }
    [_session stopRunning];
    [_timer invalidate];
    [self.bouncingBalls show];
    [self lockSeat:[stringValue intValue]];
}


#pragma mark - network
- (void)lockSeat:(int) seatID {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?seatID=%i&userID=1",WEBSITE, [self requestURL], seatID];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.networkHandler responseMessageFromURL:url];
}

#pragma mark - networkHandlerDelegate
- (void)requestSuccess:(NSDictionary *)responseMessage {
    if ([responseMessage[@"response"] isEqualToString:@"success"]) {
        [self showAlertView:@"锁定成功"];
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
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }];
}

@end
