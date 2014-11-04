//
//  OrderResultViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/28/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "OrderResultViewController.h"
#import "LGURLSession.h"
#import "MBProgressHUD+Add.h"
#import "UserInfoManager.h"
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "WXApi.h"
#import "ExchangeRateInfoViewController.h"
#import "OrderTypeAccessor.h"
#import "AppDelegate.h"
#import "DetailedOrderInfoViewController.h"
#import "ProductInfoViewController.h"

@interface OrderResultViewController ()<ExchangeRateInfoDelegate>

@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *exchangeInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *exchangeInfoButton;

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UILabel *depositNameLabel;

- (IBAction)payForOrder:(id)sender;
- (IBAction)addExchangeInfo:(id)sender;
@end

@implementation OrderResultViewController

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
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    self.backgroundView.layer.cornerRadius = 5;
    self.payButton.layer.cornerRadius = 3;
    self.exchangeInfoButton.layer.cornerRadius = 3;
    
    self.successView.alpha = 1.0;
    self.exchangeInfoLabel.alpha = 0.0;
    self.exchangeInfoButton.alpha = 0.0;
    self.payButton.alpha = 1.0;
    
    if ([self.deliverType isEqualToString:@"1"]) {
        //快递
        self.totalMoneyNameLabel.alpha = 1.0;
        self.totalMoneyLabel.alpha = 1.0;
        self.depositNameLabel.alpha = 0;
        self.depositLabel.alpha = 0;
    } else {
        //到店自提
        self.totalMoneyLabel.alpha = 0;
        self.totalMoneyNameLabel.alpha = 0;
        self.depositLabel.alpha = 1.0;
        self.depositNameLabel.alpha =1.0;
    }
    
    if (_areaType != 0) {
        self.payButton.alpha = 0.0;
        [self getUserExchangeInfo];
    }
    [self setUpViews];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"查看订单" style:UIBarButtonItemStylePlain target:self action:@selector(goToOrderDetailView)];
    self.navigationItem.rightBarButtonItem = right;
    
    [[OrderTypeAccessor sharedInstance] savePayType:self.mobilePayType forOrderId:[self.orderID integerValue]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipaySuccess:) name:kAlipaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipayFailed:) name:kAlipayFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipayNetworkProblem:) name:kAlipayNetworkProblem object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipaySuccess:) name:kWXpaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipayFailed:) name:kWXpayFailed object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OrderResult"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrderResult"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.tabViewController.selectedIndex != 3){//productinfor
        NSArray *viewcontrollers = self.navigationController.viewControllers;
        BOOL hasIt = NO;
        for (UIViewController *vc in viewcontrollers) {
            if ([vc isKindOfClass:[ProductInfoViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                hasIt = YES;
                break;
            }
        }
        if (!hasIt) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{// main page
        NSArray *viewcontrollers = self.navigationController.viewControllers;
        BOOL hasIt = NO;
        for (UIViewController *vc in viewcontrollers) {
            if ([vc isKindOfClass:[ProductInfoViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                hasIt = YES;
                break;
            }
        }
        if (!hasIt) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIViewController *vc = [delegate getNavigationVC:0];
            delegate.tabViewController.selectedViewController = vc;
            
            UINavigationController *nav = [delegate getNavigationVC:3];
            NSArray *array = nav.viewControllers;
            nav.viewControllers = @[[array objectAtIndex:0]];
        }
    }
}

- (void)setUpViews
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateNow = [NSDate date];
    NSString *dateNowString = [formatter stringFromDate:dateNow];
    if ([dateNowString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"registerSuccess"]]) {
        //当天注册成功当天就提交订单
        [MobClick event:@"iOS_newDingdan"];
    }
    
    if (!(4 == [self.mobilePayType intValue] || 5 == [self.mobilePayType intValue])) {
        [self.payButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    self.orderIdLabel.text = self.orderID;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f", [self.realTotalMoney floatValue]];
    self.depositLabel.text = [NSString stringWithFormat:@"¥ %.2f", [self.depositMoney floatValue]];
}

- (void)goToOrderDetailView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailedOrderInfoViewController *detailOrderVC = [storyboard instantiateViewControllerWithIdentifier:@"DetailedOrderInfoViewController"];
    detailOrderVC.orderId = self.orderID;
    detailOrderVC.hidesBottomBarWhenPushed = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.tabViewController.selectedIndex == 3) {
        detailOrderVC.goBackType = 2;
    }
    else{
        detailOrderVC.goBackType = 1;
    }
    [self.navigationController pushViewController:detailOrderVC animated:YES];
}

- (void)handleAlipaySuccess:(NSNotification *)notification
{
    [MBProgressHUD showSuccess:@"支付成功!" toView:self.view];
    [[OrderTypeAccessor sharedInstance] deletePayTypeForOrderId:[self.mobilePayType integerValue]];
    [self goToOrderDetailView];
}

- (void)handleAlipayFailed:(NSNotification *)notification
{
    [MBProgressHUD showError:@"支付失败!" toView:self.view];
}

- (void)handleAlipayNetworkProblem:(NSNotification *)notification
{
    [MBProgressHUD showError:@"您的网络连接出现问题！" toView:self.view];
}

- (void)getUserExchangeInfo
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=exchange/UserExchange.jsp&v=1.0&client=iphone&vo.upkey=%@&method=secoo.exchange.queryUserInfo", upKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(OrderResultViewController*) weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil && data) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                if (weakSelf) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.payButton.alpha = 1.0;
                        });
                    }
                    else if ([[jsonDict objectForKey:@"recode"] integerValue] == -1){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.exchangeInfoLabel.alpha = 1.0;
                            weakSelf.exchangeInfoButton.alpha = 1.0;
                            weakSelf.payButton.alpha = 0.0;
                            weakSelf.navigationItem.rightBarButtonItem = nil;
                        });
                    }
                }
            }
        }
        else{
            NSLog(@"get user exchange info error: %@", error.description);
        }
    }];
}

#pragma mark --
#pragma mark -- submit order request --

- (IBAction)payForOrder:(id)sender
{
    
    if (!(4 == [self.mobilePayType intValue] || 5 == [self.mobilePayType intValue])) {
        [self backToPreviousViewController:nil];
        return;
    }
    
    //友盟统计 点击去支付
    [MobClick event:@"iOS_zhifu_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifu_uv"];
    
    UIButton *button = (UIButton *)sender;
    [button setTitle:@"连接中..." forState:UIControlStateNormal];
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url;
    if ([self.mobilePayType isEqualToString:@"5"]) {
        //5 支付宝，4 微信 3 银联
        url = [NSString stringWithFormat:@"http://pay.secoo.com/b2c/alipay/alipaySDKPay.jsp?orderid=%@&upk=%@", self.orderID, upKey];
    }
    else if ([self.mobilePayType isEqualToString:@"4"]){
        url = [NSString stringWithFormat:@"http://pay.secoo.com/b2c/weixin/app/weixinAppPay.jsp?orderid=%@&upk=%@", self.orderID, upKey];
    }
    else if ([self.mobilePayType isEqualToString:@"3"]){
        
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(OrderResultViewController *) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:@"去支付" forState:UIControlStateNormal];
        });
        if (error == nil && data) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                if ([[jsonResponse objectForKey:@"retcode"] integerValue] == 0) {
                    if (weakSelf) {
                        if ([weakSelf.mobilePayType isEqualToString:@"5"]) {
                            NSString *orderMessage = [jsonResponse objectForKey:@"retmsg"];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSString *appScheme = @"SecooAlixpayDemo";
                                [AlixLibService payOrder:orderMessage AndScheme:appScheme seletor:@selector(handleAlipayResult:) target:weakSelf];
                            });
                        }
                        else if ([weakSelf.mobilePayType isEqualToString:@"4"]){
                            NSString *orderStr = [jsonResponse objectForKey:@"result"];
                            NSDictionary *orderDict = [NSJSONSerialization JSONObjectWithData:[orderStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                PayReq *request = [[PayReq alloc] init];
                                request.partnerId = [orderDict valueForKey:@"partnerid"];
                                request.prepayId= [orderDict valueForKey:@"prepayid"];
                                request.package = [orderDict valueForKey:@"package"];
                                request.nonceStr= [orderDict valueForKey:@"noncestr"];
                                request.timeStamp= [[orderDict valueForKey:@"timestamp"] intValue];
                                request.sign= [orderDict valueForKey:@"sign"];
                                [WXApi safeSendReq:request];
                            });
                        }
                        else if ([weakSelf.mobilePayType isEqualToString:@"3"]){
                        }
                    }
                    else{
                        //TODO:
                    }
                }
            }
        }
        else{
            NSLog(@"pay for order error:%@", error.description);
        }
    }];
}

- (void)handleAlipayResult:(NSString *)result
{
    AlixPayResult *payResult = [[AlixPayResult alloc] initWithString:result];
    //NSLog(@"result:%@", result);
    [Utils handleAlipayResult:payResult];
}

- (IBAction)addExchangeInfo:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExchangeRateInfoViewController *exchangeVC = [storyboard instantiateViewControllerWithIdentifier:@"ExchangeRateInfoViewController"];
    exchangeVC.delegate = self;
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

#pragma mark --
#pragma mark -- ExchangeRateDelegate--
- (void)didProvideExchangeRateInfo
{
    self.exchangeInfoLabel.alpha = 0.0;
    self.exchangeInfoButton.alpha = 0.0;
    self.payButton.alpha = 1.0;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"查看订单" style:UIBarButtonItemStylePlain target:self action:@selector(goToOrderDetailView)];
    self.navigationItem.rightBarButtonItem = right;
}

@end
