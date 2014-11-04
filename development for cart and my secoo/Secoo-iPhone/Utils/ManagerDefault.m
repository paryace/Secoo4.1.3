//
//  ManagerDefault.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ManagerDefault.h"

#import "BasicViewController.h"
#import "DetailViewController.h"
#import "WXApi.h"
#import "JSONKit.h"
#import "ExtendViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "NSString+Encoding.h"
#import "PayOnLineModel.h"
#import "UITabBarController+SelectAnimating.h"
#import "RootViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "MobClick.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "UserInfoManager.h"
#import "CategoryDetailTableViewController.h"
//#import "CartWapViewController.h"
#import "ProductInfoViewController.h"
#import "LoginTableViewController.h"
#import "DetailedOrderInfoViewController.h"
#import "MBProgressHUD+Add.h"

static NSString *locationSignString = @"message:";

@interface ManagerDefault ()
{
    CLLocationManager *_locationManager;
}
@end

@implementation ManagerDefault
+ (ManagerDefault *)standardManagerDefaults
{
    static ManagerDefault *managerDefault = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerDefault = [[ManagerDefault alloc] init];
    });
    return managerDefault;
}

- (id)init
{
    self = [super init];
    if (self) {
        //添加观察者
        [self addObserver:self forKeyPath:@"orderNumber" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"change %@", change);
    [[NSNotificationCenter defaultCenter] postNotificationName:ORDER_NUMBER_NOTIFACATION object:nil];
    if ([self.orderNumber isEqualToString:@"0"]) {
        [[ManagerDefault standardManagerDefaults].orderLabel setText:nil];
        [[[ManagerDefault standardManagerDefaults].shopVC navigationItem] setRightBarButtonItem:nil animated:YES];
    } else {
        [[ManagerDefault standardManagerDefaults].orderLabel setText:self.orderNumber];
    }
}


//存储分享的信息
- (void)saveShareInformationWithJSUrl:(NSString *)receiveString
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *shareArray = [receiveString componentsSeparatedByString:@"$_$"];
        if (shareArray.count >= 5) {
            self.shareTitle = shareArray[0];//微信标题
            self.shareTitle2 = shareArray[1];//朋友圈和短信的标题
            self.shareDescription = shareArray[2];
            self.shareURL = shareArray[3];
            self.shareImageURL = shareArray[4];
            
            NSString *imageString = shareArray[4];
            if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathForURL:imageString]]) {
                self.shareImageData = [NSData dataWithContentsOfFile:[self pathForURL:imageString]];
            } else {
                NSURL *url = [NSURL URLWithString:imageString];
                self.shareImageData = [NSData dataWithContentsOfURL:url];
                [self.shareImageData writeToFile:[self pathForURL:imageString] atomically:YES];
            }
        }
    });
}

#pragma mark - 私有方法
- (NSString *)md5URL:(NSString *)url
{
    const char *cStr = [url UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (NSString *)pathForURL:(NSString *)url
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [document stringByAppendingFormat:@"/%@.png", [self md5URL:url]];
    return path;
}


#pragma mark - 从服务端请求活动页图片
- (void)imageWithURL:(NSString *)urlString callBack:(CallBack)callBack
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSString *imageURL = nil;
        NSData *imageData = nil;
        NSString *new_start_time = nil;
        NSString *new_end_time = nil;
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                NSDictionary *resultDic = [dictionary objectForKey:@"rp_result"];
                
                imageURL = [resultDic objectForKey:@"new_imageUrl"];
                new_start_time = [resultDic objectForKey:@"new_start_time"];
                new_end_time = [resultDic objectForKey:@"new_end_time"];
                
                NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *imagePath = [document stringByAppendingPathComponent:[imageURL lastPathComponent]];
                NSLog(@"imagePath %@", imagePath);
                
                NSURL *url = [NSURL URLWithString:imageURL];
                imageData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:&error];
                
                if (imageData) {
                    [imageData writeToFile:imagePath atomically:YES];
                    [[NSUserDefaults standardUserDefaults] setObject:new_start_time forKey:ACTIVE_START_TIME];
                    [[NSUserDefaults standardUserDefaults] setObject:new_end_time forKey:ACTIVE_END_TIME];
                    [[NSUserDefaults standardUserDefaults] setObject:imageURL forKey:ACTIVE_IMAGE_PATH];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callBack([UIImage imageWithData:imageData],new_start_time,new_end_time);
                    });
                }
                
            }
        }        
    });
}


#pragma mark - 接收 JS 消息后的回调方法
- (void)responseForMessageOfString:(NSString *)urlString viewController:(BasicViewController *)viewController
{
    NSDictionary *jsonDic = [[[urlString URLDecodedUTF8Str] substringFromIndex:[locationSignString length]] objectFromJSONString];
    
    //银联支付
    if (jsonDic) {
        //友盟统计支付
        [MobClick event:@"iOS_zhifu_pv"];
        [self UMengAnalyticsUVWithEvent:@"iOS_zhifu_uv"];
        
        [[[PayOnLineModel alloc] init] startNavivePayType:@"UnionPay" withData:jsonDic];
    }
    
    //获取标签栏的URL
    else if ([urlString hasPrefix:@"objc:toolbarUrlHand"]) {
        NSArray *tabBarURLs = [urlString componentsSeparatedByString:@"&_&"];
        if (tabBarURLs.count > 5) {
            [ManagerDefault standardManagerDefaults].brandURLString = tabBarURLs[2];
            [ManagerDefault standardManagerDefaults].listURLString = tabBarURLs[3];
            [ManagerDefault standardManagerDefaults].shopURLString = tabBarURLs[4];
            [ManagerDefault standardManagerDefaults].userURLString = tabBarURLs[5];
            //存储登陆状态
            NSArray *cartWrapperArr = [[ManagerDefault standardManagerDefaults].userURLString componentsSeparatedByString:@"$_$"];
            if (cartWrapperArr.count > 3) {
                if (![[cartWrapperArr objectAtIndex:3] isEqualToString:@"hasEvent=false"]) {
                    [ManagerDefault standardManagerDefaults].userLogin = YES;
                } else {
                    [ManagerDefault standardManagerDefaults].userLogin = NO;
                }
            }
        }
    }
     
    //登录状态
    else if ([urlString hasPrefix:@"objc:userStatusHand"]) {
        NSArray *array = [urlString componentsSeparatedByString:@"$_$"];
        if (array.count > 1) {
            NSString *userState = [array objectAtIndex:1];
            if ([userState isEqualToString:@"true"]) {
                [ManagerDefault standardManagerDefaults].userLogin = YES;
                [UserInfoManager setLogState:YES];
            } else {
                [ManagerDefault standardManagerDefaults].userLogin = NO;
                [UserInfoManager setLogState:NO];
            }
        }
    }
    
    //订单数值
    else if ([urlString hasPrefix:@"objc:orderNumHand"]) {
//        [ManagerDefault standardManagerDefaults].orderNumber = [[urlString componentsSeparatedByString:@"$_$"] lastObject];
//        
//        if (viewController.isShopVC && [[ManagerDefault standardManagerDefaults].orderNumber isEqualToString:@"0"]) {
//            viewController.navigationItem.rightBarButtonItem = nil;
//        }
    }
    
    //我的寺库提示信息
    else if ([urlString hasPrefix:@"objc:hasMessageTips"]) {
        NSString *result = [[urlString componentsSeparatedByString:@"&_&"] lastObject];
        if ([result isEqualToString:@"true"]) {
            if (_IOS_7_LATER_) {
                self.msgLabel.layer.backgroundColor = MAIN_YELLOW_COLOR.CGColor;
            } else {
                self.msgLabel.backgroundColor = MAIN_YELLOW_COLOR;
            }
        } else {
            self.msgLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
            self.msgLabel.backgroundColor = [UIColor clearColor];
        }
    }
    
    //信鸽推送
   else if ([urlString hasPrefix:@"objc:XgToken"]) {
        NSString *xgTokenInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        xgTokenInfo = [NSString stringWithFormat:@"objc_getXgTokenInfo(\"%@\")", xgTokenInfo];
        [viewController.myWebView stringByEvaluatingJavaScriptFromString:xgTokenInfo];
    }
    
    //获取推送的脚本信息
    else if ([urlString hasPrefix:@"objc:getLaunchScript"]) {
        NSString *launchScript = [[NSUserDefaults standardUserDefaults] objectForKey:@"myLaunchScript"];
        launchScript = launchScript ? launchScript : @"0";
        launchScript = [NSString stringWithFormat:@"objc_getLaunchScript(\"%@\")", launchScript];
        [viewController.myWebView stringByEvaluatingJavaScriptFromString:launchScript];
    }
    
    //清除推送的脚本信息
    else if ([urlString hasPrefix:@"objc:clearLaunchScript"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"myLaunchScript"];
    }
    
    //获取设备信息
    else if ([urlString hasPrefix:@"objc:getDeviceInfo"]) {
        NSString *deviceInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceInfo"];
        deviceInfo = [NSString stringWithFormat:@"objc_getDeviceInfo('%@')", deviceInfo];
        [viewController.myWebView stringByEvaluatingJavaScriptFromString:deviceInfo];
    }
    
    //定位
    else if ([urlString hasPrefix:@"objc:getLocationInfo"]) {
        _locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled]) {
            _locationManager.delegate = viewController;
            _locationManager.distanceFilter = 200;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [_locationManager startUpdatingLocation];
        } else {
            NSLog(@"设备不支持定位");
        }
    }
    
    //微信支付
    else if ([urlString hasPrefix:@"objc:weixinPay"]) {
        //友盟统计支付
        [MobClick event:@"iOS_zhifu_pv"];
        [self UMengAnalyticsUVWithEvent:@"iOS_zhifu_uv"];
        
        NSArray *urlArray = [urlString componentsSeparatedByString:@"$_$"];
        NSString *payString = [[urlArray objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *payData = [payString objectFromJSONString];
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = [payData valueForKey:@"partnerId"];
        request.prepayId= [payData valueForKey:@"prepayId"];
        request.package = [payData valueForKey:@"package"];
        request.nonceStr= [payData valueForKey:@"nonceStr"];
        request.timeStamp= [[payData valueForKey:@"timeStamp"] intValue];
        request.sign= [payData valueForKey:@"sign"];
        [WXApi safeSendReq:request];
    }
    
    //支付宝支付
    else if ([urlString hasPrefix:@"objc:alixPay"]) {
        
        //友盟统计支付
        [MobClick event:@"iOS_zhifu_pv"];
        [self UMengAnalyticsUVWithEvent:@"iOS_zhifu_uv"];
        
        NSArray *result = [[[urlString componentsSeparatedByString:@"&_&"] lastObject] componentsSeparatedByString:@"$_$"];
        if (result.count > 1) {
            NSString *orderID = [result firstObject];
            NSString *upkStr = [result lastObject];
            [self payOrderInfoWithTradNumber:orderID upkStr:upkStr];
        }
    }
    
    //打开新页面
    else if ([urlString hasPrefix:@"objc:openNewPage"]) {
        NSArray *urlArray = [urlString componentsSeparatedByString:@"$_$"];
        NSString *str = urlArray.count > 1 ? [urlArray objectAtIndex:1] : nil;
        if (str) {
            ExtendViewController *extendVC = [[ExtendViewController alloc] init];
            extendVC.webURLString = str;
            [viewController presentViewController:extendVC animated:YES completion:nil];
        }
    }
    
    //点击返回按钮时上级页面需要调用的方法和参数
    else if ([urlString hasPrefix:@"objc:nativeCallBackHand"]) {
        NSArray *urlArray = [urlString componentsSeparatedByString:@"$_$"];
        if (urlArray.count > 2) {
            viewController.previousAction = urlArray[1];
            viewController.previousActionPar = urlArray[2];
        }
    }
    
    //弹出提示框
    else if ([urlString hasPrefix:@"objc:dialogBoxHand"]) {
        NSArray *alertArray = [urlString componentsSeparatedByString:@"$_$"];
        
        if (alertArray.count > 4) {
            NSString *alertTitle = [[alertArray objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *alertStatue = [alertArray objectAtIndex:2];
            NSString *alertCancleAction = [alertArray objectAtIndex:3];
            NSString *alertSureAction = [alertArray objectAtIndex:4];
            
            viewController.alertCancleAction = alertCancleAction;
            viewController.alertSureAction = alertSureAction;
            
            if ([alertStatue isEqualToString:@"3"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertTitle delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [alert show];
                [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:1.5f];
            } else if ([alertStatue isEqualToString:@"2"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:viewController cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                viewController.alertViewStatue = CancleAndSure;
                [alert show];
            } else if ([alertStatue isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:viewController cancelButtonTitle:@"确定" otherButtonTitles:nil];
                viewController.alertViewStatue = OnlySure;
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                viewController.alertViewStatue = OnlyCancle;
                [alert show];
            }
        }
    }
    
    //单击图片放大
    else if ([urlString hasPrefix:@"objc:pic"]) {
        NSString *imageUrlString = [[urlString componentsSeparatedByString:@"&_&"] lastObject];
        NSArray *imageUrlArray = [imageUrlString componentsSeparatedByString:@"$_$"];
        
        NSUInteger currentIndex = (NSUInteger)[[imageUrlArray firstObject] integerValue];
        NSMutableArray *imageURLs = [NSMutableArray arrayWithArray:imageUrlArray];
        [imageURLs removeObjectAtIndex:0];
        
        [self showImageViewWithViewController:viewController andImageUrls:imageURLs currentIndex:currentIndex];
    }
    
    //普通事件
    else if ([urlString hasPrefix:@"objc:commonEventParamHand"]) {
        if ([viewController openNewPage] == NO) {
            [self commonEventParamHandWithViewController:viewController urlString:urlString];
            viewController.openNewPage = YES;
        }
    }
    
    //购物车的回调方法
    else if ([urlString hasPrefix:@"objc:cartAction"]) {
        NSArray *result = [urlString componentsSeparatedByString:@"&_&"];
        if (result.count > 2) {
            NSString *par = [result lastObject];
            NSString *action = [result objectAtIndex:1];
            
            NSString *actionString = nil;
            if ([par isEqualToString:@"false"]) {
                actionString = [NSString stringWithFormat:@"%@()", action];
            } else {
                actionString = [NSString stringWithFormat:@"%@(\"%@\")", action, par];
            }
            
            self.carWrapperCallBackStr = actionString;
        }
    }
    
    //返回
    else if ([urlString hasPrefix:@"objc:navtiveBackHand"]) {
        NSArray *urlArray = [urlString componentsSeparatedByString:@"$_$"];
        if (urlArray.count > 5) {
            NSString *backUrl = urlArray[2];
            NSInteger backIndex = [[urlArray objectAtIndex:1] integerValue];
            NSString *needRefreshStr = [urlArray objectAtIndex:3];
            BOOL needRefresh = [needRefreshStr isEqualToString:@"false"] ? NO : YES;
            
            NSString *callBackName = urlArray[4];
            NSString *callBackPar = [urlArray[5] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *viewControllers = [viewController.navigationController viewControllers];
            BasicViewController *backToVC = [viewControllers objectAtIndex:viewControllers.count -backIndex - 1];
            
            [self afterBackMethodWithViewController:backToVC url:backUrl needRefresh:needRefresh callBackName:callBackName callBackPar:callBackPar andURLArray:urlArray];
            
            [viewController.navigationController popToViewController:backToVC animated:YES];
        }
    }
    
    //分享
    else if ([urlString hasPrefix:@"objc:shareMsg"]) {
        NSString *receiveString = [[urlString componentsSeparatedByString:@"&_&"] lastObject];
        [self saveShareInformationWithJSUrl:receiveString];
        DetailViewController *detailVC = (DetailViewController *)viewController;
        if ([detailVC respondsToSelector:@selector(shareMsg)]) {
            [detailVC shareMsg];
        }
    }
    
    //友盟统计
    else if ([urlString hasPrefix:@"objc:countClick"]) {
        NSString *result = [[urlString componentsSeparatedByString:@"&_&"] lastObject];
        if ([result isEqualToString:@"collect"]) {
            //点击收藏
            [MobClick event:@"iOS_shoucang_pv"];
            [self UMengAnalyticsUVWithEvent:@"iOS_shoucang_uv"];
        } else if ([result isEqualToString:@"pay"]) {
        } else if ([result isEqualToString:@"register"]) {
            //注册成功
            [MobClick event:@"iOS_newZhuce"];
            
            //存储注册成功的时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateNow = [NSDate date];
            NSString *dateNowString = [formatter stringFromDate:dateNow];
            [[NSUserDefaults standardUserDefaults] setObject:dateNowString forKey:@"registerSuccess"];
        }
        
    }
    
    //传给js网络状态
    else if ([urlString hasPrefix:@"objc:getNetworkStatus"]) {
        NSString *result = [[urlString componentsSeparatedByString:@"&_&"] lastObject];
        NSString *actionStr = [NSString stringWithFormat:@"%@(\"%d\")", result, [[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus]];
        [viewController.myWebView stringByEvaluatingJavaScriptFromString:actionStr];
    }
    
    //LLGG 网页跳转Native页面
    else if ([urlString hasPrefix:@"objc:callIosPage"]){
        NSArray *resultArray = [urlString componentsSeparatedByString:@"$_$"];
        if ([resultArray count] == 4) {
            NSInteger fromControllerIndex = [[resultArray objectAtIndex:1] integerValue];
            NSString *destinationVC = [resultArray objectAtIndex:2];
            NSError *jsonError;
            id jsonDictionary = [NSJSONSerialization JSONObjectWithData:[[resultArray objectAtIndex:3] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                UIViewController *destiVC;
                if ([destinationVC isEqualToString:@"listPage"]) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    CategoryDetailTableViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailTableViewController"];
                    detailVC.hidesBottomBarWhenPushed = YES;
                    detailVC.title = [jsonDictionary objectForKey:@"title"];
                    destiVC = detailVC;
                    
                    if ([[jsonDictionary objectForKey:@"type"] isEqualToString:@"category"]) {
                        detailVC.categoryId = [jsonDictionary objectForKey:@"categoryId"];
                        detailVC.listType = ListCategoryType;
                    }
                    else if ([[jsonDictionary objectForKey:@"type"] isEqualToString:@"brand"]){
                        detailVC.brandId = [jsonDictionary objectForKey:@"brandId"];
                        detailVC.listType = ListBrandType;
                    }
                    else if ([[jsonDictionary objectForKey:@"type"] isEqualToString:@"searchKey"]){
                        detailVC.keyWord = [jsonDictionary objectForKey:@"keyWord"];
                        detailVC.listType = ListSearchType;
                    }
                    else if ([[jsonDictionary objectForKey:@"type"] isEqualToString:@"wareHouse"]){
                        detailVC.wareHouseId = [jsonDictionary objectForKey:@"wareHouseId"];
                        detailVC.listType = ListWarehouseType;
                    }
                }
                else{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    if ([destinationVC isEqualToString:@"productInfo"]) {
                        //jump to production infomaiton view controller
                        ProductInfoViewController *productVC = [storyboard instantiateViewControllerWithIdentifier:@"ProductInfoViewController"];
                        destiVC = productVC;
                        productVC.productID = [jsonDictionary objectForKey:@"productId"];
                        productVC.title = [jsonDictionary objectForKey:@"title"];
                        productVC.hidesBottomBarWhenPushed = YES;
                    } else if ([destinationVC isEqualToString:@"DetailedOrderInfoViewController"]) {
                        //订单详情页
                        DetailedOrderInfoViewController *detailOrderInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"DetailedOrderInfoViewController"];
                        detailOrderInfoVC.orderId = [jsonDictionary objectForKey:@"orderId"];
                        detailOrderInfoVC.title = [jsonDictionary objectForKey:@"title"];
                        detailOrderInfoVC.hidesBottomBarWhenPushed = YES;
                        destiVC = detailOrderInfoVC;
                    }
                }
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [[delegate getNavigationVC:fromControllerIndex] pushViewController:destiVC animated:YES];
            }
        }
    }
    
    else if ([urlString hasPrefix:@"objc:test"]){
        NSLog(@"test: %@", urlString);
    }
    
    else if ([urlString hasPrefix:@"objc:getTabIndex"]){
        NSArray *resultArray = [urlString componentsSeparatedByString:@"$_$"];
        NSString *functionName = [resultArray objectAtIndex:1];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSInteger index = delegate.tabViewController.selectedIndex;
        NSString *actionStr = [NSString stringWithFormat:@"%@(%d)", functionName, index];
        [viewController.myWebView stringByEvaluatingJavaScriptFromString:actionStr];
    }

    //收藏
    else if ([urlString hasPrefix:@"objc:sendUpkInfo"]) {
        [self.productInfoViewController showLogInViewControllerWithData:urlString withDelegate:self.productInfoViewController];
    }
    
    //加入购物车结果
    else if ([urlString hasPrefix:@"objc:addProductToCartWrap"]) {
        NSString *result = [[urlString componentsSeparatedByString:@"$_$"] lastObject];
        if ([result isEqualToString:@"true"]) {
            [MBProgressHUD showSuccess:@"加入购物车成功!" toView:self.productInfoViewController.view];
        } else {
            [MBProgressHUD showError:@"加入购物车失败!" toView:self.productInfoViewController.view];
        }
    }
    
    //传给JS 渠道号
    else if ([urlString hasPrefix:@"objc:getChannelID"]) {
        NSString *channel = [NSString stringWithFormat:@"getAppChannelID('%@')", _CHANNEL_ID_];
        [viewController.myWebView stringByEvaluatingJavaScriptFromString:channel];
    }
    
    //nativePage to webPage
    else if ([urlString hasPrefix:@"objc:iosPageToWebPage"]) {
        [self commonEventParamHandWithViewController:nil urlString:urlString];
    }
    
    //登录页面 需要回调sendLoginResult
    else if ([urlString hasPrefix:@"objc:gotoNativeLoginViewController"]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginTableViewController *logInVC = [storyBoard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
        logInVC.delegate = viewController;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logInVC];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *nav = [appDelegate getNavigationVC:appDelegate.tabViewController.selectedIndex];
        [nav presentViewController:navigationController animated:YES completion:nil];
    }
}

#pragma mark - 普通事件调用的方法
- (void)commonEventParamHandWithViewController:(BasicViewController *)viewController urlString:(NSString *)urlString
{
    NSArray *urlArray = [urlString componentsSeparatedByString:@"$_$"];
    NSString *navTitle = [[[[urlArray objectAtIndex:6] componentsSeparatedByString:@"="] lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSInteger tabBarItemIndex = [[[[urlArray objectAtIndex:4] componentsSeparatedByString:@"="] lastObject] integerValue];
    if (tabBarItemIndex >= 0) {
        if (0 == tabBarItemIndex) {
            [viewController.tabBarController setSelectedIndex:0 animated:YES fromIndex:viewController.itemIndex];
            [viewController.navigationController popToRootViewControllerAnimated:NO];
        }
        if (1 == tabBarItemIndex) {
            [viewController.tabBarController setSelectedIndex:1 animated:YES fromIndex:viewController.itemIndex];
        }
        if (2 == tabBarItemIndex) {
            [viewController.tabBarController setSelectedIndex:2 animated:YES fromIndex:viewController.itemIndex];
        }
        if (3 == tabBarItemIndex) {
            [viewController.tabBarController setSelectedIndex:3 animated:YES fromIndex:viewController.itemIndex];
        }
        if (4 == tabBarItemIndex) {
            [viewController.tabBarController setSelectedIndex:4 animated:YES fromIndex:viewController.itemIndex];
        }
    } else {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.urlString = [urlArray objectAtIndex:1];
        detailVC.itemIndex = viewController.itemIndex;
        detailVC.preWebView = viewController.myWebView;
        detailVC.navTitle = navTitle;
        detailVC.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        detailVC.isHiddenNavBar = [[urlArray objectAtIndex:2] isEqualToString:@"true"] ? YES : NO;
        detailVC.isHiddenTabBar = [[urlArray objectAtIndex:3] isEqualToString:@"true"] ? YES : NO;
        if (detailVC.isHiddenTabBar) {
            detailVC.hidesBottomBarWhenPushed = YES;
        }
        if ([[urlArray objectAtIndex:5] isEqualToString:@"hasEvent=true"]) {
            NSArray *eventTextArray = [[[[urlArray objectAtIndex:7] componentsSeparatedByString:@"="] lastObject] componentsSeparatedByString:@","];
            detailVC.eventText1 = [[eventTextArray firstObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            detailVC.eventText2 = [[eventTextArray lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            detailVC.rightBarButtonAction = [urlArray objectAtIndex:8];
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UINavigationController *nav = [appDelegate getNavigationVC:appDelegate.tabViewController.selectedIndex];
        [nav pushViewController:detailVC animated:YES];
    }
}


#pragma mark - JS调用的返回方法
- (void)afterBackMethodWithViewController:(BasicViewController *)viewController url:(NSString *)urlString needRefresh:(BOOL)needRefresh callBackName:(NSString *)callBack callBackPar:(NSString *)par andURLArray:(NSArray *)urlArray
{
    if (urlArray.count > 9) {
        
        NSString *eventText1 = nil;
        NSString *eventText2 = nil;
        NSString *rightBarAction = nil;
        
        NSString *nativeTitle = [[urlArray[7] componentsSeparatedByString:@"="] lastObject];
        NSString *hasEventStr = [[urlArray[6] componentsSeparatedByString:@"="] lastObject];
        BOOL hasEvent = [hasEventStr isEqualToString:@"true"] ? YES : NO;
        if (hasEvent) {
            if ([viewController isKindOfClass:[RootViewController class]]) {
//                [ManagerDefault standardManagerDefaults].userLogin = YES;
            }
            rightBarAction = urlArray[9];
            
            NSArray *eventTextArray = [[[urlArray[8] componentsSeparatedByString:@"="] lastObject] componentsSeparatedByString:@","];
            eventText1 = [[eventTextArray firstObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            eventText2 = [[eventTextArray lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            if ([viewController isKindOfClass:[RootViewController class]]) {
//                [ManagerDefault standardManagerDefaults].userLogin = NO;
            }
        }
        
        if ([viewController isKindOfClass:[DetailViewController class]]) {
            DetailViewController *preVC = (DetailViewController *)viewController;
            if (![nativeTitle isEqualToString:@"false"]) {
                preVC.navTitle = [nativeTitle stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                preVC.navigationItem.title = preVC.navTitle;
            }
            preVC.eventText1 = eventText1;
            preVC.eventText2 = eventText2;
            preVC.rightBarButtonAction = rightBarAction;
            
            if (needRefresh) {
                if (![callBack isEqualToString:@"false"]) {
                    NSString *actionString = nil;
                    if ([par isEqualToString:@"false"]) {
                        actionString = [NSString stringWithFormat:@"%@()", callBack];
                    } else {
                        actionString = [NSString stringWithFormat:@"%@(\"%@\")", callBack, [par stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    [ManagerDefault standardManagerDefaults].jsActionString = actionString;
                    [ManagerDefault standardManagerDefaults].jsDtailVC = preVC;
                }
                [preVC.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
            } else {
                if (![callBack isEqualToString:@"false"]) {
                    NSString *actionString = nil;
                    if ([par isEqualToString:@"false"]) {
                        actionString = [NSString stringWithFormat:@"%@()", callBack];
                    } else {
                        actionString = [NSString stringWithFormat:@"%@(\"%@\")", callBack, [par stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    [preVC.myWebView stringByEvaluatingJavaScriptFromString:actionString];
                }
            }
            
            [preVC addRightBarButtonItemWithObject:preVC];
        } else if ([viewController isKindOfClass:[RootViewController class]]) {
            RootViewController *rootVC = (RootViewController *)viewController;
            
            if (needRefresh) {
                if (![callBack isEqualToString:@"false"]) {
                    NSString *actionString = nil;
                    if ([par isEqualToString:@"false"]) {
                        actionString = [NSString stringWithFormat:@"%@()", callBack];
                    } else {
                        actionString = [NSString stringWithFormat:@"%@(\"%@\")", callBack, [par stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    [ManagerDefault standardManagerDefaults].jsActionString = actionString;
                    [ManagerDefault standardManagerDefaults].jsRootVC = rootVC;
                }
                [rootVC.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
            } else {
                if (![callBack isEqualToString:@"false"]) {
                    NSString *actionString = nil;
                    if ([par isEqualToString:@"false"]) {
                        actionString = [NSString stringWithFormat:@"%@()", callBack];
                    } else {
                        actionString = [NSString stringWithFormat:@"%@(\"%@\")", callBack, [par stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    [rootVC.myWebView stringByEvaluatingJavaScriptFromString:actionString];
                }
            }
        }
        
    }
}

//点击图片放大
- (void)showImageViewWithViewController:(BasicViewController *)viewController andImageUrls:(NSArray *)urls currentIndex:(NSUInteger)currentIndex
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    imageView.center = viewController.view.center;
    imageView.alpha = 0.0;
    [viewController.view addSubview:imageView];
    
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < urls.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:urls[i]];
        photo.srcImageView = imageView;
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = currentIndex;
    browser.photos = photos;
    [browser show];
}

#pragma mark - 弹出框 消失
- (void)dismissAlertView:(UIAlertView *)sender
{
    [sender dismissWithClickedButtonIndex:0 animated:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlertView:) object:sender];
}

//支付宝wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
    AlixPayResult *payResult = [[AlixPayResult alloc] initWithString:resultd];
    if (payResult) {
        if (payResult.statusCode == 9000) {
            NSArray *array = [payResult.resultString componentsSeparatedByString:@"&"];
            for (NSString *str in array) {
                if ([str hasPrefix:@"success"]) {
                    NSRange range = [str rangeOfString:@"true"];
                    if (range.location != NSNotFound) {
                        
                        //友盟统计
                        [MobClick event:@"iOS_zhifubao_chenggong_pv"];
                        [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_chenggong_uv"];
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        NSDate *dateNow = [NSDate date];
                        NSString *dateNowString = [formatter stringFromDate:dateNow];
                        if ([dateNowString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"registerSuccess"]]) {
                            //当天注册成功当天就支付订单
                            [MobClick event:@"iOS_newChengjiao"];
                        }
                        if (self.currentWebView) {
                            [self.currentWebView stringByEvaluatingJavaScriptFromString:@"alixPayResult('success')"];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:kAlipaySuccess object:nil userInfo:nil];
                        break;
                    }
                    else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayFailed object:nil userInfo:nil];
                    }
                }
            }
        }
        else if (payResult.statusCode == 6001){
            //用户取消
            if (self.currentWebView) {
                [self.currentWebView stringByEvaluatingJavaScriptFromString:@"alixPayResult('faild')"];
            }
            //友盟统计
            [MobClick event:@"iOS_zhifubao_cancel_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_cancel_uv"];
        }
        else if (payResult.statusCode == 4000){
            //订单支付失败
            if (self.currentWebView) {
                [self.currentWebView stringByEvaluatingJavaScriptFromString:@"alixPayResult('faild')"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayFailed object:nil userInfo:nil];
            
            //友盟统计
            [MobClick event:@"iOS_zhifubao_shibai_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_shibai_uv"];
        }
        else if (payResult.statusCode == 6002){
            //网络连接出问题
            if (self.currentWebView) {
                [self.currentWebView stringByEvaluatingJavaScriptFromString:@"alixPayResult('faild')"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayNetworkProblem object:nil userInfo:nil];
            //友盟统计
            [MobClick event:@"iOS_zhifubao_shibai_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_shibai_uv"];
        }
    } else {
        //失败
        if (self.currentWebView) {
            [self.currentWebView stringByEvaluatingJavaScriptFromString:@"alixPayResult('faild')"];
        }
        //友盟统计
        [MobClick event:@"iOS_zhifubao_shibai_pv"];
        [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_shibai_uv"];
    }
}

#pragma mark - 支付宝支付方法
- (void)payOrderInfoWithTradNumber:(NSString *)tradNO upkStr:(NSString *)upkStr
{
    upkStr = [upkStr URLEncodedUTF8Str];
    
    NSString *payString = [NSString stringWithFormat:@"%@?orderid=%@&upk=%@", _ALIXPAY_URL_, tradNO, upkStr];
    NSLog(@"payString %@", payString);
    
    NSError *error = nil;
    NSDictionary *dictionary = nil;
    
    NSURL *payUrl = [NSURL URLWithString:payString];
    NSURLRequest *request = [NSURLRequest requestWithURL:payUrl];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (!error) {
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    } else {
        NSLog(@"json ERROR %@", error);
    }
    
    NSString *appScheme = @"SecooAlixpayDemo";
    NSString *retcode = [dictionary objectForKey:@"retcode"];
    if ([retcode isEqualToString:@"0"]) {
        NSString *orderString = [dictionary objectForKey:@"retmsg"];
        NSLog(@"ORDERINGSTRING %@", orderString);
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
    } else {
        NSLog(@"ERROR: %@", retcode);
    }
}

#pragma mark - 搜索框的提示信息
- (void)searchMsgWithText:(NSString *)text callBack:(SearchResult)searchResult
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *searctString = [NSString stringWithFormat:@"%@?q=%@", _SEARCH_DISPLAY_, text];
        NSURL *searctURL = [NSURL URLWithString:searctString];
        NSURLRequest *searchRequest = [NSURLRequest requestWithURL:searctURL];
        NSError *error;
        NSMutableArray *searchArray = [NSMutableArray arrayWithCapacity:1];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:searchRequest returningResponse:nil error:&error];
        
        if (error) {
            NSLog(@"1搜索提示信息ERROR: %@", error);
        } else {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"2搜索提示信息ERROR: %@", error);
            } else {
                NSArray *resultArray = [result objectForKey:@"rp_result"];
                for (NSDictionary *dic in resultArray) {
                    [searchArray addObject:[dic objectForKey:@"content"]];
                }
                NSLog(@"搜索结果数组 %@", searchArray);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            searchResult(searchArray, error);
        });
    });
}

//友盟统计uv
- (void)UMengAnalyticsUVWithEvent:(NSString *)eventID
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateNow = [NSDate date];
    NSString *dateNowString = [formatter stringFromDate:dateNow];
    NSLog(@"dateNowString %@, %@", dateNowString, [[NSUserDefaults standardUserDefaults] objectForKey:eventID]);
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:eventID] isEqualToString:dateNowString]) {
        //友盟统计uv
        [MobClick event:eventID];
        NSLog(@"不是同一天");
        [[NSUserDefaults standardUserDefaults] setObject:dateNowString forKey:eventID];
    }
}

@end
