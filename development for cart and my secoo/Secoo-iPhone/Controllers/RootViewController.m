//
//  RootViewController.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "RootViewController.h"
#import "ManagerDefault.h"
#import "WebViewJavascriptBridge.h"
#import "GetMacAddr.h"
#import "ScanViewController.h"
#import "MyScannerViewController.h"
#import "MobClick.h"
#import "UserInfoManager.h"
#import "CategoryDetailTableViewController.h"


@interface RootViewController ()

//存储搜索框内的文字，转化成字符串
@property(nonatomic, strong) NSMutableArray *textArray;

//删除按钮
@property(nonatomic, strong) UIBarButtonItem *trashBarButton;
@property(nonatomic, strong) UIBarButtonItem *doneBarButton;

//扫描二维码按钮
@property(nonatomic, strong) UIBarButtonItem *scanerBar;//扫描二维码按钮
@property(nonatomic, strong) UIBarButtonItem *cancleBar;//取消按钮

//退出按钮
@property(nonatomic, strong) UIBarButtonItem *logoutBarButton;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (instancetype)initWithItemIndex:(NSUInteger)itemIndex
{
    self.itemIndex = itemIndex;
    if (self = [super init]) {
        self.itemIndex = itemIndex;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    if (0 == self.itemIndex) {
        //存储设备信息
        [self saveDeviceInfo];
        
        //实例化一个扫描二维码按钮
        UIButton *scanerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [scanerButton setFrame:CGRectMake(0, 0, 22, 22)];
        [scanerButton setBackgroundImage:[UIImage imageNamed:@"scaner"] forState:UIControlStateNormal];
        [scanerButton addTarget:self action:@selector(scanViewControllerPresent) forControlEvents:UIControlEventTouchUpInside];
        self.scanerBar = [[UIBarButtonItem alloc] initWithCustomView:scanerButton];
        self.cancleBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(resignTheSearchBar)];
        self.navigationItem.rightBarButtonItem = _scanerBar;
        
        //搜索框
        self.searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searchBar.placeholder = @"搜索商品或品牌";
        _searchBar.delegate = self;
        self.navigationItem.titleView = _searchBar;
        
        //搜索提示信息
        CGRect searchDisplayFrame = searchDisplayFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - 49.0f);;
        if (_IOS_7_LATER_) {
            searchDisplayFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49.0f);
        } else {
            searchDisplayFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - 49.0f);
        }
        
        self.searchDisplayView = [[SearchDisplayView alloc] initWithFrame:searchDisplayFrame delegate:self];
        [self.view addSubview:_searchDisplayView];
        _searchDisplayView.hidden = YES;
        
    } else if (1 == self.itemIndex) {
        //品牌页
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"A-Z" style:UIBarButtonItemStyleBordered target:self action:@selector(didClickBigSmallBarButtonItem:)];
        self.navigationItem.rightBarButtonItem = rightBar;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [ManagerDefault standardManagerDefaults].isUsed = YES;
    } else if (3 == self.itemIndex) {
        //购物车
        self.trashBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_cartWrapper1"] style:UIBarButtonItemStyleBordered target:self action:@selector(didClickTrashBarButtonItem:)];
        self.doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(didClickTrashBarButtonItem:)];
        
        [ManagerDefault standardManagerDefaults].isUsed = YES;
    } else if (4 == self.itemIndex) {
        //我的寺库
        self.logoutBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"img_userWrapper" ofType:@"png"]] style:UIBarButtonItemStyleBordered target:self action:@selector(logOut)];
        
        [ManagerDefault standardManagerDefaults].isUsed = YES;
    } else {
        [ManagerDefault standardManagerDefaults].isUsed = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.myWebView) {
        CGRect webViewFrame = self.view.bounds;
        if (_IOS_7_LATER_ && 0 == self.itemIndex) {
            webViewFrame = CGRectMake(0, 64.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - 49.0f);
        }
        
        self.myWebView = [[UIWebView alloc] initWithFrame:webViewFrame];
        [self.myWebView.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.myWebView.scrollView setBackgroundColor:BACKGROUND_COLOR];
        self.myWebView.scrollView.decelerationRate = 1.0f;
        [self.myWebView setBackgroundColor:BACKGROUND_COLOR];
        [self.myWebView setScalesPageToFit:YES];
        [self.myWebView setOpaque:NO];
        [self.view addSubview:self.myWebView];
        
        //实例化 bridge
        __weak RootViewController *weakSelf = self;
        [WebViewJavascriptBridge enableLogging];
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.myWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"Objc received message from JS: %@", data);
            [[ManagerDefault standardManagerDefaults] responseForMessageOfString:data viewController:weakSelf];
        }];
    }
    
    if (self.itemIndex == 0) {
        AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.webView = self.myWebView;
    }
    
    self.openNewPage = NO;
    [ManagerDefault standardManagerDefaults].currentWebView = self.myWebView;
    
    if (!([self.myWebView isLoading] || [self isFinishLoad])) {
        
        if (0 == self.itemIndex) {
            self.urlString = SECOO_URL_IPHONE;
        } else if (1 == self.itemIndex) {
            self.urlString = [[[[ManagerDefault standardManagerDefaults] brandURLString] componentsSeparatedByString:@"$_$"] firstObject];
        } else if (2 == self.itemIndex) {
            self.urlString = [[[[ManagerDefault standardManagerDefaults] listURLString] componentsSeparatedByString:@"$_$"] firstObject];
        } else if (3 == self.itemIndex) {
            self.urlString = [[[[ManagerDefault standardManagerDefaults] shopURLString] componentsSeparatedByString:@"$_$"] firstObject];
        } else if (4 == self.itemIndex) {
            self.urlString = [[[[ManagerDefault standardManagerDefaults] userURLString] componentsSeparatedByString:@"$_$"] firstObject];
        }
        NSLog(@"urlString %@", self.urlString);
        
        if (!self.urlString) {
            return;
        }
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    } else {
        if (3 == self.itemIndex) {            
            [self.myWebView stringByEvaluatingJavaScriptFromString:[ManagerDefault standardManagerDefaults].carWrapperCallBackStr];
        } else if (4 == self.itemIndex) {
            [self addLogoutBar];
        }
    }
    
    //友盟页面统计
    if (0 == self.itemIndex) {
        [MobClick beginLogPageView:@"indexPage"];
    } else if (1 == self.itemIndex) {
        [MobClick beginLogPageView:@"brandPage"];
        [ManagerDefault standardManagerDefaults].isUsed = YES;
    } else if (2 == self.itemIndex) {
        [MobClick beginLogPageView:@"listPage"];
        [ManagerDefault standardManagerDefaults].isUsed = YES;
    } else if (3 == self.itemIndex) {
        [MobClick beginLogPageView:@"shopPage"];
        [ManagerDefault standardManagerDefaults].isUsed = YES;
    } else if (4 == self.itemIndex) {
        [MobClick beginLogPageView:@"userPage"];
        [ManagerDefault standardManagerDefaults].isUsed = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (3 == self.itemIndex) {
        if ([[ManagerDefault standardManagerDefaults].orderNumber isEqualToString:@"0"]) {
            self.navigationItem.rightBarButtonItem = nil;
        } else {
            self.navigationItem.rightBarButtonItem = self.trashBarButton;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //友盟页面统计
    if (0 == self.itemIndex) {
        [MobClick endLogPageView:@"indexPage"];
    } else if (1 == self.itemIndex) {
        [MobClick endLogPageView:@"brandPage"];
    } else if (2 == self.itemIndex) {
        [MobClick endLogPageView:@"listPage"];
    } else if (3 == self.itemIndex) {
        [MobClick endLogPageView:@"shopPage"];
    } else if (4 == self.itemIndex) {
        [MobClick endLogPageView:@"userPage"];
    }
}

#pragma mark - 存储设备信息
-(void)saveDeviceInfo
{
    UIDevice *device_=[UIDevice currentDevice];
    if ([[device_ systemVersion] floatValue] >= 6.0) {
        self.mac = [GetMacAddr macaddress];
        self.idfv = [[device_ identifierForVendor] UUIDString];
        self.idfa = [Utils getDeviceUDID];
    } else {
        self.mac = [GetMacAddr macaddress];
    }
    self.from = @"app";
    self.screenwidth =[NSString stringWithFormat:@"%.f", [[UIScreen mainScreen] bounds].size.width * [UIScreen mainScreen].scale];
    self.screenheight = [NSString stringWithFormat:@"%.f", [[UIScreen mainScreen] bounds].size.height * [UIScreen mainScreen].scale];
    self.phonetype = @"2";
    self.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.phonename = [device_.model stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.ownername = device_.name;
    self.platform = device_.systemVersion;
    self.localizedmodel = device_.localizedModel;
    self.systemname = device_.systemName;
    
    NSString *deviceInfo = [NSString stringWithFormat:@"{\"mac\":\"%@\",\"idfa\":\"%@\",\"idfv\":\"%@\",\"from\":\"%@\",\"screenwidth\":\"%@\",\"screenheight\":\"%@\",\"phonetype\":\"%@\",\"version\":\"%@\",\"phonename\":\"%@\",\"ownername\":\"%@\",\"platform\":\"%@\",\"localizedmodel\":\"%@\",\"systemname\":\"%@\"}",_mac,_idfa,_idfv,_from,_screenwidth,_screenheight,_phonetype,_version,_phonename,_ownername,_platform,_localizedmodel,_systemname];
    NSLog(@"deviceInfo==%@",deviceInfo);
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceInfo forKey:@"deviceInfo"];
}

#pragma mark - 扫描二维码
- (void)scanViewControllerPresent
{
    MyScannerViewController *scaner = [[MyScannerViewController alloc] init];
    [self presentViewController:scaner animated:YES completion:nil];
    
    [ManagerDefault standardManagerDefaults].isUsed = YES;
}

//取消按钮
- (void)resignTheSearchBar
{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = nil;
    [self.navigationItem setRightBarButtonItem:self.scanerBar animated:YES];
    
    self.searchDisplayView.hidden = YES;
    [self.view sendSubviewToBack:_searchDisplayView];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
    self.finishLoad = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
    self.finishLoad = YES;
    if (4 == self.itemIndex) {
        [self addLogoutBar];
        
        if ([ManagerDefault standardManagerDefaults].jsRootVC && [ManagerDefault standardManagerDefaults].jsActionString) {
            [[ManagerDefault standardManagerDefaults].jsRootVC.myWebView stringByEvaluatingJavaScriptFromString:[ManagerDefault standardManagerDefaults].jsActionString];
            [ManagerDefault standardManagerDefaults].jsActionString = nil;
            [ManagerDefault standardManagerDefaults].jsRootVC = nil;
        }
    }
    
    self.navigationItem.rightBarButtonItem.enabled = YES;    
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UISearchBarDelegate 搜索框的代理方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.navigationItem setRightBarButtonItem:self.cancleBar animated:YES];
    
    self.textArray = [NSMutableArray arrayWithCapacity:1];
    
    [ManagerDefault standardManagerDefaults].isUsed = YES;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self.textArray removeAllObjects];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.textArray removeAllObjects];
    
    if ([searchText isEqualToString:@""]) {
        self.searchDisplayView.hidden = YES;
        [self.view sendSubviewToBack:_searchDisplayView];
    } else {
        self.searchDisplayView.hidden = NO;
        [self.view bringSubviewToFront:_searchDisplayView];
    }
    
    [[ManagerDefault standardManagerDefaults] searchMsgWithText:searchText callBack:^(NSArray *searchArray, NSError *error) {
        if (error) {
            NSLog(@"请求失败!");
        } else {
            if (self.searchDisplayView) {
                [self.searchDisplayView handDataSouceWithArray:searchArray];
            }
        }
    }];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"text=== %@,", text);
    if (text.length > 0) {
        [self.textArray addObject:text];
    } else {
        [self.textArray removeLastObject];
    }
    NSString *resultText = [self.textArray componentsJoinedByString:@""];
    NSLog(@"resultText=== %@", resultText);
    
    if ([resultText isEqualToString:@""]) {
        self.searchDisplayView.hidden = YES;
        [self.view sendSubviewToBack:_searchDisplayView];
    } else {
        self.searchDisplayView.hidden = NO;
        [self.view bringSubviewToFront:_searchDisplayView];
    }
    
    [[ManagerDefault standardManagerDefaults] searchMsgWithText:resultText callBack:^(NSArray *searchArray, NSError *error) {
        if (error) {
            NSLog(@"请求失败!");
        } else {
            if (self.searchDisplayView) {
                [self.searchDisplayView handDataSouceWithArray:searchArray];
            }
        }
    }];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%s", __FUNCTION__);
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.searchDisplayView.hidden = YES;
    [self.view sendSubviewToBack:_searchDisplayView];
    [self.textArray removeAllObjects];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryDetailTableViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailTableViewController"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.title = self.searchBar.text;
    detailVC.listType = ListSearchType;
    detailVC.keyWord = self.searchBar.text;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 添加退出按钮
- (void)addLogoutBar
{
    if ([ManagerDefault standardManagerDefaults].userLogin == YES) {
        self.navigationItem.rightBarButtonItem = self.logoutBarButton;
        [self.myWebView stringByEvaluatingJavaScriptFromString:@"userStatusAction('true')"];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        [self.myWebView stringByEvaluatingJavaScriptFromString:@"userStatusAction('false')"];
    }
}

#pragma mark - 点击切换大小图按钮
- (void)didClickBigSmallBarButtonItem:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"A-Z"]) {
        sender.title = @"大图";
    } else {
        sender.title = @"A-Z";
    }
    NSString *actionString = [NSString stringWithFormat:@"navEventAction(\"eventFun\")"];
    [self.myWebView stringByEvaluatingJavaScriptFromString:actionString];
}

#pragma mark - 点击删除按钮
- (void)didClickTrashBarButtonItem:(UIBarButtonItem *)sender
{
    if (self.navigationItem.rightBarButtonItem == self.trashBarButton) {
        self.navigationItem.rightBarButtonItem = self.doneBarButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.trashBarButton;
    }
    
    NSArray *cartWrapperArr = [[ManagerDefault standardManagerDefaults].shopURLString componentsSeparatedByString:@"$_$"];
    NSString *actionString = [cartWrapperArr lastObject];
    NSString *actionName = [[actionString componentsSeparatedByString:@"="] lastObject];
    NSString *actionPar = [[actionString componentsSeparatedByString:@"="] firstObject];
    NSString *action = [NSString stringWithFormat:@"%@(\"%@\")", actionName, actionPar];
    [self.myWebView stringByEvaluatingJavaScriptFromString:action];
}

#pragma mark - 单击退出按钮
- (void)logOut
{
    NSArray *cartWrapperArr = [[ManagerDefault standardManagerDefaults].userURLString componentsSeparatedByString:@"$_$"];
    NSString *actionString = [cartWrapperArr lastObject];
    NSString *actionName = [[actionString componentsSeparatedByString:@"="] lastObject];
    NSString *actionPar = [[actionString componentsSeparatedByString:@"="] firstObject];
    NSString *action = [NSString stringWithFormat:@"%@(\"%@\")", actionName, actionPar];
    [self.myWebView stringByEvaluatingJavaScriptFromString:action];
    self.navigationItem.rightBarButtonItem = nil;
    [ManagerDefault standardManagerDefaults].userLogin = NO;
    
    //LLGG
    [UserInfoManager setLogState:NO];
}

#pragma MARK - SearchDisplayViewDelegate
- (void)hasSelectOneMsg:(NSString *)msg
{
    self.searchBar.text = msg;
    self.searchDisplayView.hidden = YES;
    [self.view sendSubviewToBack:_searchDisplayView];
    [self searchBarSearchButtonClicked:self.searchBar];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
