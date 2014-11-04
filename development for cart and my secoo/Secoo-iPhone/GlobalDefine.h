//
//  GlobalDefine.h
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#ifndef Secoo_iPhone_GlobalDefine_h
#define Secoo_iPhone_GlobalDefine_h

#import "AppDelegate.h"

#ifdef DEBUG
#else
#define NSLog(...){};
#endif

//首页 URL
#define SECOO_URL_IPHONE @"http://iphone.secoo.com/iphone4.2/"
//#define SECOO_URL_IPHONE @"http://192.168.200.30/iphone4.2/"

//拍卖
#define AUCTION_URL @"http://iphone.secoo.com/iphone4.2/view/auctionHistoryList.html"

//寄卖
#define JIMAI_URL @"http://iphone.secoo.com/iphone4.2/view/jimaiWrapper.html"

//养护说明
#define MAINTAIN_SERVICE @"http://iphone.secoo.com/iphone4.2/view/maintainService.html"
//售后服务
#define AFTER_SERVICE @"http://iphone.secoo.com/iphone4.2/view/afterService.html"

//支付宝支付
#define _ALIXPAY_URL_ @"http://pay.secoo.com/b2c/alipay/alipaySDKPay.jsp"
//搜索提示信息
#define _SEARCH_DISPLAY_ @"http://www.secoo.com/indexSearch/suggestKeyword/mobileSearch"

//黄色
#define MAIN_YELLOW_COLOR ([UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1])

//灰色
#define BACKGROUND_COLOR ([UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1])

//灰色线颜色
#define _LINE_COLOR_ [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1]

//屏幕宽高
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

//self.view.bound 不包括tabBar的高度
#define VIEW_BOUND_NOINCLUDE_TABBAR (CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 46))
#define VIEW_BOUND_NOINCLUDE_TABBAR_ROOT (CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 46*2))

//iOS 版本
#define _IOS_VERSION_   [[[UIDevice currentDevice] systemVersion] floatValue]
#define _IOS_8_LATER_    !(_IOS_VERSION_ < 8.0)
#define _IOS_7_LATER_    !(_IOS_VERSION_ < 7.0)
#define _IOS_6_LATER_    !(_IOS_VERSION_ < 6.0)


//订单数 label 的 tag
#define ORDER_LABEL_TAG                         100
//头部金线的tag
#define LINE_VIEW_TAG                           101

//尺寸 颜色 选择
#define _IMG_TAG_                               400
#define _LABEL_TAG_                             500


//活动开始结束时间的 key
#define ACTIVE_START_TIME @"active_start_time"
#define ACTIVE_END_TIME @"active_end_time"
#define ACTIVE_IMAGE_PATH @"active_image_path"


//加载图片
#define _IMAGE_WITH_NAME(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(A) ofType:@"png"]]

//友盟统计
#define UMENG_APPKEY @"53e20e58fd98c539aa003ed6"

#define ORDER_NUMBER_NOTIFACATION @"OrderNumberHasChanged"

///new defines

//渠道号
#define _CHANNEL_ID_ @"App Store"

//用户账号
#define _USER_ACCOUNT_ @"USER_ACCOUNT"

#define MainManagedObjectContext ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext
#define MainPersistentStoreCoordinator ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentStoreCoordinator
#define CategoryEntityName @"CategoryEntity"
#define CategoryChildName @"CategoryChild"

#define BrandDataDidChangedNotification @"BrandDataDidChangedNotification"
#define AddressDataDidChangeNotification @"AddressDataDidChangeNotification"
#define kSelfLocationChanged @"kSelfLocationChanged"
#define kSelfHeadingChanged @"kSelfHeadingChanged"
#define kDidAddCartItemNotification @"DidAddCartItemNotification"
#define kCartItemDidChangeNotification @"CartItemDidChangeNotification"
#define kDidGetTotalValue @"DidGetTotalValue"
#define kSoldoutProductsNotifcation @"SoldoutProductsNotifcation"
#define kNotEnoughProductsNotification @"NotEnoughProductsNotification"
#define kNeedGetCartInfoAgain @"NeedGetCartInfoAgain"

#define kAlipaySuccess @"AlipaySuccess"
#define kAlipayFailed @"AlipayFailed"
#define kAlipayNetworkProblem @"AlipayNetworkProblem"

#define kWXpaySuccess @"WXpaySuccess"
#define kWXpayUserCancelled @"WXpayUserCancelled"
#define kWXpayFailed @"WXpayFailed"
#endif
