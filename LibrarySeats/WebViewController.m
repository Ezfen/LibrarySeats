//
//  WebViewController.m
//  LibrarySeats
//
//  Created by 阿澤🍀 on 15/12/17.
//  Copyright © 2015年 阿澤. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIBarButtonItem *back;
@property (strong, nonatomic) UIBarButtonItem *forward;
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation WebViewController

#pragma mark - setter & getter
- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.scalesPageToFit = YES;  //设置WebView的放大缩小功能
        _webView.delegate = self;
    }
    return _webView;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.bounds = CGRectMake(0, 0, 48, 48);
        [btnBack setTitle:@"后退" forState:UIControlStateNormal];
        [btnBack setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnBack setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//        [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [btnBack setImage:[UIImage imageNamed:@"back_disable"] forState:UIControlStateDisabled];
        [btnBack addTarget:self action:@selector(webViewBack) forControlEvents:UIControlEventTouchUpInside];
        _back = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        _back.enabled = NO;
        UIBarButtonItem *spacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIButton *btnForward = [UIButton buttonWithType:UIButtonTypeCustom];
        btnForward.bounds = CGRectMake(0, 0, 48, 48);
        [btnForward setTitle:@"前进" forState:UIControlStateNormal];
        [btnForward setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnForward setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//        [btnForward setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
//        [btnForward setImage:[UIImage imageNamed:@"forward_disabel"] forState:UIControlStateDisabled];
        [btnForward addTarget:self action:@selector(webViewForward) forControlEvents:UIControlEventTouchUpInside];
        _forward = [[UIBarButtonItem alloc] initWithCustomView:btnForward];
        _forward.enabled = NO;
        _toolBar.items = @[_back,spacing,_forward];
    }
    return _toolBar;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self request:_urlStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - OtherFunction
- (void)webViewBack {
    [_webView goBack];
}

- (void)webViewForward {
    [_webView goForward];
}

- (void)setBarItemState {
    if ([_webView canGoBack]) {
        _back.enabled = YES;
    } else {
        _back.enabled = NO;
    }
    if ([_webView canGoForward]) {
        _forward.enabled = YES;
    } else {
        _forward.enabled = NO;
    }
}

- (void)request:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)layoutUI {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backToNoticesView)];
    leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolBar];
}

- (void)backToNoticesView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self setBarItemState];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接发生错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
