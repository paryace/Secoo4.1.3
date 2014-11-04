//
//  AppDelegate.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "UITabBar+CustomTabBar.h"
#import "UINavigationBar+CustomNavBar.h"
#import "XGPush.h"
#import "ActiveView.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "ZBarReaderView.h"
#import "MySecooTableViewController.h"
#import "CartViewController.h"
#import "CartItemAccessor.h"

#define _IPHONE80_ 80000

//微信
#define WX_API_KEY @"wx4a12d8c38121019e"
//信鸽推送
#define XGPUSH_ACCESS_ID 2200036108
#define XGPUSH_ACCESS_KEY @"IQSL75697SEB"


//活动页图片地址
#define ACTIVE_ADDRESS_XIAO @"http://iphone.secoo.com/getImageUrl.action?key=iphone_xiao"
#define ACTIVE_ADDRESS_ZHONG @"http://iphone.secoo.com/getImageUrl.action?key=iphone_zhong"
#define ACTIVE_ADDRESS_DA @"http://iphone.secoo.com/getImageUrl.action?key=iphone_da"


@interface AppDelegate ()

- (UITabBarController *)_loadViewControllers;

//应用收到推送通知弹出的alert
@property(nonatomic, strong) UIAlertView *scriptAlertView;
//存储推送通知的value
@property(nonatomic, copy) NSString *alertActionScript;

@property (nonatomic) Reachability *internetReachability;

@property (nonatomic, weak) UINavigationController *navigationVC0;
@property (nonatomic, weak) UINavigationController *navigationVC1;
@property (nonatomic, weak) UINavigationController *navigationVC2;
@property (nonatomic, weak) UINavigationController *navigationVC3;
@property (nonatomic, weak) UINavigationController *navigationVC4;
@end

@implementation AppDelegate

//设置navigationBar和tabBar的外观 LLGGTT
- (void)_customNavBarAndTabBarAppearance
{
    if (!_IOS_7_LATER_) {
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, [UIColor clearColor], UITextAttributeTextShadowColor, [UIFont fontWithName:@"Helvetica" size:18], UITextAttributeFont, nil]];
        
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0)
                                                             forBarMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{ UITextAttributeFont:[UIFont systemFontOfSize:17],UITextAttributeTextColor:MAIN_YELLOW_COLOR,UITextAttributeTextShadowColor:[UIColor clearColor]} forState:UIControlStateNormal];
        
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage new]];
    }

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MAIN_YELLOW_COLOR, UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
}

- (UITabBarController *)_loadViewControllers
{
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self _customNavBarAndTabBarAppearance];//设置navigationBar和tabBar的外观

    RootViewController *indexVC = [[RootViewController alloc] initWithItemIndex:0];
    UINavigationController *indexNav = [[UINavigationController alloc] initWithRootViewController:indexVC];
    indexVC.navigationItem.title = @"首页";
    _navigationVC0 = indexNav;
    
    BrandViewController *brandVC = [stroyboard instantiateViewControllerWithIdentifier:@"BrandViewController"];
    UINavigationController *brandNav = [[UINavigationController alloc] initWithRootViewController:brandVC];
    [brandNav.navigationBar customNavBar];
    brandVC.navigationItem.title = @"品牌馆";
    _navigationVC1 = brandNav;

    CategoryTableViewController *listVC = [stroyboard instantiateViewControllerWithIdentifier:@"CategoryTableViewController"];
    UINavigationController *listNav = [[UINavigationController alloc] initWithRootViewController:listVC];
    [listNav.navigationBar customNavBar];
    listVC.navigationItem.title = @"分类";
    _navigationVC2 = listNav;
    
    CartViewController *shopVC = [stroyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    UINavigationController *shopNav = [[UINavigationController alloc] initWithRootViewController:shopVC];
    [shopNav.navigationBar customNavBar];
    shopVC.navigationItem.title = @"购物袋";
    _navigationVC3 = shopNav;
    
    MySecooTableViewController *userVC = [stroyboard instantiateViewControllerWithIdentifier:@"MySecooTableViewController"];
    UINavigationController *userNav = [[UINavigationController alloc] initWithRootViewController:userVC];
    [userNav.navigationBar customNavBar];
    userVC.navigationItem.title = @"我的寺库";
    _navigationVC4 = userNav;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[indexNav, brandNav, listNav, shopNav, userNav] animated:YES];
    _tabViewController = tabBarController;
    
    //订单数
    NSUInteger index = 0;
    if (_IOS_7_LATER_) {index = 3;} else {index = 5;}
    
    UIView *tabBarView = [[[tabBarController tabBar] subviews] objectAtIndex:index];
    CGRect rect = tabBarView.frame;
    rect.size.height = 42;
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:rect];
    orderLabel.backgroundColor = [UIColor clearColor];
    orderLabel.textColor = MAIN_YELLOW_COLOR;
    orderLabel.font = [UIFont systemFontOfSize:10.0f];
    orderLabel.textAlignment = NSTextAlignmentCenter;
    orderLabel.tag = ORDER_LABEL_TAG;
    [tabBarController.tabBar addSubview:orderLabel];
    [ManagerDefault standardManagerDefaults].orderLabel = orderLabel;
    
    //我的寺库提示信息
    UIView *msgView = [[[tabBarController tabBar] subviews] objectAtIndex:index + 1];
    CGRect msgRect = msgView.frame;
    msgRect.size.height = 8;
    msgRect.size.width = 8;
    msgRect.origin.x += 35;
    msgRect.origin.y += 3;
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:msgRect];
    msgLabel.layer.cornerRadius = 4;
    if (_IOS_7_LATER_) {
        msgLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
    } else {
        msgLabel.backgroundColor = [UIColor clearColor];
    }
    [tabBarController.tabBar addSubview:msgLabel];
    [tabBarController.tabBar bringSubviewToFront:msgLabel];
    [ManagerDefault standardManagerDefaults].msgLabel = msgLabel;
    
    //设置图片
    {
        if (_IOS_7_LATER_) {
            UIImage *selectedImage0 = [UIImage imageNamed:@"index1"];
            selectedImage0 = [selectedImage0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *unselectedImage0 = [UIImage imageNamed:@"index2"];
            
            UIImage *selectedImage1 = [UIImage imageNamed:@"brand1"];
            selectedImage1 = [selectedImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *unselectedImage1 = [UIImage imageNamed:@"brand2"];
            
            UIImage *selectedImage2 = [UIImage imageNamed:@"list1"];
            selectedImage2 = [selectedImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *unselectedImage2 = [UIImage imageNamed:@"list2"];
            
            UIImage *selectedImage3 = [UIImage imageNamed:@"shop1"];
            selectedImage3 = [selectedImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *unselectedImage3 = [UIImage imageNamed:@"shop2"];
            
            UIImage *selectedImage4 = [UIImage imageNamed:@"user1"];
            selectedImage4 = [selectedImage4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *unselectedImage4 = [UIImage imageNamed:@"user2"];
            
            UITabBarItem *tabBarItem0 = [[UITabBarItem alloc] initWithTitle:@"首页" image:unselectedImage0 selectedImage:selectedImage0];
            UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"品牌" image:unselectedImage1 selectedImage:selectedImage1];
            UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"分类" image:unselectedImage2 selectedImage:selectedImage2];
            UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"购物袋" image:unselectedImage3 selectedImage:selectedImage3];
            UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"我的寺库" image:unselectedImage4 selectedImage:selectedImage4];
            
            indexNav.tabBarItem = tabBarItem0;
            brandNav.tabBarItem = tabBarItem1;
            listNav.tabBarItem  = tabBarItem2;
            shopNav.tabBarItem  = tabBarItem3;
            userNav.tabBarItem  = tabBarItem4;
        }
        else{
            UITabBarItem *tabBarItem0 = [[UITabBarItem alloc] init];
            UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] init];
            UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] init];
            UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] init];
            UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] init];
            
            indexNav.tabBarItem = tabBarItem0;
            brandNav.tabBarItem = tabBarItem1;
            listNav.tabBarItem  = tabBarItem2;
            shopNav.tabBarItem  = tabBarItem3;
            userNav.tabBarItem  = tabBarItem4;
            
            tabBarItem0.title = @"首页";
            tabBarItem1.title = @"品牌";
            tabBarItem2.title = @"分类";
            tabBarItem3.title = @"购物袋";
            tabBarItem4.title = @"我的寺库";
            [tabBarItem0 setFinishedSelectedImage:[UIImage imageNamed:@"index1"] withFinishedUnselectedImage:[UIImage imageNamed:@"index2"]];
            [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"brand1"] withFinishedUnselectedImage:[UIImage imageNamed:@"brand2"]];
            [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"list1"] withFinishedUnselectedImage:[UIImage imageNamed:@"list2"]];
            [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"shop1"] withFinishedUnselectedImage:[UIImage imageNamed:@"shop2"]];
            [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"user1"] withFinishedUnselectedImage:[UIImage imageNamed:@"user2"]];
        }
        [tabBarController.tabBar customTabBar];
    }
    return tabBarController;
}

- (UINavigationController *)getNavigationVC:(NSInteger)index
{
    //NSLog(@"trying to get navigationviewcontroller from index: %d", index);
    switch (index) {
        case 0:
            return _navigationVC0;
            break;
        case 1:
            return _navigationVC1;
            break;
        case 2:
            return _navigationVC2;
            break;
        case 3:
            return _navigationVC3;
            break;
        case 4:
            return _navigationVC4;
            break;
            
        default:
            return _navigationVC0;
            break;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Utils updateUpkey];
    
    if (_IOS_8_LATER_) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    //向微信注册
    [WXApi registerApp:WX_API_KEY];
    
    //信鸽推送注册
    [XGPush startApp:XGPUSH_ACCESS_ID appKey:XGPUSH_ACCESS_KEY];
    [XGPush handleLaunching:launchOptions];
    
    
    //友盟统计
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:REALTIME channelId:_CHANNEL_ID_];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version %@", version);
    [MobClick setAppVersion:version];
    [MobClick checkUpdate];
    
    if (launchOptions) {
        NSDictionary *launchOptionsRemoteNotificationDic = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (launchOptionsRemoteNotificationDic) {
            NSString *myScriptStr = [launchOptionsRemoteNotificationDic valueForKey:@"myScript"];
            if (myScriptStr) {
                [[NSUserDefaults standardUserDefaults] setObject:myScriptStr forKey:@"myLaunchScript"];
            }
        }
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self _loadViewControllers];
    [self _addActiveInfo];
    [self _saveActiveInfo];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //开启网络状况监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    //二维码
    [ZBarReaderView class];
    //设置订单数
    NSInteger num = [[CartItemAccessor sharedInstance] numberOfCartItems];
    if (num >= 0) {
        [ManagerDefault standardManagerDefaults].orderNumber = [NSString stringWithFormat:@"%d",num];
    }
    
    self.cartVersion = -1;
    [Utils setCartVersion];
    return YES;
}


- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability *reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    [self checkNetWorkWithReachability:reachability];
}

- (void)checkNetWorkWithReachability:(Reachability *)reachability
{
    [ManagerDefault standardManagerDefaults].netWorkStatus = [reachability currentReachabilityStatus];
    UIWebView *currentWebView = [ManagerDefault standardManagerDefaults].currentWebView;
    NSString *actionStr = [NSString stringWithFormat:@"networkStatusChangeCallback(\"%d\")", [reachability currentReachabilityStatus]];
    if (currentWebView) {
        [currentWebView stringByEvaluatingJavaScriptFromString:actionStr];
    }
}

#pragma mark - 保存活动页信息
- (void)_saveActiveInfo
{
    NSString *activeImageString = nil;
    CGSize size_screen = [[UIScreen mainScreen] bounds].size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSLog(@"分辨率 %f,%f", size_screen.width*scale_screen ,size_screen.height*scale_screen);
    if (size_screen.width*scale_screen == 320.0) {
        activeImageString = ACTIVE_ADDRESS_XIAO;
    } else if(size_screen.width*scale_screen == 640.0) {
        if (size_screen.height*scale_screen == 960.0) {
            activeImageString = ACTIVE_ADDRESS_ZHONG;
        } else {
            activeImageString = ACTIVE_ADDRESS_DA;
        }
    }
    [[ManagerDefault standardManagerDefaults] imageWithURL:activeImageString callBack:^(UIImage *image, NSString *startTime, NSString *endTime) {
        NSLog(@"图片加载完成");
    }];
}

#pragma mark - 加载活动页
- (void)_addActiveInfo
{
    NSString *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:ACTIVE_START_TIME];
    NSString *endTime = [[NSUserDefaults standardUserDefaults] objectForKey:ACTIVE_END_TIME];
    NSString *imageURL = [[NSUserDefaults standardUserDefaults] objectForKey:ACTIVE_IMAGE_PATH];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *start = [formatter dateFromString:startTime];
    NSDate *end = [formatter dateFromString:endTime];
    NSDate *current = [NSDate date];
    if ([current compare:end] == NSOrderedAscending && [current compare:start] == NSOrderedDescending) {
        //添加展示页
        ActiveView *activeView = [[ActiveView alloc] initWithFrame:self.window.bounds];
        
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [document stringByAppendingPathComponent:[imageURL lastPathComponent]];
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *activeImage = [UIImage imageWithData:imageData];
        [activeView.imageView setImage:activeImage];
        [self.window.rootViewController.view addSubview:activeView];
        [self.window.rootViewController.view bringSubviewToFront:activeView];
        
        [self performSelector:@selector(dismissActiveView:) withObject:activeView afterDelay:4.0f];
    }
}

- (void)dismissActiveView:(UIView *)activeView
{
    [UIView animateWithDuration:3.0f animations:^{
        activeView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [activeView removeFromSuperview];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissActiveView:) object:activeView];
        }
    }];
}

#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"myLaunchScript"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if (![ManagerDefault standardManagerDefaults].isUsed) {
        [MobClick event:@"iOS_tiaochu"];//用户没有进行任何操作就关闭程序
    }
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self parse:url application:application];//支付宝客户端回调方法
    return [WXApi handleOpenURL:url delegate:self];
}

//成功获取用户deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%s", __FUNCTION__);
    //向信鸽注册设备
    NSString *deviceStr = [XGPush registerDevice:deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:deviceStr forKey:@"deviceToken"];
    NSLog(@"deviceToken %@", deviceStr);
}
//获取deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"获取deviceToken失败Error: %@", error);
}

//收到推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s", __FUNCTION__);
    [XGPush handleReceiveNotification:userInfo];
    
    NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    NSString *myScript = [userInfo objectForKey:@"myScript"];
    NSLog(@"myScript = %@", myScript);
    //当应用处于使用中收到推送数据
    if (application.applicationState == UIApplicationStateActive) {
        if (myScript) {
            self.alertActionScript = myScript;
        } else {
            self.alertActionScript = @"";
        }
        self.scriptAlertView = [[UIAlertView alloc] initWithTitle:@"寺库提示" message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"查看详情", nil];
        application.applicationIconBadgeNumber = 0;
        [self.scriptAlertView show];
    } else if (application.applicationState == UIApplicationStateInactive) {
        UIWebView *currentWebView = [ManagerDefault standardManagerDefaults].currentWebView;
        if (currentWebView && myScript) {
            [currentWebView stringByEvaluatingJavaScriptFromString:myScript];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    UIWebView *currentWebView = [ManagerDefault standardManagerDefaults].currentWebView;
    if (currentWebView) {
        [currentWebView stringByEvaluatingJavaScriptFromString:@"objc_appDidActive()"];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.scriptAlertView) {
        if (1 == buttonIndex) {
            UIWebView *currentWebView = [ManagerDefault standardManagerDefaults].currentWebView;
            if (currentWebView) {
                [currentWebView stringByEvaluatingJavaScriptFromString:self.alertActionScript];
            }
        }
    }
}


#pragma mark - 微信回调方法

//WXErrCodeCommon     = -1,
//WXErrCodeUserCancel = -2,
//WXErrCodeSentFail   = -3,
//WXErrCodeAuthDeny   = -4,
//WXErrCodeUnsupport  = -5,
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess: {
                [MobClick event:@"iOS_zhifuchenggong_pv"];//友盟统计支付成功
                [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifuchenggong_uv"];
                
                //友盟统计
                [MobClick event:@"iOS_weixin_success_pv"];
                [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_weixin_success_uv"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dateNow = [NSDate date];
                NSString *dateNowString = [formatter stringFromDate:dateNow];
                if ([dateNowString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"registerSuccess"]]) {
                    //当天注册成功当天就成交订单
                    [MobClick event:@"iOS_newChengjiao"];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kWXpaySuccess object:nil userInfo:nil];
            }
                break;
            case WXErrCodeUserCancel:
                
                //友盟统计
                [MobClick event:@"iOS_weixin_cancle_pv"];
                [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_weixin_cancle_uv"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kWXpayUserCancelled object:nil userInfo:nil];
                break;
            default:
                
                //友盟统计
                [MobClick event:@"iOS_weixin_failed_pv"];
                [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_weixin_failed_uv"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kWXpayFailed object:nil userInfo:nil];
                break;
        }
    } else if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        UIWebView *currentWebView = [[ManagerDefault standardManagerDefaults] currentWebView];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"分享成功";
                if (currentWebView) {
                    [currentWebView stringByEvaluatingJavaScriptFromString:@"shareResult('success')"];
                }
                break;
            case WXErrCodeSentFail:
                strMsg = @"分享失败";
                if (currentWebView) {
                    [currentWebView stringByEvaluatingJavaScriptFromString:@"shareResult('failed')"];
                }
                break;
            case WXErrCodeUserCancel:
                strMsg = @"取消分享";
                if (currentWebView) {
                    [currentWebView stringByEvaluatingJavaScriptFromString:@"shareResult('cancle')"];
                }
                break;
            default:
                break;
        }
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)changeScene:(NSInteger)scene
{
    _scene = scene;
}
- (void)sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    if (_scene == WXSceneTimeline) {
        message.title = [ManagerDefault standardManagerDefaults].shareTitle2;
    } else {
        message.title = [ManagerDefault standardManagerDefaults].shareTitle;
    }
    
    message.description = [ManagerDefault standardManagerDefaults].shareDescription;
    [message setThumbData:[ManagerDefault standardManagerDefaults].shareImageData];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [ManagerDefault standardManagerDefaults].shareURL;
    message.mediaObject = ext;
    
    if (!message.thumbData) {
        [message setThumbImage:[UIImage imageNamed:@"Icon"]];
    }
    if (!ext.webpageUrl) {
        ext.webpageUrl = @"m.secoo.com";
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
}

#pragma mark - 支付宝回调
- (void)parse:(NSURL *)url application:(UIApplication *)application
{
    NSLog(@"%s", __FUNCTION__);
    //结果处理
    AlixPayResult *result = [self handleOpenURL:url];
    [Utils handleAlipayResult:result];
}

- (AlixPayResult *)resultFromURL:(NSURL *)url
{
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	return [[AlixPayResult alloc] initWithString:query];
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url
{
	AlixPayResult *result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}


#pragma mark -
- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "lu-tan.LGTableView" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Secoo-iPhone" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LGTableView.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //TODO:delete
        //abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
