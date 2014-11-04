//
//  BasicViewController.h
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LoginTableViewController.h"
@class WebViewJavascriptBridge;

typedef enum alertStatue{
    OnlyCancle,
    OnlySure,
    CancleAndSure
}AlertStatue;


@interface BasicViewController : UIViewController<UIWebViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, LoginDelegate>

@property (nonatomic, assign) NSUInteger itemIndex;//在 tabBar 上的下标
@property (nonatomic, strong) UIWebView  *myWebView;//该页面的 webView
@property (nonatomic, strong) UIWebView  *preWebView;//上个页面的 webView
@property (nonatomic, copy  ) NSString   *urlString;//该页面的 webView 加载需要的 URL
@property (nonatomic, copy  ) NSString   *navTitle;//导航栏的标题
@property (nonatomic, copy  ) NSString   *eventText1;//rightBarButtonItem的标题
@property (nonatomic, copy  ) NSString   *eventText2;
@property (nonatomic, copy  ) NSString   *rightBarButtonAction;//点击rightButton需要的参数和方法名
@property (nonatomic, assign) BOOL       isHiddenNavBar;//是否隐藏navigationBar
@property (nonatomic, assign) BOOL       isHiddenTabBar;//是否隐藏tabBar

//URL中的页面名称
@property(nonatomic, copy) NSString *viewName;

//是否加载完成
@property(nonatomic, assign, getter = isFinishLoad) BOOL finishLoad;

//是否打开一个新页面
@property(nonatomic, assign) BOOL openNewPage;

//JS 和 OC 交互
@property(nonatomic, strong) WebViewJavascriptBridge *bridge;

//是否是购物车
@property(nonatomic,assign) BOOL isShopVC;

//上级页面需要调用的方法和参数
@property(nonatomic, copy) NSString *previousAction;
@property(nonatomic, copy) NSString *previousActionPar;

//alertAction 弹出提示框的回调方法名
//@property(nonatomic, copy) NSString *alertAction;
@property(nonatomic, copy) NSString *alertCancleAction;//取消按钮回调方法
@property(nonatomic, copy) NSString *alertSureAction;//确定按钮回调方法
@property(nonatomic, assign) AlertStatue alertViewStatue;//alertView的按钮有哪些

@end
