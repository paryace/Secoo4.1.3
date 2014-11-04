//
//  DetailedOrderInfoViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/13/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "DetailedOrderInfoViewController.h"
#import "LGURLSession.h"
#import "MBProgressHUD+Add.h"
#import "UserInfoManager.h"
#import "ProductView.h"
#import "OrderTypeAccessor.h"
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "WXApi.h"
#import "ProductInfoViewController.h"
#import "AppDelegate.h"
#import "CartItemAccessor.h"


#define LINE_VIEW_COLOR                 [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1]
#define LEFT_INSERT                     10

@interface DetailedOrderInfoViewController ()
{
    BOOL _enablePay;
    float _totalTax;
    BOOL _exchangeFinish;//请求转汇信息完成
    BOOL _exchange;//是否填写过转汇信息
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSDictionary *orderInfo;
@property(nonatomic, strong) NSDictionary *orders;//订单信息
@property(nonatomic, strong) NSArray *orderTrack;//订单状态
@property(nonatomic, strong) NSArray *productArray;//商品

@property(nonatomic, weak) UILabel *productPriceLabel;//商品金额
@property(nonatomic, weak) UILabel *favorableLabel;//下单优惠
@property(nonatomic, weak) UILabel *freightLabel;//运费
@property(nonatomic, weak) UILabel *taxLabel;//关税
@property(nonatomic, weak) UILabel *rebateLabel;//返利库币
@property(nonatomic, weak) UILabel *payLabel;//应付金额

@property(nonatomic, weak) UILabel *consigneeNameLabel;//收货人
@property(nonatomic, weak) UILabel *consigneePhoneLabel;//手机号码
@property(nonatomic, weak) UILabel *consigneeAddressLabel;//收货地址

@property(nonatomic, weak) UILabel *invoiceLabel;//发票信息

@property(nonatomic, weak) UIButton *payButton;//去支付 填写转汇信息按钮

@property(nonatomic, strong) NSString *mobilePayType;

@property(nonatomic, weak) UIActivityIndicatorView *indicatorView;
@end

@implementation DetailedOrderInfoViewController

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
    self.navigationItem.title = @"订单详情";
    
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    [self getUserExchangeInfo];
    [self getDetailedInfomation];
    _mobilePayType = [[OrderTypeAccessor sharedInstance] getPayTypeForOrderId:[self.orderId integerValue]];
    [self startActivityIndicatorView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipaySuccess:) name:kAlipaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipayFailed:) name:kAlipayFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipayNetworkProblem:) name:kAlipayNetworkProblem object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipaySuccess:) name:kWXpaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipayFailed:) name:kWXpayFailed object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DetailOrderInfo"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DetailOrderInfo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    if (self.goBackType == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.goBackType == 1){//productinfor
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
    else if (self.goBackType == 2){// main page
        if ([[CartItemAccessor sharedInstance] numberOfCartItems] == 0) {
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
        else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)startActivityIndicatorView
{
    CGRect frame = CGRectMake((self.view.frame.size.width - 50) / 2.0, (self.view.frame.size.height - 50) / 2.0, 50, 50);
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [self.view addSubview:indicatorView];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [indicatorView startAnimating];
    self.indicatorView = indicatorView;
}

#pragma mark --
#pragma mark -- Get order information --
- (void)getDetailedInfomation
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/orders_ordersget.action?upkey=%@&orderId=%@", upKey, self.orderId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(DetailedOrderInfoViewController *) weakSelf = self;
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(DetailedOrderInfoViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.indicatorView stopAnimating];
                [strongSelf.indicatorView removeFromSuperview];
            });
            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            strongSelf.orderInfo = jsonDict;
                            [strongSelf handleOrderInfoResponse];
                        });
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:[jsonDict objectForKey:@"errMsg"] toView:strongSelf.view];
                        });
                    }
                }
                else{
                    NSLog(@"parsing order info error:%@", jsonError.description);
                }
            }
            else{
                NSLog(@"getting order info error:%@", error.description);
            }
        }
    }];
}

- (void)cancelOrder
{
    [self startActivityIndicatorView];
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=order/myorder.jsp&v=1.0&client=iphone&vo.upkey=%@&method=secoo.orders.cancel&vo.orderId=%@", upKey, self.orderId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(DetailedOrderInfoViewController *) weakSelf = self;
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(DetailedOrderInfoViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.indicatorView stopAnimating];
                [strongSelf.indicatorView removeFromSuperview];
            });
            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showSuccess:@"成功取消订单" toView:strongSelf.view];
                            [strongSelf getDetailedInfomation];
                            [[OrderTypeAccessor sharedInstance] deletePayTypeForOrderId:[strongSelf.orderId integerValue]];
                            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(didCancelOrderId:)]) {
                                [strongSelf.delegate didCancelOrderId:strongSelf.orderId];
                            }
                        });
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:[jsonDict objectForKey:@"errMsg"] toView:strongSelf.view];
                        });
                    }
                }
                else{
                    NSLog(@"parsing order info error:%@", jsonError.description);
                }
            }
            else{
                NSLog(@"getting order info error:%@", error.description);
            }
        }
    }];
}

#pragma mark - 是否填写过转汇信息
- (void)getUserExchangeInfo
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=exchange/UserExchange.jsp&v=1.0&client=iphone&vo.upkey=%@&method=secoo.exchange.queryUserInfo", upKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(DetailedOrderInfoViewController*) weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil && data) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                if (weakSelf) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    _exchangeFinish = YES;
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //已经填过
                            _exchange = YES;
                        });
                    }
                    else if ([[jsonDict objectForKey:@"recode"] integerValue] == -1){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //没有填过
                            _exchange = NO;
                            if ([[self.orders objectForKey:@"areaType"] intValue] != 0) {
                                if (weakSelf.payButton) {
                                    [weakSelf.payButton removeTarget:weakSelf action:@selector(payForOrder:) forControlEvents:UIControlEventTouchUpInside];
                                    [weakSelf.payButton addTarget:self action:@selector(addExchangeInfo:) forControlEvents:UIControlEventTouchUpInside];
                                    [weakSelf.payButton setTitle:@"填写换汇信息" forState:UIControlStateNormal];
                                    [weakSelf.payButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
                                }
                            }
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


- (void)payForOrder:(UIButton *)sender
{
    //友盟统计
    [MobClick event:@"iOS_zhifu_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifu_uv"];
    
    [sender setTitle:@"连接中..." forState:UIControlStateNormal];
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url;
    if (self.mobilePayType == nil || [self.mobilePayType isEqualToString:@""]) {
        self.mobilePayType = @"5";
    }
    if ([self.mobilePayType isEqualToString:@"5"]) {
        //5 支付宝，4 微信 3 银联
        url = [NSString stringWithFormat:@"http://pay.secoo.com/b2c/alipay/alipaySDKPay.jsp?orderid=%@&upk=%@", self.orderId, upKey];
    }
    else if ([self.mobilePayType isEqualToString:@"4"]){
        url = [NSString stringWithFormat:@"http://pay.secoo.com/b2c/weixin/app/weixinAppPay.jsp?orderid=%@&upk=%@", self.orderId, upKey];
    }
    else if ([self.mobilePayType isEqualToString:@"3"]){
        
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(DetailedOrderInfoViewController *) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setTitle:@"去付款" forState:UIControlStateNormal];
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

- (void)addExchangeInfo:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExchangeRateInfoViewController *exchangeVC = [storyboard instantiateViewControllerWithIdentifier:@"ExchangeRateInfoViewController"];
    exchangeVC.delegate = self;
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

- (void)didProvideExchangeRateInfo
{
    if (self.payButton) {
        [self.payButton addTarget:self action:@selector(payForOrder:) forControlEvents:UIControlEventTouchUpInside];
        [self.payButton setTitle:@"去付款" forState:UIControlStateNormal];
        [self.payButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
}


- (void)handleOrderInfoResponse
{
    self.orders = [self.orderInfo objectForKey:@"orders"];
    self.orderTrack = [self.orderInfo objectForKey:@"orderTrack"];
    self.productArray = [self.orders objectForKey:@"products"];
    [self addOrderBasicInfoView];
}

#pragma mark - 加载视图
- (void)addOrderBasicInfoView
{
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    NSString *orderIdStr = [NSString stringWithFormat:@"%@", [self.orders objectForKey:@"orderId"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:(double)([[self.orders objectForKey:@"orderDate"] longLongValue]/1000)];
    NSString *orderDateStr = [formatter stringFromDate:orderDate];
    NSString *statusDesc = [self.orders objectForKey:@"statusDesc"];
    _enablePay = [[self.orders objectForKey:@"enablePay"] boolValue];
    /**************************************/
    UILabel *orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, 10, 0.6*(SCREEN_WIDTH-LEFT_INSERT*2), 20)];
    orderNumberLabel.backgroundColor = [UIColor clearColor];
    orderNumberLabel.font = [UIFont systemFontOfSize:12];
    orderNumberLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    orderNumberLabel.text = [NSString stringWithFormat:@"订单号:%@", orderIdStr];
    [self.scrollView addSubview:orderNumberLabel];
    
    UILabel *orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orderNumberLabel.frame), 10, 0.4*(SCREEN_WIDTH-LEFT_INSERT*2), 20)];
    orderStatusLabel.backgroundColor = [UIColor clearColor];
    orderStatusLabel.font = [UIFont systemFontOfSize:15];
    orderStatusLabel.textColor = [UIColor colorWithRed:8/255.0 green:162/255.0 blue:0 alpha:1];
    if (_enablePay) orderStatusLabel.textColor = [UIColor redColor];
    orderStatusLabel.textAlignment = NSTextAlignmentRight;
    orderStatusLabel.text = [NSString stringWithFormat:@"%@", statusDesc];
    [self.scrollView addSubview:orderStatusLabel];
    
    UIView *productsView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(orderNumberLabel.frame)+10, SCREEN_WIDTH-2*LEFT_INSERT, 0)];
    productsView.backgroundColor = [UIColor clearColor];
    productsView.layer.borderColor = [_LINE_COLOR_ CGColor];
    productsView.layer.borderWidth = 0.5;
    productsView.layer.cornerRadius = 5;
    [self.scrollView addSubview:productsView];
    
    int totalNumber = 0;
    _totalTax = 0;
    UIView *lastView = productsView;
    for (int i = 0; i < [self.productArray count]; ++i) {
        NSDictionary *product = [self.productArray objectAtIndex:i];
        NSString *productName = [product objectForKey:@"productName"];
        NSString *productImageURL = [self convertToRealUrl:[product objectForKey:@"pictureUrl"] ofsize:50];
        int productCount = [[product objectForKey:@"productCount"] intValue];
        float productPrice = [[product objectForKey:@"productPrice"] floatValue];
        float tax = [[product objectForKey:@"tax"] floatValue];
        
        totalNumber += productCount;
        _totalTax += tax;
        
        ProductView *productView = [[ProductView alloc] initWithFrame:CGRectMake(LEFT_INSERT, 5+80*i, productsView.frame.size.width-LEFT_INSERT*2, 70) imageUrl:productImageURL title:productName price:productPrice number:productCount color:nil size:nil empty:0 areaType:[[self.orders objectForKey:@"areaType"] intValue]];
        [productsView addSubview:productView];
        
        if (i > 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSERT, 0, productView.frame.size.width, 0.5)];
            lineView.backgroundColor = LINE_VIEW_COLOR;
            [productView addSubview:lineView];
        }
        
        CGRect frame = productsView.frame;
        frame.size.height = CGRectGetMaxY(productView.frame)+10;
        productsView.frame = frame;
        lastView = productsView;
    }
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame)+10, self.scrollView.frame.size.width - LEFT_INSERT*2, 20)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
    dateLabel.text = [NSString stringWithFormat:@"订单日期：%@", orderDateStr];
    [self.scrollView addSubview:dateLabel];
    
    UILabel *productCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame)+10, SCREEN_WIDTH, 20)];
    productCountLabel.backgroundColor = [UIColor clearColor];
    productCountLabel.font = [UIFont systemFontOfSize:15];
    productCountLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    productCountLabel.text = [NSString stringWithFormat:@"共%d件", totalNumber];
    [self.scrollView addSubview:productCountLabel];
    lastView = productCountLabel;
    
    if (_enablePay) {
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(SCREEN_WIDTH-100, CGRectGetMaxY(lastView.frame)+10, 90, 40);
        payButton.backgroundColor = [UIColor colorWithRed:238/255.0 green:134/255.0 blue:20/255.0 alpha:1];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payButton.layer.cornerRadius = 3;
        self.payButton = payButton;
        
        if (_exchangeFinish && !_exchange && [[self.orders objectForKey:@"areaType"] intValue] != 0) {
            [payButton addTarget:self action:@selector(addExchangeInfo:) forControlEvents:UIControlEventTouchUpInside];
            [payButton setTitle:@"填写换汇信息" forState:UIControlStateNormal];
            [payButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        } else {
            [payButton addTarget:self action:@selector(payForOrder:) forControlEvents:UIControlEventTouchUpInside];
            [payButton setTitle:@"去付款" forState:UIControlStateNormal];
            [payButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        }
        
        [self.scrollView addSubview:payButton];

        //去付款
        UILabel *payStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame)+10, SCREEN_WIDTH, 30)];
        payStatusLabel.backgroundColor = [UIColor clearColor];
        payStatusLabel.font = [UIFont systemFontOfSize:15];
        payStatusLabel.textColor = [UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1];
        payStatusLabel.text = @"下单后请在24小时内付款";
        [self.scrollView addSubview:payStatusLabel];
        lastView = payButton;
    }
    
    [self addOrderPriceInfoViewWithLastView:lastView];
}

- (void)addOrderPriceInfoViewWithLastView:(UIView *)view
{
    float amount = [[self.orders objectForKey:@"amount"] floatValue];
    float payableAmt = [[self.orders objectForKey:@"payableAmt"] floatValue];
    float freight = [[self.orders objectForKey:@"freight"] floatValue];
    int  areaType = [[self.orders objectForKey:@"areaType"] intValue];
    
    /**********************************************************************************************/
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(view.frame) + 10, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = LINE_VIEW_COLOR;
    [self.scrollView addSubview:lineView];
    UIView *lastView = lineView;

    UILabel *productPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame) + 5, SCREEN_WIDTH, 25)];
    productPriceLabel.backgroundColor = [UIColor clearColor];
    self.productPriceLabel = productPriceLabel;
    [self.scrollView addSubview:productPriceLabel];
    lastView = productPriceLabel;
    [self setProductPrice:amount];
    
    if (0 == areaType) {
        UILabel *favorableLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame), SCREEN_WIDTH, 25)];
        favorableLabel.backgroundColor = [UIColor clearColor];
        self.favorableLabel = favorableLabel;
        [self.scrollView addSubview:favorableLabel];
        lastView = favorableLabel;
        [self setFavorablePrice:20];
    }
    
    if (freight > 0) {
        UILabel *freightLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame), SCREEN_WIDTH, 25)];
        freightLabel.backgroundColor = [UIColor clearColor];
        self.freightLabel = freightLabel;
        [self.scrollView addSubview:freightLabel];
        lastView = freightLabel;
        [self setFreightLabelPrice:freight];
    }
    
    if (_totalTax > 0) {
        UILabel *taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame), SCREEN_WIDTH, 25)];
        taxLabel.backgroundColor = [UIColor clearColor];
        self.taxLabel = taxLabel;
        [self.scrollView addSubview:taxLabel];
        lastView = taxLabel;
        [self setTaxLabelPrice:_totalTax];
    }
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame), SCREEN_WIDTH, 25)];
    payLabel.backgroundColor = [UIColor clearColor];
    self.payLabel = payLabel;
    [self.scrollView addSubview:payLabel];
    [self setPayPrice:payableAmt];
    
    [self addOrderDeliverInfoViewWithLastView:payLabel];
}

- (void)addOrderDeliverInfoViewWithLastView:(UIView *)view
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(view.frame)+10, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = LINE_VIEW_COLOR;
    [self.scrollView addSubview:lineView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lineView.frame)+10, SCREEN_WIDTH, 25)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    self.consigneeNameLabel = nameLabel;
    [self.scrollView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(nameLabel.frame), SCREEN_WIDTH, 25)];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    self.consigneePhoneLabel = phoneLabel;
    [self.scrollView addSubview:phoneLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(phoneLabel.frame), SCREEN_WIDTH-LEFT_INSERT*2, 40)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    addressLabel.numberOfLines = 0;
    self.consigneeAddressLabel = addressLabel;
    [self.scrollView addSubview:addressLabel];
    UIView *lastView = addressLabel;
    
    [self setConsigneeName];
    [self setConsigneePhoneNumber];
    [self setConsigneeAddress];
    
    /*******************************************************/
    
    //发票信息
    if (0 != [[self.orders objectForKey:@"isInvoice"] intValue]) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame)+10, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LINE_VIEW_COLOR;
        [self.scrollView addSubview:lineView];
        
        UILabel *invoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lineView.frame)+10, SCREEN_WIDTH-LEFT_INSERT*2, 40)];
        invoiceLabel.backgroundColor = [UIColor clearColor];
        invoiceLabel.font = [UIFont systemFontOfSize:14];
        invoiceLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
        invoiceLabel.numberOfLines = 0;
        self.invoiceLabel = invoiceLabel;
        [self.scrollView addSubview:invoiceLabel];
        [self setInvoiceInfo];
        lastView = invoiceLabel;
    }
    
    //银行汇款信息
    if (3 == [[self.orders objectForKey:@"payMethod"] intValue]) {
        NSString *payDesc = [self.orders objectForKey:@"payDesc"];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lastView.frame)+10, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LINE_VIEW_COLOR;
        [self.scrollView addSubview:lineView];
        
        UILabel *payDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_INSERT, CGRectGetMaxY(lineView.frame)+10, SCREEN_WIDTH-LEFT_INSERT*2, 20)];
        payDescLabel.backgroundColor = [UIColor clearColor];
        payDescLabel.font = [UIFont systemFontOfSize: 14];
        payDescLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
        payDescLabel.numberOfLines = 0;
        payDescLabel.text = payDesc;
        [payDescLabel sizeToFit];
        [self.scrollView addSubview:payDescLabel];
        lastView = payDescLabel;
    }
    
    /*******************************************************/
    BOOL enableCancle = [[self.orders objectForKey:@"enableCancel"] boolValue];
    if (enableCancle) {
        //取消订单
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame)+10, SCREEN_WIDTH, (self.scrollView.frame.size.height > (CGRectGetMaxY(lastView.frame)+60))?(self.scrollView.frame.size.height-CGRectGetMaxY(lastView.frame)):60)];
        backgroundView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [self.scrollView addSubview:backgroundView];
        lastView = backgroundView;
        
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 40);
        cancleButton.backgroundColor = [UIColor clearColor];
        [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancleButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [[cancleButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
        cancleButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cancleButton.layer.borderWidth = 0.5;
        cancleButton.layer.cornerRadius = 5;
        [cancleButton addTarget:self action:@selector(handleCancelOrderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:cancleButton];
    }
    
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(lastView.frame))];
}

- (void)handleCancelOrderButtonAction:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要取消这个订单吗？" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"是的", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        //取消
    } else {
        [self cancelOrder];
    }
}

#pragma mark - 设置
- (void)setProductPrice:(float)price
{//商品金额
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"商品金额:  "];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", [self moneyTypeWithAreaType:[[self.orders objectForKey:@"areaType"] intValue] price:price]]];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    self.productPriceLabel.attributedText = attribute;
}

- (void)setFavorablePrice:(float)price
{//下单优惠
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"下单优惠:  "];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  ¥ -%.2f", price]];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    text = [[NSMutableAttributedString alloc] initWithString:@" (仅限APP端下单)"];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    self.favorableLabel.attributedText = attribute;
}

- (void)setFreightLabelPrice:(float)price
{//需付运费
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"需付运费:  "];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",[self moneyTypeWithAreaType:[[self.orders objectForKey:@"areaType"] intValue] price:price]]];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    self.freightLabel.attributedText = attribute;
}

- (void)setTaxLabelPrice:(float)price
{//需付关税
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"需付关税:  "];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", [self moneyTypeWithAreaType:[[self.orders objectForKey:@"areaType"] intValue] price:price]]];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    self.taxLabel.attributedText = attribute;
}

- (void)setRebateNumber:(int)num
{//返利库币
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"返利库币:  "];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  -%d库币", num]];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1/255.0 green:184/255.0 blue:0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    self.rebateLabel.attributedText = attribute;
}

- (void)setPayPrice:(float)price
{//应付金额
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"应付金额:  "];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", [self moneyTypeWithAreaType:[[self.orders objectForKey:@"areaType"] intValue] price:price]]];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:222/255.0 green:0 blue:0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    
    
    self.payLabel.attributedText = attribute;
}

- (void)setConsigneeName
{//收货人姓名
    NSString *name = [self.orders objectForKey:@"consigneeName"];
    self.consigneeNameLabel.text = [NSString stringWithFormat:@"收货人: %@", name];
}

- (void)setConsigneePhoneNumber
{//手机号码
    NSString *mobileNum = [self.orders objectForKey:@"mobileNum"];
    self.consigneePhoneLabel.text = [NSString stringWithFormat:@"电话: %@", mobileNum];
}

- (void)setConsigneeAddress
{//收货地址
    NSString *address = [self.orders objectForKey:@"provinceCity"];
    NSString *addressDetail = [self.orders objectForKey:@"address"];
    self.consigneeAddressLabel.text = [NSString stringWithFormat:@"地址: %@/%@", address, addressDetail];
    [self.consigneeAddressLabel sizeToFit];
}

- (void)setInvoiceInfo
{//发票信息
    NSString *invoiceType = [self.orders objectForKey:@"invoiceType"];
    NSString *invoiceMemo = [self.orders objectForKey:@"invoiceMemo"];
    NSString *info = [NSString stringWithFormat:@"发票抬头: %@\n发票内容: %@", invoiceType, invoiceMemo];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:info];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attribute.length)];
    self.invoiceLabel.attributedText = attribute;
    [self.invoiceLabel sizeToFit];
}

#pragma mark ---
- (NSString *)convertToRealUrl:(NSString *)url ofsize:(NSInteger)width
{
    if ([url hasPrefix:@"http://"]) {
        return url;
    }
    NSString *realURL = [[NSString alloc] initWithFormat:@"http://pic.secoo.com/product/%d/%d/%@", width, width, url];
    if (width > 700) {
        realURL = [[NSString alloc] initWithFormat:@"http://pic.secoo.com/product/%d/%d/%@", 700, 700, url];
    }
    return realURL;
}

#pragma mark - 返回币种
- (NSString *)moneyTypeWithAreaType:(int)areaType price:(float)price
{
    if (0 == areaType) {
        return [NSString stringWithFormat:@"¥ %.2f", price];
    } else if (1 == areaType) {
        return [NSString stringWithFormat:@"HK$ %.2f 港币", price];
    } else if (2 == areaType) {
        return [NSString stringWithFormat:@"$ %.2f 美元", price];
    } else if (3 == areaType) {
        return [NSString stringWithFormat:@"¥ %.2f 日元", price];
    } else if (4 == areaType) {
        return [NSString stringWithFormat:@"€ %.2f 欧元", price];
    } else if (5 == areaType) {
        return [NSString stringWithFormat:@"ƒ %.2f 法郎", price];
    }
    return [NSString stringWithFormat:@"%.2f", price];
}

- (void)handleAlipaySuccess:(NSNotification *)notification
{
    [MBProgressHUD showSuccess:@"支付成功!" toView:self.view];
    [self getDetailedInfomation];
    [[OrderTypeAccessor sharedInstance] deletePayTypeForOrderId:[self.orderId integerValue]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPayForOrderId:)]) {
        [self.delegate didPayForOrderId:self.orderId];
    }
}

- (void)handleAlipayFailed:(NSNotification *)notification
{
    [MBProgressHUD showError:@"支付失败!" toView:self.view];
}

- (void)handleAlipayNetworkProblem:(NSNotification *)notification
{
    [MBProgressHUD showError:@"您的网络连接出现问题！" toView:self.view];
}

@end
