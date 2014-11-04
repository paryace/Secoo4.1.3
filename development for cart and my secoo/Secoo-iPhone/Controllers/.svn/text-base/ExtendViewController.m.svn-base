//
//  ExtendViewController.m
//  MySecoo
//
//  Created by Paney on 14-6-12.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ExtendViewController.h"

@interface ExtendViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;

- (void)_goBack;//返回
@end

@implementation ExtendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [backButton setFrame:CGRectMake(10, 30, 55, 33)];
    } else {
        [backButton setFrame:CGRectMake(10, 10, 55, 33)];
    }
    [backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.userInteractionEnabled = YES;
    _webView.opaque = NO;
    _webView.scalesPageToFit = YES;
    
    [self.view addSubview:_webView];
    [self.view addSubview:backButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.webURLString) {
        NSURL *url = [NSURL URLWithString:_webURLString];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }

}

#pragma mark -
- (void)_goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
