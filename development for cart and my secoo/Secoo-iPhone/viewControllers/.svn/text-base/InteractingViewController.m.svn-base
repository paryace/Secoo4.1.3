//
//  InteractingViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/29/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "InteractingViewController.h"
#import "WebViewJavascriptBridge.h"

@interface InteractingViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) WebViewJavascriptBridge *javaBridger;
@end

@implementation InteractingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadURL:self.url];
    self.title = @"用户登录";
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelLogIn)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    if (self.javaBridger == nil) {
        self.javaBridger = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:nil handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"%@", data);
            NSArray *array = [data componentsSeparatedByString:@"$_$"];
            if ([array count] == 4) {
                if ([[array objectAtIndex:0] isEqualToString:@"objc:sendUpkInfo"] && [[array objectAtIndex:1] isEqualToString:@"productionViewController"]) {
                    if ([[array objectAtIndex:2] isEqualToString:@"false"]) {
                        NSString *url = [array objectAtIndex:3];
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        InteractingViewController *interactVC = [storyboard instantiateViewControllerWithIdentifier:@"InteractingViewController"];
                        interactVC.url = url;
                        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:interactVC];
                        [self presentViewController:naviVC animated:YES completion:nil];
                    }
                    else if ([[array objectAtIndex:2] isEqualToString:@"true"]){
                        NSString *upKey = [array objectAtIndex:3];
                        //[UserInfoManager setUserUpKey:upKey];
                        //
                    }
                    
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadURL:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

#pragma mark
#pragma mark ---call back function
- (void)cancelLogIn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
