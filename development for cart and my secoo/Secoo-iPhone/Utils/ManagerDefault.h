//
//  ManagerDefault.h
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


@class BasicViewController, RootViewController, DetailViewController, ProductInfoViewController;

//请求网络图片的回调
typedef void(^CallBack)(UIImage *image, NSString *startTime, NSString *endTime);

//请求搜索提示信息的回调
typedef void(^SearchResult)(NSArray *searchArray, NSError *error);


@interface ManagerDefault : NSObject

//网络状态
@property(nonatomic, assign) NetworkStatus netWorkStatus;

//用户是否进行操作
@property(nonatomic, assign) BOOL isUsed;

//订单数
@property(nonatomic, strong) UILabel *orderLabel;
@property(nonatomic, copy) NSString *orderNumber;

//我的寺库提示信息
@property(nonatomic, strong) UILabel *msgLabel;

//存储当前的 webView
@property(nonatomic, strong) UIWebView *currentWebView;

//用户登录状态
@property(nonatomic, assign) BOOL userLogin;

//保存标签栏的URL,包含URL和参数
@property(nonatomic, copy) NSString *brandURLString;
@property(nonatomic, copy) NSString *listURLString;
@property(nonatomic, copy) NSString *shopURLString;
@property(nonatomic, copy) NSString *userURLString;

//刷新页面后回调 JS 代码的 viewController 和方法
@property(nonatomic, strong) RootViewController *jsRootVC;
@property(nonatomic, strong) DetailViewController *jsDtailVC;
@property(nonatomic, copy) NSString *jsActionString;

//暂时保存分享的信息
@property(nonatomic, copy) NSString *shareTitle;//微信
@property(nonatomic, copy) NSString *shareTitle2;//朋友圈
@property(nonatomic, copy) NSString *shareDescription;
@property(nonatomic, copy) NSString *shareURL;
@property(nonatomic, copy) NSString *shareImageURL;
@property(nonatomic, strong) NSData *shareImageData;

//详情页对象 native
@property(nonatomic, weak) ProductInfoViewController *productInfoViewController;

//购物车
@property(nonatomic, strong) BasicViewController *shopVC;
//购物车回调方法
@property(nonatomic, copy) NSString *carWrapperCallBackStr;

//单例方法
+ (ManagerDefault *)standardManagerDefaults;

//接收到 JS 消息后的回调方法
- (void)responseForMessageOfString:(NSString *)urlString viewController:(BasicViewController *)viewController;

//普通事件
- (void)commonEventParamHandWithViewController:(BasicViewController *)viewController urlString:(NSString *)urlString;

//存储分享的信息
- (void)saveShareInformationWithJSUrl:(NSString *)receiveString;

//从服务端请求活动页图片
- (void)imageWithURL:(NSString *)urlString callBack:(CallBack)callBack;

//友盟统计pv
- (void)UMengAnalyticsUVWithEvent:(NSString *)eventID;

//搜索框的提示信息
- (void)searchMsgWithText:(NSString *)text callBack:(SearchResult)searchResult;

//支付宝
- (void)payOrderInfoWithTradNumber:(NSString *)tradNO upkStr:(NSString *)upkStr;
@end
