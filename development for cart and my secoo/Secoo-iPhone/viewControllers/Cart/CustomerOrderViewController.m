//
//  CustomerOrderViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/24/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CustomerOrderViewController.h"
#import "TargetView.h"
#import "ProductView.h"
#import "UserInfoManager.h"
#import "CartItem.h"
#import "LGURLSession.h"
#import "DotLineView.h"
#import "CouponView.h"
#import "AddAddressViewController.h"
#import "AddressURLSession.h"
#import "AddressInfoView.h"
#import "AddressDataAccessor.h"
#import "OrderResultViewController.h"
#import "CouponViewController.h"
#import "CheckInfoView.h"
#import "CartItemAccessor.h"
#import "CartURLSession.h"
#import "CertificateManagedViewController.h"
#import "CheckCenterWarningView.h"
#import "DottedRectangleView.h"

#define _SPREAD_VIEW_TAG_                   123
#define _SPREAD_VIEW_SUB_TAG                456
#define _CHECKBUTTON_TAG_                   1024
#define _DELIVERINFOVIEW_TAG_               789

#define _DELIVER_TYPES_                     @"_deliver"
#define _PAYMENT_TYPES_                     @"_payment"
#define _INVOICE_TYPES_                     @"_invoice"

@interface CustomerOrderViewController ()<AddressInfoViewDelegate, CouponViewDelegate, UIScrollViewDelegate, CheckCenterWarnDelegate, CouponViewControllerDelegate>
{
    NSInteger _areaType;
    int       _selectDeliverIndex;
    int       _selectPayIndex;
    int       _selectInvoiceIndex;
    BOOL      _isGettingNewTotalPrice;
    BOOL      _didPressContinue;
    BOOL      _didPopWarning;
    BOOL      _didLoadResponse;
    double    _realTotalMoney;
    double    _depositMoney;
    BOOL      _express;
    BOOL      _selfDeliver;
    BOOL      _autoSubmitting;
    int       _currentAreaType;
    BOOL      _noAddress;
    BOOL      _firstTime;
    BOOL      _keyboardDidAppear;
}

@property(nonatomic, weak) MBProgressHUD *mbProgressHUD;//加载中

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invoiceHeightConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invoiceTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *paymentAndDepositLabel;

@property (weak, nonatomic) IBOutlet UIView *couponVIew;//使用优惠券
@property (weak, nonatomic) IBOutlet UIView *deliveryView;//配送方式
@property (weak, nonatomic) IBOutlet UIView *paymentView;//支付方式
@property (weak, nonatomic) IBOutlet UIView *invoiceView;//开具发票
@property (weak, nonatomic) IBOutlet UIView *productView;//商品标题
@property (weak, nonatomic) IBOutlet UIView *submitOrderView;

@property(nonatomic, weak) UIView *defaultDeliverView;//显示默认配货地址
@property(nonatomic, weak) UILabel *defaultAddressLabel;//自提
@property(nonatomic, weak) AddressView *defaultAddressView;//快递

@property (weak, nonatomic) IBOutlet TargetView *couponTargetView;//使用优惠券
@property (weak, nonatomic) IBOutlet TargetView *deliveryTargetView;//配送方式
@property (weak, nonatomic) IBOutlet TargetView *paymentTargetView;//支付方式
@property (weak, nonatomic) IBOutlet TargetView *invoiceTargetView;//开具发票
@property(nonatomic, strong) UIView *paymentCheckView;

@property(nonatomic, strong) NSArray        *showPayTypeArray;//需要展示的支付方式
@property(nonatomic, strong) NSMutableArray *allDeliversArray;//配送方式
@property(nonatomic, strong) NSMutableArray *allPayTypesArray;//支付方式
@property(nonatomic, strong) NSArray *coupons;//优惠券列表
@property(nonatomic, assign) int didGetCouponResponse; //0 获取中.. -1 获取有误 1 获取成功

@property(nonatomic, weak) CheckButton *expressCheckButton;//快递配送
@property(nonatomic, weak) CheckButton *toShopCheckButton;//到店自提
@property(nonatomic, weak) CheckButton *deliveryCheckButton;//货到付款
@property(nonatomic, weak) CheckButton *bankButton;//银行汇款
@property(nonatomic, weak) CheckButton *tempCheckButton;//临时存储需要选中的配货方式的checkButton

@property(nonatomic, copy) NSString *overseaContent;//海外商品展示的配送信息
@property(nonatomic, copy) NSString *couponPrice;//已选择的优惠券价钱
//结算
@property(nonatomic, weak) UILabel *priceLabel;//商品金额
@property(nonatomic, weak) UILabel *favorableLabel;//下单优惠
@property(nonatomic, weak) UILabel *couponPriceLabel;//使用优惠券
@property(nonatomic, weak) UILabel *bankLabel;//使用库币
@property(nonatomic, weak) UILabel *rebateLabel;//返利库币
@property(nonatomic, weak) UILabel *toChinaDeliverLabel;//运费
@property(nonatomic, weak) UILabel *taxLabel;//关税
@property(nonatomic, weak) UILabel *rmbServicePayLabel;//服务费

@property(nonatomic, weak) IBOutlet UIView   *paymentBackgroundView;//提交按钮的背景视图
@property(nonatomic, weak) IBOutlet UILabel  *paymentLabel;//应付金额
@property(nonatomic, weak) IBOutlet UIButton *submittButton;//提交订单
- (IBAction)submittOrders:(UIButton *)sender;//提交订单

//使用库币
@property(nonatomic, strong) NSString *kuCoinPasswrod;
@property(nonatomic, strong) NSString *kuCoinVerificaitonNumber;
@property(nonatomic, assign) NSInteger kuCoinNumber;
@property(nonatomic, weak)   UILabel *kuCoinNumberLabel;
//@property(nonatomic, weak)   UIButton *kuCoinButton;//使用库币按钮

@property(nonatomic, strong) NSString *selectedCouponID;

@property(nonatomic, assign) NSInteger didNeedInvoice;//发票
@property(nonatomic, strong) NSString *invoiceType;
@property(nonatomic, strong) NSString *invoiceMemo;

@property(nonatomic, strong) NSString *selectedDeliveryType;

@property(nonatomic, strong) NSString *selectedPayType;
@property(nonatomic, strong) NSString *selectedMobilePayType;
@property(nonatomic, strong) NSString *chooseWareHouseId;
@property(nonatomic, strong) NSString *selectedPayTaxType;///

@property(nonatomic, strong) NSString *shippingId;//收货地址id

@property(nonatomic, weak)   UITextField        *companyField;//发票 公司名字
@property(nonatomic, weak)   UITextField        *nameTextField;//到店自提填写姓名
@property(nonatomic, weak)   UITextField        *phoneTextField;//到店自提填写电话

@property(nonatomic, copy)   NSString           *userName;//到店自提  姓名
@property(nonatomic, copy)   NSString           *userPhone;//到点自提  电话


//选择
@property(nonatomic, assign) DeliverType        selectDeliverType;
@property(nonatomic, assign) MobilePayType      selectPayType;
@property(nonatomic, assign) InvoiceType        selectInvoiceType;

@property(nonatomic, weak) UIAlertView *soldAllOutAlertView;

@end

@implementation CustomerOrderViewController

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
    self.title = @"确认下单";
    
    self.selectedPayTaxType = @"0";
    self.couponPrice = nil;
    _selectDeliverIndex = -1;
    _didNeedInvoice = -1;
    _didPressContinue = NO;
    _express = NO;
    _selfDeliver = NO;
    _autoSubmitting = NO;
    _noAddress = NO;
    _firstTime = YES;
    _keyboardDidAppear = NO;
    self.submittButton.layer.cornerRadius = 3;

    AddressURLSession *session = [[AddressURLSession alloc] init];
    [session upDateAddress];

    CGFloat height = CGRectGetMaxY(self.submitOrderView.frame);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    
    [self setTotalPriceAndDeposit];
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    if (!_IOS_7_LATER_) {
        [self customPaymentBackgroundViewWithIOS6];
    }
    
    _currentAreaType = [[[self.productArray firstObject] objectForKey:@"areaType"] intValue];
    
    {
        self.couponTargetView.titleLabel.text = @"使用优惠";
        self.couponTargetView.descriptionLabel.text = @"选择优惠券";
        [self.couponTargetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
        [self.couponTargetView addTarget:self action:@selector(handleCouponTargetViewAction:)];
        
        self.deliveryTargetView.titleLabel.text = @"配送方式";
        self.deliveryTargetView.descriptionLabel.text = @"选择配送方式";
        [self.deliveryTargetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
        [self.deliveryTargetView addTarget:self action:@selector(handleDeliveryTargetViewAction:)];
        
        self.paymentTargetView.titleLabel.text = @"支付方式";
        self.paymentTargetView.descriptionLabel.text = @"选择支付方式";
        [self.paymentTargetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
        [self.paymentTargetView addTarget:self action:@selector(handlePaymentTargetViewAction:)];
        
        if (0 == _currentAreaType) {
            self.invoiceTargetView.titleLabel.text = @"开具发票";
            self.invoiceTargetView.descriptionLabel.text = @"否";
            [self.invoiceTargetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
            [self.invoiceTargetView addTarget:self action:@selector(handleInvoiceTargetViewAction:)];
        } else {
            [self.invoiceTargetView removeFromSuperview];
            [self setInvoiceViewHeight:0];
        }
    }
    
    //[self getCheckoutResponse];
    [self setProductsView];
    [self setPriceLabels];
    self.didGetCouponResponse = 0;
    [self getAvailabelCouponsForCart];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddressChange:) name:AddressDataDidChangeNotification object:[AddressDataAccessor sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    self.allDeliversArray = [NSMutableArray array];
    self.allPayTypesArray = [NSMutableArray array];
    for (int i = 0; i < [self.payAndDeliver count]; ++i) {
        NSDictionary *dic = [self.payAndDeliver objectAtIndex:i];
        NSDictionary *deliver = [dic objectForKey:@"deliver"];
        NSArray *payTypes = [dic objectForKey:@"payTypes"];
        [self.allDeliversArray addObject:deliver];
        [self.allPayTypesArray addObject:payTypes];
    }
    
    NSLog(@"alleliversArray %@", self.allDeliversArray);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CustomerOrder"];
    
    AddressEntity *address = [[AddressDataAccessor sharedInstance] getDefaulAddress];
    if (address) {
        self.userName = address.consigneeName;
        self.userPhone = address.mobileNum;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CustomerOrder"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_firstTime) {
        [self setDeliverAddressView];
        [self getCheckoutResponseAndShowWarning:NO forAvailable:_forAvailable];
        [self.view performSelector:@selector(setNeedsLayout) withObject:nil afterDelay:1.0];
    }
    _firstTime = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!_IOS_8_LATER_) {
        CGFloat height = CGRectGetMaxY(self.submitOrderView.frame);
        //NSLog(@"layout: %f", height);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    }
}

- (void)customPaymentBackgroundViewWithIOS6
{//适配iOS6
    [self.paymentBackgroundView removeFromSuperview];
    UIView *paymentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64-44, SCREEN_WIDTH, 64)];
    paymentBackgroundView.backgroundColor = [UIColor whiteColor];
    self.paymentBackgroundView = paymentBackgroundView;
    [self.view addSubview:paymentBackgroundView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:198/255.0 alpha:1];
    [self.paymentBackgroundView addSubview:lineView];
    
    UILabel *paymentAndDepositLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, SCREEN_WIDTH-20, 18)];
    paymentAndDepositLabel.backgroundColor = [UIColor clearColor];
    paymentAndDepositLabel.font = [UIFont systemFontOfSize:14];
    paymentAndDepositLabel.textColor = [UIColor colorWithWhite:68/255.0 alpha:1];
    paymentAndDepositLabel.text = @"应付金额";
    self.paymentAndDepositLabel = paymentAndDepositLabel;
    [self.paymentBackgroundView addSubview:paymentAndDepositLabel];
    
    UILabel *paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(paymentAndDepositLabel.frame), CGRectGetMaxY(paymentAndDepositLabel.frame)+3, CGRectGetWidth(paymentAndDepositLabel.frame), 21)];
    paymentLabel.backgroundColor = [UIColor clearColor];
    paymentLabel.font = [UIFont systemFontOfSize:19];
    paymentLabel.textColor = [UIColor colorWithRed:222/255.0 green:0 blue:0 alpha:1];
    self.paymentLabel = paymentLabel;
    [self.paymentBackgroundView addSubview:paymentLabel];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(self.paymentBackgroundView.frame.size.width-140, 12, 130, 40);
    submitButton.backgroundColor = MAIN_YELLOW_COLOR;
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    submitButton.layer.cornerRadius = 3;
    self.submittButton = submitButton;
    [submitButton addTarget:self action:@selector(submittOrders:) forControlEvents:UIControlEventTouchUpInside];
    [self.paymentBackgroundView addSubview:submitButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.isBuyNow) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.managedObjectContext deleteObject:[self.cartItems objectAtIndex:0]];
        [[CartItemAccessor sharedInstance] deleteObjectWithProductId:self.buyNowProductId];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置默认地址
- (void)setDeliverAddressView
{
    [self deliverViewAction];
    return;
    /**********************************************************************/
    NSString *defaultDeliverType = [UserInfoManager getLastTimeDeliverType];
    if (defaultDeliverType && ![defaultDeliverType isEqualToString:@""]) {
        for (int i = 0; i < [self.payAndDeliver count]; ++i) {
            NSDictionary *dic = [self.payAndDeliver objectAtIndex:i];
            NSDictionary *deliver = [dic objectForKey:@"deliver"];
            NSString *deliverType = [NSString stringWithFormat:@"%@", [deliver objectForKey:@"deliverType"]];
            NSString *payTaxType  = [deliver objectForKey:@"payTaxType"];
            if ([defaultDeliverType isEqualToString:deliverType]) {
                if ([defaultDeliverType isEqualToString:@"1"]) {
                    //快递
                    AddressEntity *addressInfo = [[AddressDataAccessor sharedInstance] getDefaulAddress];
                    if (addressInfo) {
                        [self setUpDefaultAddressInfoViewWithInfo:addressInfo];
                        self.shippingId = [NSString stringWithFormat:@"%lld", addressInfo.addressId];
                        self.showPayTypeArray = [dic objectForKey:@"payTypes"];
                        self.deliveryTargetView.descriptionLabel.text = @"快递送货";
                    }
                } else {
                    //自提
                    if (deliver) {
                        [self setUpDefaultAddressInfoViewWithInfo:deliver];
                        self.chooseWareHouseId = [NSString stringWithFormat:@"%@", [[deliver objectForKey:@"otherParams"] objectForKey:@"chooseWarehouseId"]];
                        self.showPayTypeArray = [dic objectForKey:@"payTypes"];
                        self.deliveryTargetView.descriptionLabel.text = @"到店自提";
                    }
                }
                self.selectedDeliveryType = defaultDeliverType;
                if (payTaxType && ![payTaxType isEqualToString:@""]) {
                    self.selectedPayTaxType = payTaxType;
                } else {
                    self.selectedPayTaxType = @"0";
                }
                
                //默认支付方式
                NSString *defaultMobilePaytype = [UserInfoManager getLastTimeMobilePaytype];
                for (int i = 0; i < [self.showPayTypeArray count]; i++) {
                    NSDictionary *payTypeDic = [self.showPayTypeArray objectAtIndex:i];
                    NSString *payType = [NSString stringWithFormat:@"%@",[payTypeDic objectForKey:@"payType"]];
                    NSString *mobilePayType = [NSString stringWithFormat:@"%@", [payTypeDic objectForKey:@"mobilePayType"]];
                    if ([mobilePayType isEqualToString:defaultMobilePaytype]) {
                        NSString *label = [payTypeDic objectForKey:@"label"];
                        self.paymentTargetView.descriptionLabel.text = label;
                        _selectPayIndex = i;
                        self.selectedPayType = payType;
                        self.selectedMobilePayType = mobilePayType;
                        break;
                    }
                }
                [self updatePaymentCheckView];
                break;
            }
        }
    }
    
    if (self.defaultDeliverView && self.defaultDeliverView.frame.size.height > 0) {
        [[(DeliverInfoView *)[self.defaultDeliverView viewWithTag:_DELIVERINFOVIEW_TAG_] checkButton] setChecked:YES];
        [self setDeliveryViewHeight:CGRectGetMaxY(self.defaultDeliverView.frame) + 10];
    } else {
        [self.defaultDeliverView removeFromSuperview];
        [self setDeliveryViewHeight:44];
    }
}

- (void)deliverViewAction
{
    BOOL isCanPickUp = NO, isCanExpress = NO;
    for (int i = 0; i < [self.payAndDeliver count]; ++i) {
        NSDictionary *dic = [self.payAndDeliver objectAtIndex:i];
        NSDictionary *deliver = [dic objectForKey:@"deliver"];
        NSString *deliverType = [NSString stringWithFormat:@"%@", [deliver objectForKey:@"deliverType"]];
        NSString *payTaxType  = [deliver objectForKey:@"payTaxType"];
        
        if ([deliverType isEqualToString:@"1"]) {
            isCanExpress = YES;
            self.showPayTypeArray = [dic objectForKey:@"payTypes"];
            if (payTaxType && ![payTaxType isEqualToString:@""]) {
                self.selectedPayTaxType = payTaxType;
            } else {
                self.selectedPayTaxType = @"0";
            }
            self.selectedDeliveryType = @"1";
            break;
        } else {
            isCanPickUp = YES;
        }
    }
    
    if (isCanExpress) {
        //快递
        AddressEntity *addressInfo = [[AddressDataAccessor sharedInstance] getDefaulAddress];
        if (addressInfo) {
            [self setUpDefaultAddressInfoViewWithInfo:addressInfo];
            self.shippingId = [NSString stringWithFormat:@"%lld", addressInfo.addressId];
            self.deliveryTargetView.descriptionLabel.text = @"快递送货";
        }
    } else if (isCanPickUp) {
        //自提
        NSDictionary *deliver = [self.allDeliversArray firstObject];
        self.showPayTypeArray = [self.allPayTypesArray firstObject];
        
        NSString *payTaxType  = [deliver objectForKey:@"payTaxType"];
        if (payTaxType && ![payTaxType isEqualToString:@""]) {
            self.selectedPayTaxType = payTaxType;
        } else {
            self.selectedPayTaxType = @"0";
        }
        self.selectedDeliveryType = [NSString stringWithFormat:@"%@", [deliver objectForKey:@"deliverType"]];

        [self setUpDefaultAddressInfoViewWithInfo:deliver];
        self.chooseWareHouseId = [NSString stringWithFormat:@"%@", [[deliver objectForKey:@"otherParams"] objectForKey:@"chooseWarehouseId"]];
        self.deliveryTargetView.descriptionLabel.text = @"到店自提";
    } else {
        
    }
    
    //默认支付方式
    BOOL canCashOfDelivery = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"canCashOfDelivery"] boolValue];
    self.paymentTargetView.descriptionLabel.text = @"选择支付方式";
    NSString *defaultMobilePaytype = [UserInfoManager getLastTimeMobilePaytype];
    for (int i = 0; i < [self.showPayTypeArray count]; i++) {
        NSDictionary *payTypeDic = [self.showPayTypeArray objectAtIndex:i];
        NSString *payType = [NSString stringWithFormat:@"%@",[payTypeDic objectForKey:@"payType"]];
        NSString *mobilePayType = [NSString stringWithFormat:@"%@", [payTypeDic objectForKey:@"mobilePayType"]];
        if ([mobilePayType isEqualToString:defaultMobilePaytype]) {
            if (!(DelivePayType == [mobilePayType intValue] && !canCashOfDelivery)) {
                NSString *label = [payTypeDic objectForKey:@"label"];
                self.paymentTargetView.descriptionLabel.text = label;
                _selectPayIndex = i;
                self.selectedPayType = payType;
                self.selectedMobilePayType = mobilePayType;
                break;
            }
            
        }
    }
    [self updatePaymentCheckView];
    
    if (self.defaultDeliverView && self.defaultDeliverView.frame.size.height > 0) {
        [[(DeliverInfoView *)[self.defaultDeliverView viewWithTag:_DELIVERINFOVIEW_TAG_] checkButton] setChecked:YES];
        [self setDeliveryViewHeight:CGRectGetMaxY(self.defaultDeliverView.frame) + 10];
    } else {
        [self.defaultDeliverView removeFromSuperview];
        [self setDeliveryViewHeight:44];
    }
    
    //如果只支持到店自提 或者 没有地址 展开
    AddressEntity *addressEntity = [[AddressDataAccessor sharedInstance] getDefaulAddress];
    if ((!isCanExpress && isCanPickUp) || !addressEntity) {
        [self handleDeliveryTargetViewAction:[self.deliveryTargetView.gestureRecognizers firstObject]];
    }
}

#pragma mark - 显示选中地址视图
- (void)setUpDefaultAddressInfoViewWithInfo:(id)info
{
    [self.defaultDeliverView removeFromSuperview];
    UIView *defaultDeliverView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.deliveryTargetView.frame), self.deliveryView.frame.size.width - 20, 50)];
    defaultDeliverView.backgroundColor = [UIColor clearColor];
    self.defaultDeliverView = defaultDeliverView;
    [self.deliveryView addSubview:defaultDeliverView];
    [self.deliveryView sendSubviewToBack:defaultDeliverView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
    [defaultDeliverView addSubview:lineView];
    
    UIView *lastView = nil;
    if ([info isKindOfClass:[AddressEntity class]]) {
        //快递配送
        AddressEntity *dic = (AddressEntity *)info;
        NSString *name = dic.consigneeName;
        NSString *phoneNumber = dic.mobileNum;
        NSString *address = [NSString stringWithFormat:@"%@/%@", dic.provinceCityDistrict, dic.address];
        DeliverInfoView *deliverInfoView = [[DeliverInfoView alloc] initWithFrame:CGRectMake(5, 10, self.defaultDeliverView.frame.size.width-10, 100) name:name phone:phoneNumber address:address groupId:@"AddressCheckButton" info:dic delegate:nil];
        deliverInfoView.tag = _DELIVERINFOVIEW_TAG_;
        deliverInfoView.userInteractionEnabled = NO;
        [self.defaultDeliverView addSubview:deliverInfoView];
        lastView = deliverInfoView;
    } else {
        //到店自提
        NSDictionary *dic = (NSDictionary *)info;
        NSString *name = [dic objectForKey:@"name"];
        NSString *phoneNumber = [dic objectForKey:@"tel"];
        NSString *address = [NSString stringWithFormat:@"%@", [dic objectForKey:@"address"]];
        DeliverInfoView *deliverInfoView = [[DeliverInfoView alloc] initWithFrame:CGRectMake(5, 10, self.defaultDeliverView.frame.size.width-10, 100) name:name phone:phoneNumber address:address groupId:@"AddressCheckButton" info:dic delegate:nil];
        deliverInfoView.tag = _DELIVERINFOVIEW_TAG_;
        deliverInfoView.userInteractionEnabled = NO;
        [self.defaultDeliverView addSubview:deliverInfoView];
        lastView = deliverInfoView;
    }
    
    if (lastView) {
        CGRect frame = self.defaultDeliverView.frame;
        frame.size.height = CGRectGetMaxY(lastView.frame);
        self.defaultDeliverView.frame = frame;
    }
}

- (void)setTotalPriceAndDeposit
{
    _realTotalMoney = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"rmbRealCurrentTotalPrice"] doubleValue];
//    double realCurrentPrice = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"realCurrentTotalPrice"] doubleValue];
//    double  realPrice = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"realTotalPrice"] doubleValue];
    BOOL isDeposit = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"isDeposit"] boolValue];
    
    if (!isDeposit) {
        _depositMoney = 0;
    }
    else{
        _depositMoney = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"rmbRealCurrentTotalPrice"] doubleValue];
    }
}

- (void)setProductsView
{
    for (UIView *view in [self.productView subviews]) {
        [view removeFromSuperview];
    }
    [self setProductViewHeight:0];
    
    for (int i = 0; i < self.productArray.count; i++) {
        NSDictionary *product = [self.productArray objectAtIndex:i];
        NSString *imageUrl = [self convertToRealUrl:[product objectForKey:@"image"] ofsize:80];
        NSString *name = [product objectForKey:@"name"];
        float price = [[product objectForKey:@"secooPrice"] floatValue];
        int empty = [[product objectForKey:@"inventoryStatus"] intValue];
        int number = [[product objectForKey:@"quantity"] intValue];

        NSString *color = nil;
        NSString *size = nil;
        
        NSString *productId = [NSString stringWithFormat:@"%@", [product objectForKey:@"productId"]];
        for (CartItem *cartItem in self.cartItems) {
            if ([cartItem.productId isEqualToString:productId]) {
                color = cartItem.color;
                size = cartItem.size;
                number = cartItem.availableAmount;
                break;
            }
        }
        
        ProductView *productInfoView = [[ProductView alloc] initWithFrame:CGRectMake(10, 80*i, SCREEN_WIDTH-20, 80) imageUrl:imageUrl title:name price:price number:number color:color size:size empty:empty areaType:0];
        [self.productView addSubview:productInfoView];
        
        if (i > 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10, 0.5)];
            lineView.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
            [productInfoView addSubview:lineView];
        }
        [self setProductViewHeight:CGRectGetMaxY(productInfoView.frame)+10];
    }
}

- (void)setPriceLabels
{
    for (UIView *view in [self.submitOrderView subviews]) {
        [view removeFromSuperview];
    }
    
    double realTotalPrice = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"rmbRealCurrentTotalPrice"] doubleValue];
    self.paymentLabel.text = [NSString stringWithFormat:@"¥ %.2f", (float)realTotalPrice];

    
    if (!(0 == _currentAreaType || 2 == _currentAreaType)) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.submitOrderView.frame.size.width, 20)];
        backgroundView.backgroundColor = self.scrollView.backgroundColor;
        [self.submitOrderView addSubview:backgroundView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, backgroundView.frame.size.width, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        [backgroundView addSubview:label];
        [self setOrderViewHeight:CGRectGetMaxY(backgroundView.frame)];
        
        if (1 == _currentAreaType) {
            label.text = @"应付金额 = 港币价总金额 * 汇率";
        } else if (3 == _currentAreaType) {
            label.text = @"应付金额 = 日元价总金额 * 汇率";
        } else if (4 == _currentAreaType) {
            label.text = @"应付金额 = 欧元价总金额 * 汇率";
        } else {
            [backgroundView removeFromSuperview];
            [self setOrderViewHeight:0];
        }
    } else {
        double totalSecooPrice = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"rmbTotalSecooPrice"] doubleValue];
        long subtractAmount = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"subtractAmount"] longValue];
        int kuPay = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"kuPay"] intValue];
        int rebateValue = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"rateValues"] intValue];
        float tax = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"tax"] floatValue];
        float rmbServicePay = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"rmbServicePay"] floatValue];
        
        BOOL isDeposit = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"isDeposit"] boolValue];
        if (isDeposit) {
            self.paymentAndDepositLabel.text = @"应付定金";
        }
        else{
            self.paymentAndDepositLabel.text = @"应付金额";
        }
        
        float toChinaDeliverFee = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"rmbDeliverFee"] floatValue];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.submitOrderView.frame.size.width, 20)];
        backgroundView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [self.submitOrderView addSubview:backgroundView];
        
        UIView *lastView = nil;
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, backgroundView.frame.size.width - 10, 20)];
        priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel = priceLabel;
        [backgroundView addSubview:priceLabel];
        [self setTotalPrice:(float)totalSecooPrice];
        lastView = priceLabel;
        
        if (subtractAmount > 0) {//下单优惠
            UILabel *favorableLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lastView.frame), CGRectGetMaxY(lastView.frame), CGRectGetWidth(lastView.frame), 20)];
            favorableLabel.backgroundColor = [UIColor clearColor];
            self.favorableLabel = favorableLabel;
            [backgroundView addSubview:favorableLabel];
            [self setFavorablePrice:subtractAmount];
            lastView = favorableLabel;
        }
        
        if ([self.couponPrice floatValue] > 0) {//使用优惠券
            UILabel *couponPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lastView.frame), CGRectGetMaxY(lastView.frame), CGRectGetWidth(lastView.frame), 20)];
            couponPriceLabel.backgroundColor = [UIColor clearColor];
            self.couponPriceLabel = couponPriceLabel;
            [backgroundView addSubview:couponPriceLabel];
            [self setCouponLabelPrice:[self.couponPrice floatValue]];
            lastView = couponPriceLabel;
        }
        
        if (kuPay > 0) {//使用库币
            UILabel *bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lastView.frame), CGRectGetMaxY(lastView.frame), CGRectGetWidth(lastView.frame), 20)];
            bankLabel.backgroundColor = [UIColor clearColor];
            self.bankLabel = bankLabel;
            [backgroundView addSubview:bankLabel];
            [self setBankPrice:kuPay];
            lastView = bankLabel;
        }
        
        if (rebateValue > 0) {//返利库币
            UILabel *rebateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lastView.frame), CGRectGetMaxY(lastView.frame), CGRectGetWidth(lastView.frame), 20)];
            rebateLabel.backgroundColor = [UIColor clearColor];
            self.rebateLabel = rebateLabel;
            [backgroundView addSubview:rebateLabel];
            [self setRebatePrice:rebateValue];
            lastView = rebateLabel;
        }
        
        if (toChinaDeliverFee > 0) {//运费
            UILabel *toChinaDeliverLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lastView.frame), CGRectGetMaxY(lastView.frame), CGRectGetWidth(lastView.frame), 20)];
            toChinaDeliverLabel.backgroundColor = [UIColor clearColor];
            self.toChinaDeliverLabel = toChinaDeliverLabel;
            [backgroundView addSubview:toChinaDeliverLabel];
            [self setDeliverPrice:toChinaDeliverFee];
            lastView = toChinaDeliverLabel;
        }
        
        if (tax > 0) {//关税
            UILabel *taxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lastView.frame), CGRectGetMaxY(lastView.frame), CGRectGetWidth(lastView.frame), 20)];
            taxLabel.backgroundColor = [UIColor clearColor];
            self.taxLabel = taxLabel;
            [backgroundView addSubview:taxLabel];
            [self setTaxPrice:tax];
            lastView = taxLabel;
        }
        
        if (rmbServicePay > 0) {//服务费
            UILabel *rmbServicePayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lastView.frame), CGRectGetMaxY(lastView.frame), CGRectGetWidth(lastView.frame), 20)];
            rmbServicePayLabel.backgroundColor = [UIColor clearColor];
            self.rmbServicePayLabel = rmbServicePayLabel;
            [backgroundView addSubview:rmbServicePayLabel];
            [self setServicePayPrice:rmbServicePay];
            lastView = rmbServicePayLabel;
        }
        
        //美国
        if (2 == _currentAreaType) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lastView.frame), CGRectGetMaxY(lastView.frame)+10, CGRectGetWidth(lastView.frame), 20)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 0;
            label.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
            label.text = @"应付金额 = 美元价总金额 * 汇率 + 运费";
            [label sizeToFit];
            [backgroundView addSubview:label];
            lastView = label;
        }
        
        if (lastView) {
            CGRect frame = backgroundView.frame;
            frame.size.height = CGRectGetMaxY(lastView.frame) + 10;
            backgroundView.frame = frame;
        }
        [self setOrderViewHeight:CGRectGetMaxY(backgroundView.frame)];
    }
}

//商品金额
- (void)setTotalPrice:(float)price
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"商品金额: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f", price]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.priceLabel.attributedText = attribute;
}

//下单优惠
- (void)setFavorablePrice:(float)price
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"下单优惠: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ -%.2f",price]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    text = [[NSMutableAttributedString alloc] initWithString:@" (仅限APP端下单)"];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    self.favorableLabel.attributedText = attribute;
}

//使用优惠券
- (void)setCouponLabelPrice:(float)price
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"  优惠券 : "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ -%.2f", price]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.couponPriceLabel.attributedText = attribute;
}

//使用库币
- (void)setBankPrice:(int)number
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"使用库币: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"- %d库币", number]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1/255.0 green:184/255.0 blue:0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.bankLabel.attributedText = attribute;
}

//返利
- (void)setRebatePrice:(int)number
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"返利库币: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+ %d库币", number]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1/255.0 green:184/255.0 blue:0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.rebateLabel.attributedText = attribute;
}

//运费
- (void)setDeliverPrice:(float)price
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"需付运费: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f", price]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.toChinaDeliverLabel.attributedText = attribute;
}

//关税
- (void)setTaxPrice:(float)price
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"需付关税: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f", price]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.taxLabel.attributedText = attribute;
}

//服务费
- (void)setServicePayPrice:(float)price
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"服务费用: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f", price]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.rmbServicePayLabel.attributedText = attribute;
}

#pragma mark --
#pragma mark -- network --
- (void)getTotalKuCoins
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=account/myaccount.jsp&v=1.0&client=iphone&method=secoo.user.getBalanceInfo&vo.upkey=%@&fields=txBalance,xfBalance,zjBalance", upKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(CustomerOrderViewController *) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(CustomerOrderViewController*) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] intValue] == 0) {
                        NSDictionary *kuCoinDict = [jsonDict objectForKey:@"balanceInfo"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *kuCoinNumber = [NSString stringWithFormat:@"%@库币",[kuCoinDict objectForKey:@"zjBalance"]];
                            if ([kuCoinNumber integerValue] == 0) {
                                
                            }
                        });
                    }
                }
                else{
                    NSLog(@"parsing error");
                }
            }
            else{
                NSLog(@"getting total kucoins error:%@", error.description);
            }
        }
    }];
}

#pragma mark - 获取优惠券
- (void)getAvailabelCouponsForCart
{
    NSString *productInfo = [self getProductInfoString];
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=order/myorder.jsp&v=1.0&client=iphone&method=getAvailableTicketList&vo.upkey=%@&vo.currPage=1&vo.pageSize=6&vo.ticketType=0&cart=%@&areaType=%d&order=overdueTime[asc]", [upKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], productInfo, _areaType];
    
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(CustomerOrderViewController*) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil && data) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                    NSArray *coupons = [jsonDict objectForKey:@"ticketList"];
                    weakSelf.coupons = coupons;
                    weakSelf.didGetCouponResponse = 1;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (coupons.count == 0) {
                            weakSelf.couponTargetView.descriptionLabel.text = @"无可用优惠券";
                            [weakSelf.couponTargetView.targetButton setImage:nil forState:UIControlStateNormal];
                            [weakSelf.couponTargetView addTarget:nil action:nil];
                        } else {
                            weakSelf.couponTargetView.iconImageView.image = _IMAGE_WITH_NAME(@"couponIcon");
                            CGRect frame = self.couponTargetView.iconImageView.frame;
                            CGSize size = [Utils getSizeOfString:weakSelf.couponTargetView.descriptionLabel.text ofFont:[UIFont systemFontOfSize:15] withMaxWidth:300];
                            frame.origin.x = self.couponTargetView.frame.size.width - self.couponTargetView.targetButton.frame.size.width - size.width - frame.size.width - 5;
                            [UIView animateWithDuration:.3f animations:^{
                                weakSelf.couponTargetView.iconImageView.frame = frame;
                            }];
                            [weakSelf handleCouponTargetViewAction:[weakSelf.couponTargetView.gestureRecognizers firstObject]];
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.didGetCouponResponse = -1;
                    });
                    NSLog(@"error occurred during getting coupons:%@", [jsonDict objectForKey:@"errMsg"]);
                }
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.didGetCouponResponse = -1;
            });
            NSLog(@"get coupons error: %@", error.description);
        }
    }];
}

- (void)getCheckoutResponseAndShowWarning:(BOOL)willShow forAvailable:(BOOL)forAvailable
{
    NSString *productInfo = [self getProductInfoStringWithCouponOrKuCoin:forAvailable];
    if (productInfo == nil) {
        return;
    }
    _isGettingNewTotalPrice = YES;
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/cartshowconfirm.action?upkey=%@&cart=%@&areaType=%d", [upKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], productInfo, _areaType];
    
    __weak typeof(CustomerOrderViewController *) weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(CustomerOrderViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _isGettingNewTotalPrice = NO;
            });
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *receiveDic = (NSDictionary *)jsonResponse;
                        NSDictionary *rp_result = [receiveDic objectForKey:@"rp_result"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            int resultCode = [[rp_result objectForKey:@"recode"] intValue];
                            if (0 == resultCode) {
                                strongSelf.jsonDictionary = rp_result;
                                strongSelf.productArray = [[rp_result objectForKey:@"cart"] objectForKey:@"cartItems"];
                                strongSelf.payAndDeliver = [rp_result objectForKey:@"payAndDeliver"];
                                [strongSelf setTotalPriceAndDeposit];
                                [strongSelf setProductsView];
                                [strongSelf setPriceLabels];
                                if (_didPressContinue) {
                                    _didPressContinue = NO;
                                    _autoSubmitting = YES;
                                    [strongSelf submittOrders:nil];
                                }
                                else if (_didPopWarning){
                                    _didPopWarning = NO;
                                    _didLoadResponse = YES;
                                }
                                
                                
                            }
                            else if (resultCode == 524){
                                //verification of coupons failed
                                [MBProgressHUD showError:[rp_result objectForKey:@"errMsg"] toView:strongSelf.view];
                            }
                            else if (resultCode == 525){
                                //coupons and kuCoin can not be used at the same time
                                [MBProgressHUD showError:[rp_result objectForKey:@"errMsg"] toView:strongSelf.view];
                            }
                        });
                    }
                }
            }
            else{
                NSLog(@"check our cart error: %@", error.description);
            }
        }
    }];
}

#pragma mark --
#pragma mark -- Utilities --

- (NSString *)getProductInfoStringWithCouponOrKuCoin:(BOOL)forAvailable
{
//    if (!forAvailable) {
//        if ((self.kuCoinNumber <= 0 || self.kuCoinPasswrod == nil || self.kuCoinVerificaitonNumber == nil) && self.selectedCouponID == nil) {
//            return nil;
//        }
//    }
    NSString *productInfo;
    for (CartItem *cartItem in self.cartItems) {
        NSInteger num = cartItem.quantity;
        if (forAvailable) {
            num = cartItem.availableAmount;
            if (num == 0 || cartItem.inventoryStatus == 2) {
                continue;
            }
        }
        NSString *proInfo = [NSString stringWithFormat:@"{\"productId\":%@,\"quantity\":%d,\"type\":%d,\"areaType\":%hd}",cartItem.productId, num, 0, cartItem.areaType];
        if (productInfo == nil) {
            productInfo = proInfo;
            _areaType = cartItem.areaType;
        }
        else{
            productInfo = [NSString stringWithFormat:@"%@,%@", productInfo, proInfo];
        }
    }
    productInfo = [[NSString stringWithFormat:@"\"cartItems\":[%@]", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AddressEntity *addressEntity = [[AddressDataAccessor sharedInstance] getDefaulAddress];
    if (addressEntity) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"shippingId\":\"%lld\"", addressEntity.addressId]];
    }
    
    if ((self.kuCoinNumber > 0 && self.kuCoinPasswrod && self.kuCoinVerificaitonNumber)) {
        NSString *kuCoinStr = [NSString stringWithFormat:@",\"isUseBalance\":1,\"payPassword\":\"%@\",\"phoneValidateNum\":\"%@\",\"useBalanceAmount\":\"%d\"", self.kuCoinPasswrod, self.kuCoinVerificaitonNumber, self.kuCoinNumber];
        productInfo = [productInfo stringByAppendingString:kuCoinStr];
    }
    if (self.selectedCouponID) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"ticketId\":\"%@\"", self.selectedCouponID]];
    }
    ///////////////////////
//    if (self.didNeedInvoice <= 0) {
//        NSString *invoiceStr = @",\"isInvoice\":0,\"invoiceType\":\"\",\"invoiceMemo\":\"\"";
//        productInfo = [productInfo stringByAppendingString:invoiceStr];
//    }
//    else if (self.didNeedInvoice > 1){
//        NSString *invoiceStr = [NSString stringWithFormat:@",\"isInvoice\":1,\"invoiceType\":\"%@\",\"invoiceMemo\":\"%@\"", self.invoiceType, self.invoiceMemo];
//        productInfo = [productInfo stringByAppendingString:invoiceStr];
//    }
    
    
    if (self.selectedDeliveryType) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"deliverType\":%@", self.selectedDeliveryType]];
    }
    
    if (self.selectedPayType) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"payType\":%@", self.selectedPayType]];
    }
    
    productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"payTaxType\":%@", self.selectedPayTaxType]];
    
    ///////////////////////
    productInfo = [[NSString stringWithFormat:@"{%@}", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return productInfo;
}

- (NSString *)getProductInfoString
{
    NSString *productInfo;
    for (CartItem *cartItem in self.cartItems) {
        NSString *proInfo = [NSString stringWithFormat:@"{\"productId\":%@,\"quantity\":%d,\"type\":%d,\"areaType\":%hd}",cartItem.productId, cartItem.quantity, 0, cartItem.areaType];
        if (productInfo == nil) {
            productInfo = proInfo;
            _areaType = cartItem.areaType;
        }
        else{
            productInfo = [NSString stringWithFormat:@"%@,%@", productInfo, proInfo];
        }
    }
    productInfo = [[NSString stringWithFormat:@"\"cartItems\":[%@]", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AddressEntity *addressEntity = [[AddressDataAccessor sharedInstance] getDefaulAddress];
    if (addressEntity) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"shippingId\":\"%lld\"", addressEntity.addressId]];
    }
    productInfo = [[NSString stringWithFormat:@"{%@}", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return productInfo;
}

#pragma mark - 下单选择
//使用优惠券
- (void)handleCouponTargetViewAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%s", __FUNCTION__);
    //NSLog(@"coup:%f", self.scrollView.contentSize.height);
    if (self.didGetCouponResponse == 0) {
        [MBProgressHUD showError:@"正在获取可用优惠券" toView:self.view];
        return;
    }
    else if (self.didGetCouponResponse == -1)
    {
        self.didGetCouponResponse = -2;
        [MBProgressHUD showMessag:@"正在获取可用优惠券" toView:self.view];
        [self getAvailabelCouponsForCart];
        return;
    }
    else if(self.didGetCouponResponse == -2){
        [MBProgressHUD showError:@"无可用优惠券。谢谢！" toView:self.view];
        return;
    }
    
    if (self.coupons.count > 0) {
        TargetView *targetView = (TargetView *)sender.view;
        targetView.spread = !targetView.spread;
        NSLog(@"spread %d", targetView.spread);
        
        if (targetView.spread) {
            //展开
            [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread") forState:UIControlStateNormal];
            
            UIView *checkView = [self.couponVIew viewWithTag:_SPREAD_VIEW_TAG_];
            if (!checkView) {
                checkView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(targetView.frame), CGRectGetMaxY(targetView.frame), CGRectGetWidth(targetView.frame), 100)];
                checkView.backgroundColor = [UIColor clearColor];
                checkView.tag = _SPREAD_VIEW_TAG_;
                [self.couponVIew addSubview:checkView];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH, 0.5)];
                lineView.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
                [checkView addSubview:lineView];
                
                float width = checkView.frame.size.width;
                float couponWidth = 140;
                float couponHeight = 50;
                float insert = 10;
                int hNumber = floorf((width+insert) / (couponWidth+insert));       //列数
                if (self.coupons.count < hNumber) {
                    hNumber = self.coupons.count;
                }
                int vNumber = ceilf((float)self.coupons.count/(float)hNumber);      //行数
                float offset = (float)(width - couponWidth * hNumber - insert * (hNumber - 1)) / 2.0;
                
                UIView *lastView = nil;
                int num = 0;
                for (int i = 0; i < vNumber; i++) {
                    for (int j = 0; j < hNumber; j++) {
                        num++;
                        if (num > 7 || num > self.coupons.count) {
                            break;
                        }
                        if (num <= 6) {
                            CouponView *couponView = [[CouponView alloc] initWithFrame:CGRectMake(offset + (couponWidth+insert)*j, 10+(couponHeight+insert)*i, couponWidth, couponHeight) couponInfo:[self.coupons objectAtIndex:num-1] delegate:self];
                            [checkView addSubview:couponView];
                            lastView = couponView;
                        } else {
                            UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
                            moreButton.frame = CGRectMake(offset, CGRectGetMaxY(lastView.frame) + 10, checkView.frame.size.width - offset*2, 30);
                            [moreButton setBackgroundColor:[UIColor clearColor]];
                            [moreButton setTitleColor:[UIColor colorWithRed:70/255.0 green:104/255.0 blue:178/255.0 alpha:1] forState:UIControlStateNormal];
                            [[moreButton titleLabel] setFont:[UIFont systemFontOfSize:13]];
                            [[moreButton titleLabel] setTextAlignment:NSTextAlignmentRight];
                            [moreButton setTitle:@"查看更多优惠券" forState:UIControlStateNormal];
                            [moreButton addTarget:self action:@selector(showMoreTicket:) forControlEvents:UIControlEventTouchUpInside];
                            [checkView addSubview:moreButton];
                            lastView = moreButton;
                            break;
                        }
                    }
                }
                
                CGRect frame = checkView.frame;
                frame.size.height = CGRectGetMaxY(lastView.frame) + 10;
                checkView.frame = frame;
                
            } else {
                [UIView animateWithDuration:.3f animations:^{
                    checkView.alpha = 1;
                }];
            }
            
            [self setCouponViewHeight:CGRectGetMaxY(checkView.frame)];
            
        } else {
            //收起
            [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
            [UIView animateWithDuration:.5f animations:^{
                [[self.couponVIew viewWithTag:_SPREAD_VIEW_TAG_] setAlpha:0];
            }];
            [self setCouponViewHeight:CGRectGetMaxY(targetView.frame)];
        }
    } else {
        NSLog(@"没有优惠券");
    }
}

#pragma mark - 选择配送方式
- (void)handleDeliveryTargetViewAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%s", __FUNCTION__);
    TargetView *targetView = (TargetView *)sender.view;
    targetView.spread = !targetView.spread;
    NSLog(@"spread %d", targetView.spread);
    
    AddressEntity *addressEntity = [[AddressDataAccessor sharedInstance] getDefaulAddress];
    if (!addressEntity) {
        //TODO 测试
        //have no address
        _noAddress = YES;
        [self deliveryViewShowAddressWithTargetView:targetView];
    } else {
        _noAddress = NO;
        [self deliveryViewSpreadWithTargetView:targetView];
    }
}

#pragma mark - 展开配送方式
- (void)deliveryViewSpreadWithTargetView:(TargetView *)targetView
{
    if ([self.allDeliversArray count] > 0) {
        if (targetView.spread) {
            
            [UIView animateWithDuration:.3f animations:^{
                self.defaultDeliverView.alpha = 0;
            } completion:^(BOOL finished) {
                [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread") forState:UIControlStateNormal];
                [[self.deliveryView viewWithTag:_SPREAD_VIEW_TAG_] removeFromSuperview];
                UIView *checkView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(targetView.frame), CGRectGetMaxY(targetView.frame), CGRectGetWidth(targetView.frame), 100)];
                checkView.backgroundColor = [UIColor clearColor];
                checkView.tag = _SPREAD_VIEW_TAG_;
                [self.deliveryView addSubview:checkView];
                
                for (int i = 0; i < [self.allDeliversArray count]; ++i) {
                    NSDictionary *deliver = [self.allDeliversArray objectAtIndex:i];
                    int deliverType = [[deliver objectForKey:@"deliverType"] intValue];
                    if (1 == deliverType) {
                        _express = YES;//支持快递
                        self.overseaContent = [deliver objectForKey:@"desc"];
                    } else {
                        _selfDeliver = YES;//支持自提
                    }
                }
                
                if (_express) {
                    CheckButton *checkButton = [[CheckButton alloc] initWithDelegate:self groupId:_DELIVER_TYPES_];
                    [checkButton setTitle:@"快递配送" forState:UIControlStateNormal];
                    checkButton.backgroundColor = [UIColor clearColor];
                    checkButton.deliverType = ExpressDeliverType;
                    checkButton.index = 0;
                    
                    CheckInfoView *checkInfoView = [[CheckInfoView alloc] initWithFrame:CGRectMake(5, 5, checkView.frame.size.width-10, 50) checkButton:checkButton decriptionStr:nil detailStr:nil];
                    checkInfoView.tag = checkButton.index + _CHECKBUTTON_TAG_;
                    [checkView addSubview:checkInfoView];
                    
                    CGRect frame = checkView.frame;
                    frame.size.height = CGRectGetMaxY(checkInfoView.frame) + 10;
                    checkView.frame = frame;
                }
                
                if (_selfDeliver) {
                    CheckButton *checkButton = [[CheckButton alloc] initWithDelegate:self groupId:_DELIVER_TYPES_];
                    [checkButton setTitle:@"到店自提" forState:UIControlStateNormal];
                    checkButton.backgroundColor = [UIColor clearColor];
                    checkButton.deliverType = ToShopDeliverType;
                    if (_express) {
                        checkButton.index = 1;
                    } else {
                        checkButton.index = 0;
                    }
                    
                    CheckInfoView *checkInfoView = [[CheckInfoView alloc] initWithFrame:CGRectMake(5, _express?55:5, checkView.frame.size.width-10, 50) checkButton:checkButton decriptionStr:@"20%订金" detailStr:@"选择到店自提，将不能使用货到付款和银行汇款支付方式"];
                    checkInfoView.tag = checkButton.index + _CHECKBUTTON_TAG_;
                    [checkView addSubview:checkInfoView];
                    
                    CGRect frame = checkView.frame;
                    frame.size.height = CGRectGetMaxY(checkInfoView.frame) + 10;
                    checkView.frame = frame;
                }
                [self setDeliveryViewHeight:CGRectGetMaxY(checkView.frame)];
            }];
            
        } else {
            [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
            [[self.deliveryView viewWithTag:_SPREAD_VIEW_TAG_] removeFromSuperview];
            
            [UIView animateWithDuration:.5f animations:^{
                self.defaultDeliverView.alpha = 1;
            }];
            
            [[(DeliverInfoView *)[self.defaultDeliverView viewWithTag:_DELIVERINFOVIEW_TAG_] checkButton] setChecked:YES];
            if (self.defaultDeliverView) {
                [self setDeliveryViewHeight:CGRectGetMaxY(self.defaultDeliverView.frame)+10];
            } else {
                [self setDeliveryViewHeight:CGRectGetMaxY(targetView.frame)];
            }
        }
    }
}

#pragma mark - 添加地址
- (void)deliveryViewShowAddressWithTargetView:(TargetView *)targetView
{
    if (targetView.spread) {
        //展开
        [UIView animateWithDuration:.3f animations:^{
            self.defaultDeliverView.alpha = 0;
        }];
        
        [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread") forState:UIControlStateNormal];
        [[self.deliveryView viewWithTag:_SPREAD_VIEW_TAG_] removeFromSuperview];
        UIView *checkView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(targetView.frame), CGRectGetMaxY(targetView.frame), CGRectGetWidth(targetView.frame), 100)];
        checkView.backgroundColor = [UIColor clearColor];
        checkView.tag = _SPREAD_VIEW_TAG_;
        [self.deliveryView addSubview:checkView];
        
        UIView *expressView = [[UIView alloc] initWithFrame:checkView.bounds];
        expressView.backgroundColor = [UIColor clearColor];
        expressView.tag = _SPREAD_VIEW_SUB_TAG;
        [checkView addSubview:expressView];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(20, 20, checkView.frame.size.width - 40, 40);
        [addButton setTitle:@"+添加收货地址" forState:UIControlStateNormal];
        [addButton setBackgroundColor:[UIColor colorWithRed:66/255.0 green:159/255.0 blue:219/255.0 alpha:1]];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addButton.layer.cornerRadius = 3;
        [addButton addTarget:self action:@selector(showAddressViewController:) forControlEvents:UIControlEventTouchUpInside];
        [expressView addSubview:addButton];
        
        CGRect frame = expressView.frame;
        frame.size.height = CGRectGetMaxY(addButton.frame) + 10;
        expressView.frame = frame;
        
        CGRect rect = checkView.frame;
        rect.size.height = CGRectGetMaxY(expressView.frame);
        checkView.frame = rect;
        [self setDeliveryViewHeight:CGRectGetMaxY(checkView.frame)];
    } else {
        //收起
        [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
        [[self.deliveryView viewWithTag:_SPREAD_VIEW_TAG_] removeFromSuperview];
        [UIView animateWithDuration:.5f animations:^{
            self.defaultDeliverView.alpha = 1;
        }];
        if (self.defaultDeliverView) {
            [self setDeliveryViewHeight:CGRectGetMaxY(self.defaultDeliverView.frame)+10];
        } else {
            [self setDeliveryViewHeight:CGRectGetMaxY(targetView.frame)];
        }
    }
}

#pragma mark - 选择支付方式
- (void)handlePaymentTargetViewAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    if (self.payAndDeliver.count <= 0) {
        return;
    }
    
    if (!self.paymentCheckView || [self.showPayTypeArray count] <= 0) {
        [MBProgressHUD showError:@"请先选择配送方式" toView:self.view];
        return;
    }
    
    TargetView *targetView = (TargetView *)sender.view;
    targetView.spread = !targetView.spread;
    NSLog(@"spread %d", targetView.spread);
    if (targetView.spread) {
        //展开
        [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread") forState:UIControlStateNormal];
        [UIView animateWithDuration:.3f animations:^{
            self.paymentCheckView.alpha = 1;
        }];
        [self setPaymentViewHeight:CGRectGetMaxY(self.paymentCheckView.frame)];
    } else {
        //收起
        [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
        [UIView animateWithDuration:.5f animations:^{
            [[self.paymentView viewWithTag:_SPREAD_VIEW_TAG_] setAlpha:0];
        }];
        [self setPaymentViewHeight:CGRectGetMaxY(targetView.frame)];
    }
}

#pragma mark - 开具发票
- (void)handleInvoiceTargetViewAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"%s", __FUNCTION__);
    TargetView *targetView = (TargetView *)sender.view;
    targetView.spread = !targetView.spread;
    NSLog(@"spread %d", targetView.spread);
    
    if (targetView.spread) {
        //展开
        [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread") forState:UIControlStateNormal];
        
        UIView *checkView = [self.invoiceView viewWithTag:_SPREAD_VIEW_TAG_];
        if (!checkView) {
            checkView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(targetView.frame), CGRectGetMaxY(targetView.frame), CGRectGetWidth(targetView.frame), 100)];
            checkView.backgroundColor = [UIColor clearColor];
            checkView.tag = _SPREAD_VIEW_TAG_;
            [self.invoiceView addSubview:checkView];
            
            CheckButton *checkButton1 = [[CheckButton alloc] initWithDelegate:self groupId:_INVOICE_TYPES_];
            checkButton1.frame = CGRectMake(5, 5, checkView.frame.size.width-10, 50);
            [checkButton1 setTitle:@"否" forState:UIControlStateNormal];
            checkButton1.checked = YES;
            checkButton1.index = 0;
            checkButton1.invoiceType = InvoiceTypeNo;
            [checkView addSubview:checkButton1];
            
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            lineView1.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
            [checkButton1 addSubview:lineView1];
            
            CheckButton *checkButton2 = [[CheckButton alloc] initWithDelegate:self groupId:_INVOICE_TYPES_];
            checkButton2.frame = CGRectMake(5, 55, checkView.frame.size.width-10, 50);
            [checkButton2 setTitle:@"个人" forState:UIControlStateNormal];
            checkButton2.index = 1;
            checkButton2.invoiceType = InvoiceTypePersonal;
            [checkView addSubview:checkButton2];
            
            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            lineView2.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
            [checkButton2 addSubview:lineView2];
            
            CheckButton *checkButton3 = [[CheckButton alloc] initWithDelegate:self groupId:_INVOICE_TYPES_];
            checkButton3.frame = CGRectMake(5, 105, checkView.frame.size.width-10, 50);
            [checkButton3 setTitle:@"公司" forState:UIControlStateNormal];
            checkButton3.index = 2;
            checkButton3.invoiceType = InvoiceTypeComponty;
            [checkView addSubview:checkButton3];
            
            UITextField *companyField = [[UITextField alloc] initWithFrame:CGRectMake(checkView.frame.size.width*0.2, CGRectGetMinY(checkButton3.frame)+5, checkView.frame.size.width*0.8, CGRectGetHeight(checkButton3.frame)-10)];
            companyField.delegate = self;
            companyField.placeholder = @"请输入公司名字";
            companyField.borderStyle = UITextBorderStyleNone;
            self.companyField = companyField;
            [checkView addSubview:companyField];
            
            UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            lineView3.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
            [checkButton3 addSubview:lineView3];
            
            CGRect frame = checkView.frame;
            frame.size.height = CGRectGetMaxY(checkButton3.frame);
            checkView.frame = frame;
        } else {
            [UIView animateWithDuration:.3f animations:^{
                checkView.alpha = 1;
            }];
        }
        [self setInvoiceViewHeight:CGRectGetMaxY(checkView.frame)];
        
    } else {
        //收起
        if (InvoiceTypeComponty == self.selectInvoiceType) {
            NSString *companyName = [Utils stringbyRmovingSpaceFromString:self.companyField.text];
            if ([Utils isValidString:companyName]) {
                [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
                [UIView animateWithDuration:.5f animations:^{
                    [[self.invoiceView viewWithTag:_SPREAD_VIEW_TAG_] setAlpha:0];
                }];
                [self setInvoiceViewHeight:CGRectGetMaxY(targetView.frame)];
                [self.companyField resignFirstResponder];
                self.invoiceTargetView.descriptionLabel.text = companyName;
            } else {
                [self.companyField becomeFirstResponder];
            }
        } else {
            [targetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
            [UIView animateWithDuration:.5f animations:^{
                [[self.invoiceView viewWithTag:_SPREAD_VIEW_TAG_] setAlpha:0];
            }];
            [self setInvoiceViewHeight:CGRectGetMaxY(targetView.frame)];
            [self.companyField resignFirstResponder];
        }
    }
}

#pragma mark - 更新支付方式 self.showPayTypeArray 不能为空
- (void)updatePaymentCheckView
{
    UIView *checkView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.paymentTargetView.frame), CGRectGetMaxY(self.paymentTargetView.frame), CGRectGetWidth(self.paymentTargetView.frame), 100)];
    checkView.backgroundColor = [UIColor clearColor];
    checkView.tag = _SPREAD_VIEW_TAG_;
    [self.paymentCheckView removeFromSuperview];
    [self.paymentView addSubview:checkView];
    self.paymentCheckView = checkView;
    
    self.selectPayType = -1;
    int areaType = [[[self.productArray firstObject] objectForKey:@"areaType"] intValue];
    
    UIView *lastView = nil;
    if (0 == areaType && _IOS_7_LATER_) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
        [checkView addSubview:lineView];
        lastView = lineView;

        UIView *kuCoinView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, checkView.frame.size.width-5, 40)];
        kuCoinView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        kuCoinView.layer.cornerRadius = 5;
        [checkView addSubview:kuCoinView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kuCoinView.frame.size.width-90, 5, 80, 30);
        [button setBackgroundImage:_IMAGE_WITH_NAME(@"kuCoinButton") forState:UIControlStateNormal];
        [button setTitle:@"使用库币" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 3;
        [button addTarget:self action:@selector(handleCurrencyAction:) forControlEvents:UIControlEventTouchUpInside];
        [kuCoinView addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 8, 13)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = _IMAGE_WITH_NAME(@"smallKuCoin");
        [kuCoinView addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 80, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = @"库币";
        [kuCoinView addSubview:nameLabel];
        
        //显示使用库币数量
        UILabel *kuCoinNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kuCoinView.frame.size.width-170, 5, 75, 30)];
        kuCoinNumLabel.backgroundColor = [UIColor clearColor];
        kuCoinNumLabel.font = [UIFont systemFontOfSize:18];
        kuCoinNumLabel.textColor = [UIColor colorWithRed:22/255.0 green:163/255.0 blue:2/255.0 alpha:1];
        kuCoinNumLabel.textAlignment = NSTextAlignmentRight;
        self.kuCoinNumberLabel = kuCoinNumLabel;
        [kuCoinView addSubview:kuCoinNumLabel];
        lastView = kuCoinView;
        
        DottedRectangleView *dottedRectangleView = [[DottedRectangleView alloc] initWithFrame:kuCoinView.bounds];
        [kuCoinView addSubview:dottedRectangleView];
        [kuCoinView sendSubviewToBack:dottedRectangleView];
    }
    
    /****************************************************/
    BOOL canCashOfDelivery = [[[self.jsonDictionary objectForKey:@"cart"] objectForKey:@"canCashOfDelivery"] boolValue];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < [self.showPayTypeArray count]; ++i) {
        NSDictionary *payType = [self.showPayTypeArray objectAtIndex:i];
        if (!(([[payType objectForKey:@"mobilePayType"] intValue] == DelivePayType) && NO == canCashOfDelivery)) {
            [tempArray addObject:payType];
        }
    }
    self.showPayTypeArray = tempArray;
    
    for (int i = 0; i < self.showPayTypeArray.count; i++) {
        NSDictionary *payType = [self.showPayTypeArray objectAtIndex:i];
        NSString *descriptionStr = nil;
        NSString *desc = [payType objectForKey:@"desc"];
        if (desc && ![desc isEqualToString:@""]) {
            descriptionStr = desc;
        }
        
        CGRect rect = CGRectMake(5, 5, checkView.frame.size.width - 10, 50);
        if (lastView) {
            rect.origin.y = CGRectGetMaxY(lastView.frame) + 10;
        }
        
        CheckButton *checkButton = [[CheckButton alloc] initWithDelegate:self groupId:_PAYMENT_TYPES_];
        [checkButton setTitle:[[payType objectForKey:@"label"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forState:UIControlStateNormal];
        checkButton.mobilePayType = [[payType objectForKey:@"mobilePayType"] intValue];
        checkButton.index = i;
        if (checkButton.mobilePayType == [[UserInfoManager getLastTimeMobilePaytype] intValue]) {
            checkButton.checked = YES;
            self.paymentTargetView.descriptionLabel.text = [payType objectForKey:@"label"];
            self.selectedMobilePayType = [NSString stringWithFormat:@"%d",checkButton.mobilePayType];
            self.selectedPayType = [NSString stringWithFormat:@"%@", [payType objectForKey:@"payType"]];
        }
        
        if (checkButton.mobilePayType == BankPayType) {
            CheckInfoView *checkInfoView = [[CheckInfoView alloc] initWithFrame:rect checkButton:checkButton decriptionStr:nil detailStr:descriptionStr];
            [checkView addSubview:checkInfoView];
            lastView = checkInfoView;
        } else {
            CheckInfoView *checkInfoView = [[CheckInfoView alloc] initWithFrame:rect checkButton:checkButton decriptionStr:descriptionStr detailStr:nil];
            [checkView addSubview:checkInfoView];
            lastView = checkInfoView;
        }
    }
    
    if (!(0 == areaType)) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3;
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"购物凭证\n"];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attribute.length)];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"HK SECOO依据美国地区法律，就向您销售的全部商品提供寺库专用购物凭证(商品发货清单)"];
        if (1 == areaType) {
            text = [[NSMutableAttributedString alloc] initWithString:@"HK SECOO依据香港地区法律，就向您销售的全部商品提供寺库专用购物凭证(商品发货清单)"];
        } else if (2 == areaType) {
            text = [[NSMutableAttributedString alloc] initWithString:@"SECOO.INC依据美国地区法律，就向您销售的全部商品提供寺库专用购物凭证(商品发货清单)"];
        } else if (3 == areaType) {
            text = [[NSMutableAttributedString alloc] initWithString:@"SECOO依据日本地区法律，就向您销售的全部商品提供寺库专用购物凭证(商品发货清单)"];
        } else if (4 == areaType) {
            text = [[NSMutableAttributedString alloc] initWithString:@"SECOO欧洲 依据欧洲国家的法律，就向您销售的全部商品提供寺库专用购物凭证(商品发货清单)"];
        }
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
        [attribute appendAttributedString:text];
        [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attribute.length)];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame)+10, SCREEN_WIDTH, 0.5)];
        [lineView setBackgroundColor:[UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1]];
        [checkView addSubview:lineView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+10, checkView.frame.size.width-20, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.attributedText = attribute;
        [label sizeToFit];
        [checkView addSubview:label];
        lastView = label;
    }
    
    if (lastView) {
        CGRect frame = checkView.frame;
        frame.size.height = CGRectGetMaxY(lastView.frame) + 10;
        checkView.frame = frame;
    }
    
    if (self.paymentTargetView.spread) {
        [self setPaymentViewHeight:CGRectGetMaxY(checkView.frame)];
        checkView.alpha = 1;
    } else {
        checkView.alpha = 0;
    }
}

#pragma mark - 点击优惠券
- (void)didSelectOneCouponViewWithInfo:(NSDictionary *)info
{
    NSLog(@"%s", __FUNCTION__);
    
    self.couponTargetView.spread = !self.couponTargetView.spread;
    [self.couponTargetView.targetButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
    [UIView animateWithDuration:.5f animations:^{
        [[self.couponVIew viewWithTag:_SPREAD_VIEW_TAG_] setAlpha:0];
    }];
    
    [self setCouponViewHeight:CGRectGetMaxY(self.couponTargetView.frame)];
    
    self.selectedCouponID = [NSString stringWithFormat:@"%@", [info objectForKey:@"id"]];
    
    NSString *money = [NSString stringWithFormat:@"%@", [info objectForKey:@"ticketMoney"]];
    self.couponTargetView.descriptionLabel.text = [NSString stringWithFormat:@"已优惠%@元", money];
    self.couponTargetView.descriptionLabel.textColor = [UIColor redColor];
    self.couponPrice = money;
    
    CGRect frame = self.couponTargetView.iconImageView.frame;
    CGSize size = [Utils getSizeOfString:self.couponTargetView.descriptionLabel.text ofFont:[UIFont systemFontOfSize:15] withMaxWidth:300];
    frame.origin.x = self.couponTargetView.frame.size.width - self.couponTargetView.targetButton.frame.size.width - size.width - frame.size.width - 5;
    [UIView animateWithDuration:.3f animations:^{
        self.couponTargetView.iconImageView.frame = frame;
    }];
    
    //get cart information
    [self getCheckoutResponseAndShowWarning:NO forAvailable:_forAvailable];
}

#pragma mark - 查看更多优惠价
- (void)showMoreTicket:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CouponViewController *couponViewVC = [storyboard instantiateViewControllerWithIdentifier:@"CouponViewController"];
    couponViewVC.delegate = self;
    [self.navigationController pushViewController:couponViewVC animated:YES];
}
#pragma mark --
#pragma mark -- CouponViewDelegate --
- (void)didSelectCoupon:(NSDictionary *)coupon
{
    //WYK
    [self didSelectOneCouponViewWithInfo:coupon];
}

- (void)handleAddressChange:(NSNotification*)notification
{
    [self getCheckoutResponse:_forAvailable];
    
//    if (_noAddress) {
//        [self handleDeliveryTargetViewAction:[self.deliveryTargetView.gestureRecognizers firstObject]];
//        [self handleDeliveryTargetViewAction:[self.deliveryTargetView.gestureRecognizers firstObject]];
//    } else {
//        NSArray *array = [[AddressDataAccessor sharedInstance] getAllAddresse];
//        [self updateExpressViewWithAddressArray:array express:YES];
//    }
    
}

#pragma mark - CheckButtonDelegate Method
- (void)didSelectedRadioButton:(CheckButton *)checkButton groupId:(NSString *)groupId
{
    if ([groupId isEqualToString:_PAYMENT_TYPES_]) {
        //支付方式
        self.selectPayType = checkButton.mobilePayType;
        _selectPayIndex = checkButton.index;
        
        NSDictionary *payType = [self.showPayTypeArray objectAtIndex:_selectPayIndex];
        self.selectedPayType = [NSString stringWithFormat:@"%@", [payType objectForKey:@"payType"]];
        self.selectedMobilePayType = [NSString stringWithFormat:@"%@", [payType objectForKey:@"mobilePayType"]];
        self.paymentTargetView.descriptionLabel.text = [payType objectForKey:@"label"];
        
        [UserInfoManager setLastTimePaytype:self.selectedPayType];
        if (self.selectedMobilePayType) {
            [UserInfoManager setLastTimeMobilePaytype:self.selectedMobilePayType];
        }
        
        [self handlePaymentTargetViewAction:[self.paymentTargetView.gestureRecognizers firstObject]];
        [self getCheckoutResponseAndShowWarning:NO forAvailable:_forAvailable];
    } else if ([groupId isEqualToString:_DELIVER_TYPES_]) {
        //配送方式
        _selectDeliverIndex = checkButton.index;
        
        UIView *checkView = [self.deliveryView viewWithTag:_SPREAD_VIEW_TAG_];
        [[checkView viewWithTag:_SPREAD_VIEW_SUB_TAG] removeFromSuperview];
        
        UIView *lastView = nil;
        for (int i = 0; i < 2; i++) {
            UIView *view = [checkView viewWithTag:(i + _CHECKBUTTON_TAG_)];
            CGRect frame = view.frame;
            if (lastView) {
                frame.origin.y = CGRectGetMaxY(lastView.frame) + 10;
            } else {
                frame.origin.y = 5;
            }
            view.frame = frame;
            lastView = view;
        }
        if (lastView) {
            CGRect rect = checkView.frame;
            rect.size.height = CGRectGetMaxY(lastView.frame) + 10;
            checkView.frame = rect;
        }
        [self setDeliveryViewHeight:CGRectGetMaxY(checkView.frame)];
        
        if (ExpressDeliverType == checkButton.deliverType) {
            //快递
            NSArray *addressArray = [[AddressDataAccessor sharedInstance] getAllAddresse];
            [self updateExpressViewWithAddressArray:addressArray express:YES];
        } else if (ToShopDeliverType == checkButton.deliverType) {
            //自提
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in self.allDeliversArray) {
                if (1 != [[dic objectForKey:@"deliverType"] intValue]) {
                    [array addObject:dic];
                }
            }
            [self updateExpressViewWithAddressArray:array express:NO];
        }
        
    } else if ([groupId isEqualToString:_INVOICE_TYPES_]) {
        //是否开具发票
        self.selectInvoiceType = checkButton.invoiceType;
        _selectInvoiceIndex = checkButton.index;
        self.invoiceTargetView.descriptionLabel.text = checkButton.titleLabel.text;
        
        if (InvoiceTypeNo == self.selectInvoiceType) {
            self.didNeedInvoice = 0;
            self.invoiceType = @"否";
            [self handleInvoiceTargetViewAction:[self.invoiceTargetView.gestureRecognizers firstObject]];
        } else {
            self.didNeedInvoice = 1;
            if (InvoiceTypeComponty == self.selectInvoiceType) {
                
                NSString *companyName = [Utils stringbyRmovingSpaceFromString:self.companyField.text];
                if ([Utils isValidString:companyName]) {
                    self.invoiceType = companyName;
                    self.invoiceTargetView.descriptionLabel.text = companyName;
                    [self handleInvoiceTargetViewAction:[self.invoiceTargetView.gestureRecognizers firstObject]];
                } else {
                    self.invoiceType = nil;
                    [self.companyField becomeFirstResponder];
                }
                
            } else {
                self.invoiceType = @"个人";
                [self handleInvoiceTargetViewAction:[self.invoiceTargetView.gestureRecognizers firstObject]];
            }
        }
    }
}

- (void)updateExpressViewWithAddressArray:(NSArray *)addressArray express:(BOOL)express
{
    UIView *checkView = [self.deliveryView viewWithTag:_SPREAD_VIEW_TAG_];
    [[checkView viewWithTag:_SPREAD_VIEW_SUB_TAG] removeFromSuperview];
    
    [self.defaultDeliverView removeFromSuperview];
    self.defaultDeliverView = nil;
    
    CheckInfoView *checkInfoView = ((CheckInfoView *)[checkView viewWithTag:_selectDeliverIndex+_CHECKBUTTON_TAG_]);
    
    UIView *expressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(checkInfoView.frame), CGRectGetWidth(checkView.frame), 100)];
    expressView.backgroundColor = [UIColor clearColor];
    expressView.tag = _SPREAD_VIEW_SUB_TAG;
    [checkView addSubview:expressView];
    UIView *lastView = expressView;
    
    /******************************************************/
    if (express) {
        AddressInfoView *addressInfoView = [[AddressInfoView alloc] initWithFrame:CGRectMake(5, 10, expressView.frame.size.width-10, 100) addressArray:addressArray delegate:self express:express];
        [expressView addSubview:addressInfoView];
        
        lastView = addressInfoView;
        if ([addressArray count] < 5) {
            UIButton *addNewAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addNewAddressButton.frame = CGRectMake(5, CGRectGetMaxY(lastView.frame)+10, expressView.frame.size.width - 10, 40);
            addNewAddressButton.backgroundColor = [UIColor colorWithRed:66/255.0 green:159/255.0 blue:219/255.0 alpha:1];
            [addNewAddressButton setTitle:@"+添加新地址" forState:UIControlStateNormal];
            [addNewAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            addNewAddressButton.layer.cornerRadius = 3;
            [addNewAddressButton addTarget:self action:@selector(showAddressViewController:) forControlEvents:UIControlEventTouchUpInside];
            [expressView addSubview:addNewAddressButton];
            lastView = addNewAddressButton;
        }
        
        if (self.overseaContent && ![self.overseaContent isEqualToString:@""]) {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame)+20, expressView.frame.size.width-20, 100)];
            webView.backgroundColor = [UIColor clearColor];
            webView.scalesPageToFit = YES;
            webView.scrollView.showsHorizontalScrollIndicator = NO;
            webView.scrollView.showsVerticalScrollIndicator = NO;
            webView.userInteractionEnabled = NO;
            [webView loadHTMLString:self.overseaContent baseURL:nil];
            [expressView addSubview:webView];
            lastView = webView;
        }
    } else {
        UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, expressView.frame.size.width-10, 40)];
        nameTextField.placeholder = @"请输入您的姓名";
        nameTextField.borderStyle = UITextBorderStyleRoundedRect;
        nameTextField.delegate = self;
        nameTextField.text = self.userName;
        self.nameTextField = nameTextField;
        [expressView addSubview:nameTextField];
        
        UITextField *phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 60, expressView.frame.size.width-10, 40)];
        phoneTextField.placeholder = @"请输入您的电话";
        phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
        phoneTextField.delegate = self;
        phoneTextField.text = self.userPhone;
        self.phoneTextField = phoneTextField;
        [expressView addSubview:phoneTextField];
        
        AddressInfoView *addressInfoView = [[AddressInfoView alloc] initWithFrame:CGRectMake(5, 110, expressView.frame.size.width-10, 100) addressArray:addressArray delegate:self express:express];
        [expressView addSubview:addressInfoView];
        lastView = addressInfoView;
    }
    /***************************************************/
    
    CGRect eFrame = expressView.frame;
    eFrame.size.height = CGRectGetMaxY(lastView.frame)+10;
    expressView.frame = eFrame;
    
    lastView = expressView;
    int index = _selectDeliverIndex;
    int count = (_express && _selfDeliver) ? 2 : (!_express && !_selfDeliver) ? 0 : 1;
    for (int i = index + 1; i < count; i++) {
        UIView *view = [checkView viewWithTag:(i + _CHECKBUTTON_TAG_)];
        CGRect frame = view.frame;
//        frame.origin.y += (expressView.frame.size.height);
        frame.origin.y = CGRectGetMaxY(lastView.frame);
        view.frame = frame;
        lastView = view;
    }
    
    if (lastView) {
        CGRect rect = checkView.frame;
        rect.size.height = CGRectGetMaxY(lastView.frame) + 10;
        checkView.frame = rect;
    }
    
    [self setDeliveryViewHeight:CGRectGetMaxY(checkView.frame)];
}

#pragma mark - 上传身份证
- (void)uploadCertificateWithButton:(UIButton *)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CertificateManagedViewController *certificateManagedVC = [storyBoard instantiateViewControllerWithIdentifier:@"CertificateManagedViewController"];
    certificateManagedVC.navigationItem.title = @"证件管理";
    [self.navigationController pushViewController:certificateManagedVC animated:YES];
}

#pragma mark - AddressInfoViewDelegate Method
- (void)getTheAddressInfo:(id)info
{
    NSLog(@"select AddressInfo %@", info);
    _selectPayIndex = -1;
    self.selectedPayType = nil;
    self.selectedMobilePayType = nil;
    self.paymentTargetView.descriptionLabel.text = @"选择支付方式";
    
    if ([info isKindOfClass:[AddressEntity class]]) {
        self.deliveryTargetView.descriptionLabel.text = @"快递配送";
        self.shippingId = [NSString stringWithFormat:@"%lld", [(AddressEntity *)info addressId]];
        self.selectedDeliveryType = [NSString stringWithFormat:@"1"];
        [UserInfoManager setLastTimeAddressID:self.shippingId];
        [self setUpDefaultAddressInfoViewWithInfo:info];
        [self handleDeliveryTargetViewAction:[self.deliveryTargetView.gestureRecognizers firstObject]];

        //对应的支付方式 和 payTaxType
        for (int i = 0; i < [self.payAndDeliver count]; ++i) {
            NSDictionary *deliver = [[self.payAndDeliver objectAtIndex:i] objectForKey:@"deliver"];
            if (1 == [[deliver objectForKey:@"deliverType"] intValue]) {
                self.showPayTypeArray = [[self.payAndDeliver objectAtIndex:i] objectForKey:@"payTypes"];
                NSString *payTaxType = [deliver objectForKey:@"payTaxType"];
                if (payTaxType && ![payTaxType isEqualToString:@""]) {
                    self.selectedPayTaxType = payTaxType;
                } else {
                    self.selectedPayTaxType = @"0";
                }
                break;
            }
        }
    } else {
        //到店自提
        self.deliveryTargetView.descriptionLabel.text = @"到店自提";
        self.chooseWareHouseId = [NSString stringWithFormat:@"%@", [[(NSDictionary *)info objectForKey:@"otherParams"] objectForKey:@"chooseWarehouseId"]];
        self.selectedDeliveryType = [NSString stringWithFormat:@"%@",[(NSDictionary *)info objectForKey:@"deliverType"]];
        [UserInfoManager setLastTimeWarehouse:self.chooseWareHouseId];
        if (self.userName && ![self.userName isEqualToString:@""] && self.userPhone && ![self.userPhone isEqualToString:@""]) {
            [self setUpDefaultAddressInfoViewWithInfo:info];
            [self handleDeliveryTargetViewAction:[self.deliveryTargetView.gestureRecognizers firstObject]];
        } else {
            [self setUpDefaultAddressInfoViewWithInfo:info];
//            self.defaultDeliverView.hidden = YES;
            self.defaultDeliverView.alpha = 0;
        }
        
        //对应的支付方式 和 payTaxType
        for (int i = 0; i < [self.payAndDeliver count]; ++i) {
            NSDictionary *deliver = [[self.payAndDeliver objectAtIndex:i] objectForKey:@"deliver"];
            if ([[deliver objectForKey:@"deliverType"] intValue] == [[(NSDictionary *)info objectForKey:@"deliverType"] intValue]) {
                self.showPayTypeArray = [[self.payAndDeliver objectAtIndex:i] objectForKey:@"payTypes"];
                NSString *payTaxType = [deliver objectForKey:@"payTaxType"];
                if (payTaxType && ![payTaxType isEqualToString:@""]) {
                    self.selectedPayTaxType = payTaxType;
                } else {
                    self.selectedPayTaxType = @"0";
                }
                break;
            }
        }
    }
    
    [UserInfoManager setLastTimeDeliveryType:self.selectedDeliveryType];
    [self updatePaymentCheckView];
    [self getCheckoutResponseAndShowWarning:NO forAvailable:_forAvailable];
}

#pragma mark --
#pragma mark -- kuCoinOperationDelegate --
- (void)didUsingKuCoin:(NSInteger)number password:(NSString*)password verificationNumber:(NSString*)verificationNumber
{
    self.bankLabel.text = [NSString stringWithFormat:@"%d库币", number];
    [self setKuCoinButtonTitle:number];
    self.kuCoinNumber = number;
    self.kuCoinPasswrod = password;
    self.kuCoinVerificaitonNumber = verificationNumber;
    [self getCheckoutResponseAndShowWarning:NO forAvailable:_forAvailable];
}

#pragma mark - 使用库币
- (void)handleCurrencyAction:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KuCoinViewController *kuCoinVC = [storyboard instantiateViewControllerWithIdentifier:@"KuCoinViewController"];
    kuCoinVC.title = @"使用库币";
    kuCoinVC.delegate = self;
    kuCoinVC.cartItems = self.cartItems;
    kuCoinVC.type = UsingKuCoinType;
    [self.navigationController pushViewController:kuCoinVC animated:YES];
}

- (NSString *)addNewOrderString:(BOOL)willShow forAvailable:(BOOL)forAvailable
{
    NSString *productInfo;
    for (CartItem *cartItem in self.cartItems) {
        NSInteger num = cartItem.quantity;
        if (forAvailable) {
            num = cartItem.availableAmount;
            if (num == 0 || cartItem.inventoryStatus == 2) {
                continue;
            }
        }
        NSString *proInfo = [NSString stringWithFormat:@"{\"productId\":\"%@\",\"quantity\":%d,\"type\":%d,\"areaType\":\"%d\"}",cartItem.productId, num, 0, cartItem.areaType];
        if (productInfo == nil) {
            productInfo = proInfo;
            _areaType = cartItem.areaType;
        }
        else{
            productInfo = [NSString stringWithFormat:@"%@,%@", productInfo, proInfo];
        }
    }
    productInfo = [NSString stringWithFormat:@"\"cartItems\":[%@]", productInfo];
    
    //aid
    productInfo = [productInfo stringByAppendingString:@",\"aid\":1"];
    //invoice
    if (self.didNeedInvoice <= 0) {
        NSString *invoiceStr = @",\"isInvoice\":0,\"invoiceType\":\"\",\"invoiceMemo\":\"\"";
        productInfo = [productInfo stringByAppendingString:invoiceStr];
    }
    else if (self.didNeedInvoice >= 1){
        if (self.invoiceType && ![self.invoiceType isEqualToString:@""]) {
            NSString *invoiceStr = [NSString stringWithFormat:@",\"isInvoice\":1,\"invoiceType\":\"%@\",\"invoiceMemo\":\"%@\"", [self.invoiceType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.invoiceMemo];
            productInfo = [productInfo stringByAppendingString:invoiceStr];
        } else {
            if (willShow) {
                [self showUserSubmittingMessage:@"请选择发票内容"];
            }
            return nil;
        }
    }
    
    if (self.kuCoinNumber > 0 && self.kuCoinPasswrod && self.kuCoinVerificaitonNumber) {
        NSString *kuCoinStr = [NSString stringWithFormat:@",\"isUseBalance\":1,\"payPassword\":\"%@\",\"phoneValidateNum\":\"%@\",\"useBalanceAmount\":\"%d\"", self.kuCoinPasswrod, self.kuCoinVerificaitonNumber, self.kuCoinNumber];
        productInfo = [productInfo stringByAppendingString:kuCoinStr];
    }
    else{
        NSString *kuCoinStr = @",\"isUseBalance\":0";
        productInfo = [productInfo stringByAppendingString:kuCoinStr];
    }
    
    if (self.selectedDeliveryType) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"deliverType\":%@", self.selectedDeliveryType]];
        if ([self.selectedDeliveryType isEqualToString:@"1"]){
            if (self.shippingId) {
                productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"shippingId\":%@", self.shippingId]];
            }
            else{
                if (willShow) {
                    [self showUserSubmittingMessage:@"请选择你的地址"];
                }
                return nil;
            }
        }
        else{
            if (self.userPhone == nil || self.userName == nil) {
                if (willShow) {
                    [self showUserSubmittingMessage:@"请填写名字和电话"];
                }
                return nil;
            }
            if (self.chooseWareHouseId) {
                productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"chooseWarehouseId\":%@", self.chooseWareHouseId]];
            }
            else{
                if (willShow) {
                    [self showUserSubmittingMessage:@"请选择自提点"];
                }
                return nil;
            }
        }
    }
    else{
        if (willShow) {
            [self showUserSubmittingMessage:@"请选择配送方式"];
        }
        return nil;
    }
    
    if (self.selectedPayType) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"payType\":%@", self.selectedPayType]];
    }
    else{
        if (willShow) {
            [self showUserSubmittingMessage:@"请选择支付方式"];
        }
        return nil;
    }
    
    productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"payTaxType\":%@", self.selectedPayTaxType]];
    
    if (self.selectedCouponID) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"ticketId\":\"%@\"", self.selectedCouponID]];
    }
    
    
    productInfo = [NSString stringWithFormat:@"{%@}", productInfo];
    //productInfo = [productInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return productInfo;
}

- (NSString *)generateCheckOutURL:(BOOL)willShow forAvailable:(BOOL)forAvailable
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *orderInfo = [self addNewOrderString:willShow forAvailable:forAvailable];
    if (orderInfo == nil) {
        return nil;
    }
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *urlRef = [NSString stringWithFormat:@"http://iphone.secoo.com$_$%@$_$%@", versionStr, _CHANNEL_ID_];
    urlRef = [urlRef stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/orders_ordersadd.action?upkey=%@&cart=%@&urlref=%@&areaType=%d", upKey, orderInfo, urlRef, _areaType];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/orders_ordersadd.action?upkey=%@&cart=%@&userName=%@&userPhone=%@&urlref=%@", upKey, orderInfo, [self.userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.userPhone, urlRef];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}

#pragma mark - 提交订单
- (void)submittOrders:(UIButton *)sender
{
    if (InvoiceTypeComponty == self.selectInvoiceType) {
        NSString *companyName = [Utils stringbyRmovingSpaceFromString:self.companyField.text];
        if ([Utils isValidString:companyName]) {
            self.invoiceType = companyName;
        }
    }

    if (_isGettingNewTotalPrice) {
        [Utils showAlertMessage:@"正在获取新的价格..." title:@"提示"];
        return;
    }
    NSString *url = [self generateCheckOutURL:YES forAvailable:_forAvailable];
    if (url == nil) {
        return;
    }
    
    UIButton *button = self.submittButton;
    [button setTitle:@"提交中..." forState:UIControlStateNormal];
    if (self.mbProgressHUD) {
        [self.mbProgressHUD show:YES];
    } else {
        self.mbProgressHUD = [MBProgressHUD showMessag:@"努力加载中" toView:self.view];
    }
    
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(CustomerOrderViewController*) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:@"提交订单" forState:UIControlStateNormal];
            [weakSelf.mbProgressHUD hide:YES];
        });
        typeof(CustomerOrderViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    int resultCode = [[jsonDict objectForKey:@"recode"] integerValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (resultCode == 0) {
                            NSDictionary *subDict = [jsonDict objectForKey:@"result"];
                            long long code = [[subDict objectForKey:@"object"] longLongValue];
                            NSString *orderID = [NSString stringWithFormat:@"%lld", code];
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            OrderResultViewController *orderResultVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderResultViewController"];
                            orderResultVC.orderURL = url;
                            orderResultVC.payType = strongSelf.selectedPayType;
                            orderResultVC.mobilePayType = strongSelf.selectedMobilePayType;
                            orderResultVC.deliverType = self.selectedDeliveryType;
                            orderResultVC.areaType = _areaType;
                            orderResultVC.orderID = orderID;
                            orderResultVC.realTotalMoney = [NSString stringWithFormat:@"%f", _realTotalMoney];
                            orderResultVC.depositMoney = [NSString stringWithFormat:@"%f", _depositMoney];
                            [strongSelf.navigationController pushViewController:orderResultVC animated:YES];
                            [[CartItemAccessor sharedInstance] deleteObjectsWithAreaType:_areaType];
                        }
                        else if (resultCode == 1060){
                            if (!_isBuyNow) {
                                [[[CartURLSession alloc] init] updateCartItems:self.cartItems];
                            }
                            [Utils showAlertMessage:[jsonDict objectForKey:@"errMsg"] title:@"错误"];
                        }
                        else if (resultCode == 511){
                            //not enough products
                            if (!_isBuyNow) {
                                [[[CartURLSession alloc] init] updateCartItems:self.cartItems];
                            }
                            NSArray *soldOutProducts = [jsonDict objectForKey:@"soldOutProduct"];
                            [strongSelf showSoldoutProducts:soldOutProducts];
                        }
                        else if (resultCode == 901){
                            //has auction product
                            [Utils showAlertMessage:[jsonDict objectForKey:@"errMsg"] title:@"错误"];
                        }
                        else if (resultCode == 902){
                            //has auction product and there is not enough inventory
                            [Utils showAlertMessage:[jsonDict objectForKey:@"errMsg"] title:@"错误"];
                        }
                        else{
                            [MBProgressHUD showError:[jsonDict objectForKey:@"errMsg"] toView:strongSelf.view];
                        }

                    });
                }
                else{
                    NSLog(@"json parsing error:%@", jsonError.description);
                }
            }
            else{
                NSLog(@"making an order error :%@", error.description);
            }
        }
    }];
    
    //友盟统计
    [MobClick event:@"iOS_dingdan_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_dingdan_uv"];
}

- (void)showSoldoutProducts:(NSArray *)array
{
    _didPopWarning = YES;
    BOOL allSoldOut = YES;
    if([array count] == [self.cartItems count]){
        for (CartItem *item in self.cartItems) {
            if (item.quantity > 1 && item.availableAmount > 0) {
                allSoldOut = NO;
                break;
            }
        }
    }
    else{
        allSoldOut = NO;
    }

    CheckCenterWarningView *view = [[CheckCenterWarningView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)andSoleOutProduct:array allSoldOut:allSoldOut];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:view];
    view.delegate = self;
}

#pragma mark --
#pragma mark -- warningview delegate --
- (void)didCancel:(CheckCenterWarningView *)view
{
}

- (void)didWantToSubmit:(CheckCenterWarningView *)view;
{
    if (!view.allSoldOut) {
        if (_autoSubmitting) {
            _autoSubmitting = NO;
            return;
        }
        _forAvailable = YES;
        _didPressContinue = YES;
        if (_didLoadResponse) {
            _didLoadResponse = NO;
            _autoSubmitting = YES;
            [self submittOrders:nil];
        }
    }
    else{
        //
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *vc = [delegate getNavigationVC:0];
        NSInteger selectedIndex = delegate.tabViewController.selectedIndex;
        delegate.tabViewController.selectedViewController = vc;
        if (self.isBuyNow) {
            [delegate.managedObjectContext deleteObject:[self.cartItems objectAtIndex:0]];
            [[CartItemAccessor sharedInstance] deleteObjectWithProductId:self.buyNowProductId];
        }
        UINavigationController *nav = [delegate getNavigationVC:selectedIndex];
        NSArray *array = nav.viewControllers;
        nav.viewControllers = @[[array objectAtIndex:0]];
    }
}

- (void)handleSoldoutProducts:(NSArray *)array
{
    if ([array count] == 0) {
        return;
    }
    if ([array count] == [self.cartItems count]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"你挑选的商品都售罄了, 请重新挑选" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)showUserSubmittingMessage:(NSString *)message
{
    [MBProgressHUD showError:message toView:self.view];
}

#pragma mark - 添加地址
- (void)showAddressViewController:(UIButton *)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAddressViewController *addAddressVC = [storyBoard instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    addAddressVC.opration = AddressOperationAdd;
    addAddressVC.title = @"添加地址";
    [self.navigationController pushViewController:addAddressVC animated:YES];
}

#pragma mark - 设置库币显示数量
- (void)setKuCoinButtonTitle:(int)num
{
    NSString *string = [NSString stringWithFormat:@"%d", num];
    if (0 == num) {
        string = @"";
    }
    [self.kuCoinNumberLabel setText:string];
}

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

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%s", __FUNCTION__);
    if (textField == self.nameTextField) {
        self.userName = textField.text;
    } else if (textField == self.phoneTextField) {
        self.userPhone = textField.text;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        self.userName = textField.text;
    } else if (textField == self.phoneTextField) {
        self.userPhone = textField.text;
    }
    [textField resignFirstResponder];
}

#pragma mark --- change the heights of views ---
- (void)setCouponViewHeight:(CGFloat)height
{
    CGFloat originHeight = self.couponHeightConstraint.constant;
    
    [UIView animateWithDuration:.3f animations:^{
        self.couponHeightConstraint.constant = height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat scrollHeight = self.scrollView.contentSize.height;
        CGFloat contentHeight = scrollHeight - originHeight + height;
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, contentHeight)];
    }];
}

- (void)setDeliveryViewHeight:(CGFloat)height
{
    CGFloat originHeight = self.deliveryHeightConstraints.constant;
    
    [UIView animateWithDuration:.3f animations:^{
        self.deliveryHeightConstraints.constant = height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat contentHeight = self.scrollView.contentSize.height - originHeight + height;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
    }];
}

- (void)setPaymentViewHeight:(CGFloat)height
{
    CGFloat originHeight = self.paymentHeightConstraint.constant;
    
    [UIView animateWithDuration:.3f animations:^{
        self.paymentHeightConstraint.constant = height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat contentHeight = self.scrollView.contentSize.height - originHeight + height;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
    }];
}

- (void)setInvoiceViewHeight:(CGFloat)height
{
    CGFloat originHeight = self.invoiceHeightConstaint.constant;
    
    [UIView animateWithDuration:.3f animations:^{
        self.invoiceHeightConstaint.constant = height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat contentHeight = self.scrollView.contentSize.height - originHeight + height;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
    }];
    if (height <= 0) {
        [self setINvoiceTopGap:0];
    }
}

- (void)setProductViewHeight:(CGFloat)height
{
    CGFloat originHeight = self.productHeightConstraint.constant;
    
    [UIView animateWithDuration:.3f animations:^{
        self.productHeightConstraint.constant = height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat scrollHeight = self.scrollView.contentSize.height;
        CGFloat contentHeight = scrollHeight - originHeight + height;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
    }];
}

- (void)setOrderViewHeight:(CGFloat)height
{
    CGFloat originHeight = self.orderHeightConstraint.constant;
    
    [UIView animateWithDuration:.3f animations:^{
        self.orderHeightConstraint.constant = height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat contentHeight = self.scrollView.contentSize.height - originHeight + height;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
    }];
}

- (void)setINvoiceTopGap:(CGFloat)spaceDistance
{
    CGFloat gap = self.invoiceTopConstraint.constant;
    
    [UIView animateWithDuration:.3f animations:^{
        self.invoiceTopConstraint.constant = spaceDistance;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat contentHeight = self.scrollView.contentSize.height - gap + spaceDistance;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight);
    }];
}


#pragma mark - KeyBoard
- (void)keyboardDidAppear:(NSNotification *)notification
{
    if (!_keyboardDidAppear) {
        _keyboardDidAppear = YES;
        CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        CGSize contentSize = self.scrollView.contentSize;
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + rect.size.height);
    }
}

- (void)keyboardDidDisappear:(NSNotification *)notification
{
    if (_keyboardDidAppear) {
        _keyboardDidAppear = NO;
        CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        CGSize contentSize = self.scrollView.contentSize;
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height - rect.size.height);
    }
}

- (void)getCheckoutResponse:(BOOL)forAvailable
{
    
    NSString *productInfo;
    NSArray *array = self.cartItems;
    for (CartItem *cartItem in array) {
        int16_t number = cartItem.quantity;
        if (forAvailable) {
            number = cartItem.availableAmount;
            if (cartItem.inventoryStatus == 2) {
                continue;
            }
        }
        
        NSString *proInfo = [NSString stringWithFormat:@"{\"productId\":%@,\"quantity\":%d,\"type\":%d,\"areaType\":%hd}",cartItem.productId, number, 0, cartItem.areaType];
        if (productInfo == nil) {
            productInfo = proInfo;
        }
        else{
            productInfo = [NSString stringWithFormat:@"%@,%@", productInfo, proInfo];
        }
    }
    if (productInfo == nil) {
        return;
    }
    productInfo = [[NSString stringWithFormat:@"\"cartItems\":[%@]", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AddressEntity *addressEntity = [[AddressDataAccessor sharedInstance] getDefaulAddress];
    if (addressEntity) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"shippingId\":\"%lld\"", addressEntity.addressId]];
    }
    productInfo = [productInfo stringByAppendingString:@",\"aid\":1"];
    productInfo = [[NSString stringWithFormat:@"{%@}", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    ///////////////////////////////////////////////
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/cartshowconfirm.action?upkey=%@&cart=%@&areaType=%d", [upKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], productInfo, _currentAreaType];
    
    __weak typeof(CustomerOrderViewController *) weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        
        typeof(CustomerOrderViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *receiveDic = (NSDictionary *)jsonResponse;
                        NSDictionary *rp_result = [receiveDic objectForKey:@"rp_result"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (0 == [[rp_result objectForKey:@"recode"] intValue]) {
                                strongSelf.jsonDictionary = rp_result;
                                strongSelf.productArray = [[rp_result objectForKey:@"cart"] objectForKey:@"cartItems"];
                                strongSelf.payAndDeliver = [rp_result objectForKey:@"payAndDeliver"];
                                
                                strongSelf.allDeliversArray = [NSMutableArray array];
                                strongSelf.allPayTypesArray = [NSMutableArray array];
                                for (int i = 0; i < [strongSelf.payAndDeliver count]; ++i) {
                                    NSDictionary *dic = [strongSelf.payAndDeliver objectAtIndex:i];
                                    NSDictionary *deliver = [dic objectForKey:@"deliver"];
                                    NSArray *payTypes = [dic objectForKey:@"payTypes"];
                                    [strongSelf.allDeliversArray addObject:deliver];
                                    [strongSelf.allPayTypesArray addObject:payTypes];
                                }
                            }
                            if (_noAddress) {
                                [strongSelf setDeliverAddressView];
                                [strongSelf handleDeliveryTargetViewAction:[strongSelf.deliveryTargetView.gestureRecognizers firstObject]];
                            } else {
                                NSArray *array = [[AddressDataAccessor sharedInstance] getAllAddresse];
                                [strongSelf updateExpressViewWithAddressArray:array express:YES];
                            }
                            
                        });
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_noAddress) {
                            [strongSelf setDeliverAddressView];
                            [strongSelf handleDeliveryTargetViewAction:[strongSelf.deliveryTargetView.gestureRecognizers firstObject]];
                        } else {
                            NSArray *array = [[AddressDataAccessor sharedInstance] getAllAddresse];
                            [strongSelf updateExpressViewWithAddressArray:array express:YES];
                        }
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_noAddress) {
                        [strongSelf setDeliverAddressView];
                        [strongSelf handleDeliveryTargetViewAction:[strongSelf.deliveryTargetView.gestureRecognizers firstObject]];
                    } else {
                        NSArray *array = [[AddressDataAccessor sharedInstance] getAllAddresse];
                        [strongSelf updateExpressViewWithAddressArray:array express:YES];
                    }
                });
            }
        }
    }];
}

@end
