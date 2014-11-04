//
//  DetailViewController.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "DetailViewController.h"
#import "ManagerDefault.h"
#import "WebViewJavascriptBridge.h"
#import "UITabBarController+SelectAnimating.h"
#import "MobClick.h"
#import "UINavigationBar+CustomNavBar.h"

@interface DetailViewController ()
{
    UIActivityIndicatorView *_activityView;
    
    CGFloat _contentY;//手指开始拖动时 scrollView 的 Y
    CGFloat _currentY;//手指滚动时 scrollView 的 Y
    CGFloat _oldY;//手指离开屏幕时

    UIView *_statusView;
}

@property(nonatomic, assign) BOOL prodList;//列表页
@property(nonatomic, assign) BOOL navBarIsHiddend;//隐藏了导航栏

@end

@implementation DetailViewController

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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    [ManagerDefault standardManagerDefaults].isUsed = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (!self.myWebView) {
        self.myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.myWebView.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.myWebView.scrollView setBackgroundColor:BACKGROUND_COLOR];
        self.myWebView.scrollView.decelerationRate = 1.0f;
        [self.myWebView setBackgroundColor:BACKGROUND_COLOR];
        [self.myWebView setScalesPageToFit:YES];
        [self.myWebView setOpaque:NO];
        [self.view addSubview:self.myWebView];
        
        //实例化 bridge
        __weak DetailViewController *weakSelf = self;
        [WebViewJavascriptBridge enableLogging];
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.myWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"Objc received message from JS: %@", data);
            [[ManagerDefault standardManagerDefaults] responseForMessageOfString:data viewController:weakSelf];
        }];
    }
    
    [ManagerDefault standardManagerDefaults].currentWebView = self.myWebView;
    self.openNewPage = NO;
    self.navigationItem.title = self.navTitle;
    
    NSString *viewNameLast = [[self.urlString componentsSeparatedByString:@"://"] lastObject];
    NSArray *viewNameArray = [viewNameLast componentsSeparatedByString:@"/"];
    if (viewNameArray.count > 3) {
        self.viewName = [[viewNameArray[3] componentsSeparatedByString:@"."] firstObject];
    } else {
        NSRange range = [self.urlString rangeOfString:@".action?"];
        if (range.location != NSNotFound) {
            self.viewName = [[self.urlString componentsSeparatedByString:@".action?"] lastObject];
        }
    }

    if (!([self isFinishLoad] || [self.myWebView isLoading])) {
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        
        if ([self.viewName isEqualToString:@"cartWrapper"]) {
            self.isShopVC = YES;
            NSLog(@"购物车");
            float version = floorf(NSFoundationVersionNumber);
            CGRect frame = self.view.bounds;
            if (!(version > NSFoundationVersionNumber_iOS_6_1)) {
                frame.size = CGSizeMake(frame.size.width, frame.size.height + 44);
            }
            self.myWebView.frame = frame;
            //友盟统计加入购物车
            [MobClick event:@"iOS_gouwuche_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_gouwuche_uv"];
        } else if ([self.viewName isEqualToString:@"postOrderSuccessWrapper"]) {
            
            //友盟统计 点击提交订单
            [MobClick event:@"iOS_dingdan_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_dingdan_uv"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateNow = [NSDate date];
            NSString *dateNowString = [formatter stringFromDate:dateNow];
            if ([dateNowString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"registerSuccess"]]) {
                //当天注册成功当天就提交订单
                [MobClick event:@"iOS_newDingdan"];
            }
            
        } else if ([self.viewName isEqualToString:@"prodDetail"]) {
            //友盟统计 到达详情页
            [MobClick event:@"iOS_item_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_item_uv"];
        } else if ([self.viewName isEqualToString:@"postOrderWrapper"]) {
            //友盟统计 单击去结算
            [MobClick event:@"iOS_jiesuan_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_jiesuan_uv"];
        }
        
        
        [self addRightBarButtonItemWithObject:self];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    if (![self.myWebView isLoading]) {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        _activityView = nil;
    }
    
    
    if ([self.viewName isEqualToString:@"prodList"]) {
        //列表页
        self.prodList = YES;
    }
    
    
    //友盟页面统计
    [MobClick beginLogPageView:self.viewName];
    
    [ManagerDefault standardManagerDefaults].isUsed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.myWebView.scrollView.delegate = nil;
    
    //友盟页面统计
    [MobClick endLogPageView:self.viewName];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.viewName isEqualToString:@"prodDetail"]) {
        self.myWebView.frame = self.view.bounds;
    }
}

#ifdef DEBUG
/*
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.prodList) {
        _contentY = scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.prodList) {
        _currentY = scrollView.contentOffset.y;
        if (_currentY > _oldY && _oldY > _contentY) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.myWebView stringByEvaluatingJavaScriptFromString:@"filterHand(\"true\")"];
            self.navBarIsHiddend = YES;
            
            if (!_IOS_7_LATER_) {
                CGRect rect = self.myWebView.frame;
                rect.size.height = SCREEN_HEIGHT - 20.0f;
                self.myWebView.frame = rect;
            }
        } else if (_currentY < _oldY && _oldY < _contentY) {
            [self.myWebView stringByEvaluatingJavaScriptFromString:@"filterHand(\"false\")"];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.navBarIsHiddend = NO;
            
            if (!_IOS_7_LATER_) {
                CGRect rect = self.myWebView.frame;
                rect.size.height = SCREEN_HEIGHT - 64.0f;
                self.myWebView.frame = rect;
            }
        }
        
        if (_currentY <= 40) {
            [self.myWebView stringByEvaluatingJavaScriptFromString:@"filterHand(\"false\")"];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.navBarIsHiddend = NO;
            
            if (!_IOS_7_LATER_) {
                CGRect rect = self.myWebView.frame;
                rect.size.height = SCREEN_HEIGHT - 64.0f;
                self.myWebView.frame = rect;
            }
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.prodList) {
        _oldY = scrollView.contentOffset.y;
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"filterHand(\"false\")"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navBarIsHiddend = NO;
    
    if (!_IOS_7_LATER_) {
        CGRect rect = self.myWebView.frame;
        rect.size.height = SCREEN_HEIGHT - 64.0f;
        self.myWebView.frame = rect;
    }
    
}
*/
#endif


#pragma mark - 加载 rightBar
- (void)addRightBarButtonItemWithObject:(DetailViewController *)detailVC
{
    if (detailVC.eventText1) {
        UIBarButtonItem *rightBar = nil;
        if ([detailVC.eventText1 hasPrefix:@"img_"]) {
            if ([detailVC.navTitle isEqualToString:@"商品详情"]) {
                rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:detailVC.eventText1] style:UIBarButtonItemStyleBordered target:detailVC action:@selector(wxShare)];
            } else {
                rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:detailVC.eventText1] style:UIBarButtonItemStyleBordered target:detailVC action:@selector(didClickRightBarButtonItem:)];
            }
            
        } else {
            //添加一个切换大、小图按钮
            rightBar = [[UIBarButtonItem alloc] initWithTitle:detailVC.eventText1 style:UIBarButtonItemStyleBordered target:detailVC action:@selector(didClickRightBarButtonItem:)];
        }
        detailVC.navigationItem.rightBarButtonItem = rightBar;
    }
}

#pragma mark - rightBar 按钮事件
- (void)didClickRightBarButtonItem:(UIBarButtonItem *)sender
{
    if (sender.title) {
        if ([sender.title isEqualToString:self.eventText1]) {
            sender.title = self.eventText2;
        } else {
            sender.title = self.eventText1;
        }
    }
    
    if ([self isShopVC]) {
        if ([[ManagerDefault standardManagerDefaults].orderNumber isEqualToString:@"0"]) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
    NSString *actionName = [[self.rightBarButtonAction componentsSeparatedByString:@"="] lastObject];
    NSString *action = [[self.rightBarButtonAction componentsSeparatedByString:@"="] firstObject];
    NSString *actionString = [NSString stringWithFormat:@"%@(\"%@\")", actionName, action];
    [self.myWebView stringByEvaluatingJavaScriptFromString:actionString];
}

#pragma mark - 分享
- (void)wxShare
{
    //将分享的内容存储在ManagerDefault
    if (self.rightBarButtonAction) {
        NSString *actionName = [[self.rightBarButtonAction componentsSeparatedByString:@"="] lastObject];
        NSString *action = [[self.rightBarButtonAction componentsSeparatedByString:@"="] firstObject];
        NSString *actionString = [NSString stringWithFormat:@"%@(\"%@\")", actionName, action];
        NSString *shareString = [self.myWebView stringByEvaluatingJavaScriptFromString:actionString];
        [[ManagerDefault standardManagerDefaults] saveShareInformationWithJSUrl:shareString];
    }

    NSArray *shareButtonTitleArray = @[@"微信",@"朋友圈",@"短信"];
    NSArray *shareButtonImageNameArray = @[@"sns_icon_1", @"sns_icon_2", @"sns_icon_3"];
    LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

//网页上的分享
- (void)shareMsg
{    
    NSArray *shareButtonTitleArray = @[@"微信",@"朋友圈",@"短信"];
    NSArray *shareButtonImageNameArray = @[@"sns_icon_1", @"sns_icon_2", @"sns_icon_3"];
    LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}


#pragma mark - 返回按钮的响应事件
- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    [self.myWebView stopLoading];
    self.myWebView.delegate = nil;
    self.bridge = nil;
    
    NSString *result = nil;
    if (![self.previousAction isEqualToString:@"false"] && self.preWebView) {
        NSString *actionString = [NSString stringWithFormat:@"%@(\"%@\")", self.previousAction, [self.previousActionPar stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        result = [[self.preWebView stringByEvaluatingJavaScriptFromString:actionString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSArray *resultArray = result ? [result componentsSeparatedByString:@"&_&"] : nil;
    if (resultArray.count > 2) {
        BOOL firBool = [[resultArray firstObject] isEqualToString:@"false"] ? NO : YES;
        BOOL thirdBool = [[resultArray lastObject] isEqualToString:@"false"] ? NO : YES;
        NSString *secondUrl = [resultArray objectAtIndex:1];
        
        if (thirdBool) {
            [self.tabBarController popAnimation];
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else if (firBool) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (secondUrl) {
            secondUrl = [NSString stringWithFormat:@"objc:commentEventParamHand$_$%@", secondUrl];
            [[ManagerDefault standardManagerDefaults] commonEventParamHandWithViewController:self urlString:secondUrl];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
    self.finishLoad = NO;
    
    
    //风火轮
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(0, 0, 50, 50);
        _activityView.center = self.view.window.center;
        _activityView.hidesWhenStopped = YES;
        [self.view addSubview:_activityView];
        [self.view bringSubviewToFront:_activityView];
    }
    [_activityView startAnimating];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
    self.finishLoad = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    _activityView = nil;
    
    if ([ManagerDefault standardManagerDefaults].jsDtailVC && [ManagerDefault standardManagerDefaults].jsActionString) {
        [[ManagerDefault standardManagerDefaults].jsDtailVC.myWebView stringByEvaluatingJavaScriptFromString:[ManagerDefault standardManagerDefaults].jsActionString];
        [ManagerDefault standardManagerDefaults].jsActionString = nil;
        [ManagerDefault standardManagerDefaults].jsDtailVC = nil;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"buttonIndex: %d", buttonIndex);
    NSString *alertCancleAction = [NSString stringWithFormat:@"%@()", self.alertCancleAction];
    NSString *alertSureAction = [NSString stringWithFormat:@"%@()", self.alertSureAction];
    
    switch (self.alertViewStatue) {
        case OnlyCancle:
            [self.myWebView stringByEvaluatingJavaScriptFromString:alertCancleAction];
            break;
        case OnlySure:
            [self.myWebView stringByEvaluatingJavaScriptFromString:alertSureAction];
            break;
        case CancleAndSure:
            if (0 == buttonIndex) {
                [self.myWebView stringByEvaluatingJavaScriptFromString:alertCancleAction];
            } else if (1 == buttonIndex) {
                [self.myWebView stringByEvaluatingJavaScriptFromString:alertSureAction];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%s", __FUNCTION__);
    NSMutableString *locationString = [NSMutableString string];
    for (int i = 0; i < locations.count; i++) {
        [locationString appendFormat:@"%@", [locations objectAtIndex:i]];
    }
    
    NSString *locationInfoStr = [NSString stringWithFormat:@"objc_getLocationInfo(\"%@\")", locationString];
    [manager stopUpdatingLocation];//停止定位
    [self.myWebView stringByEvaluatingJavaScriptFromString:locationInfoStr];
}

#pragma mark - LXActivityDelegate
- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"buttonIndex: %d", (int)imageIndex);
    
    //友盟统计分享
    [MobClick event:@"iOS_fenxiang_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_fenxiang_uv"];
    
    if (2 == (int)imageIndex) {
        //分享到短信
        [self showSMSPicker];
    } else if (1 == (int)imageIndex) {
        //分享到微信朋友圈
        [self.delegate changeScene:WXSceneTimeline];
        [self.delegate sendLinkContent];
    } else if (0 == (int)imageIndex) {
        //分享给微信好友
        [self.delegate changeScene:WXSceneSession];
        [self.delegate sendLinkContent];
    }
}
- (void)didClickOnCancelButton
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - 短信分享调用的方法
- (void)showSMSPicker
{
    NSLog(@"%s", __FUNCTION__);
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        } else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"设备不支持短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)displaySMSComposerSheet
{
    NSLog(@"%s", __FUNCTION__);
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *smsBody = [NSString stringWithFormat:@"%@ %@", [ManagerDefault standardManagerDefaults].shareTitle2, [ManagerDefault standardManagerDefaults].shareURL];
    picker.body = smsBody;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"%s", __FUNCTION__);
    switch(result) {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: SMS faild");
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)dealloc
{
    [self.myWebView stopLoading];
    self.myWebView.delegate = nil;
    [self.myWebView removeFromSuperview];
    self.myWebView = nil;
    self.bridge = nil;
}

@end
