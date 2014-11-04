//
//  KuCoinViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/28/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "KuCoinViewController.h"
#import "UserInfoManager.h"
#import "LGURLSession.h"
#import "MBProgressHUD+Add.h"
#import "DottedRectangleView.h"
#import "CartItem.h"

@interface KuCoinViewController (){
    BOOL _didAppear;
    BOOL _firstTime;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *kuCoinBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *kuCoinNumber;
@property (weak, nonatomic) IBOutlet UILabel *coinRuleLabel;
@property (weak, nonatomic) IBOutlet UILabel *refillRuleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIImageView *kuCoinImageView;

//
@property (weak, nonatomic) IBOutlet UILabel *useCoinNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *coinNumberTextfield;

@property (weak, nonatomic) IBOutlet UILabel *payPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *captchaLabel;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sendCaptchaButton;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;

- (IBAction)recharge:(id)sender;
- (IBAction)forgetPassword:(id)sender;
- (IBAction)sendCaptcha:(id)sender;
- (IBAction)comfirmUsingCoins:(id)sender;

@end

@implementation KuCoinViewController

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
    self.navigationItem.title = @"我的库币";
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    self.comfirmButton.layer.cornerRadius = 3;
//    self.kuCoinBackgroundView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    self.kuCoinBackgroundView.layer.borderWidth = 0.5;
    self.kuCoinBackgroundView.layer.cornerRadius = 5;
    DottedRectangleView *dottedRectangleView = [[DottedRectangleView alloc] initWithFrame:self.kuCoinBackgroundView.bounds];
    [self.kuCoinBackgroundView addSubview:dottedRectangleView];
    
    if (self.type == UsingKuCoinType) {
        _coinRuleLabel.alpha = 0.0;
        _refillRuleLabel.alpha = 0.0;
        _rechargeButton.alpha = 0.0;
    }
    else if (self.type == RefillKuCoinType) {
        _useCoinNumberLabel.alpha = 0.0;
        _coinNumberTextfield.alpha = 0.0;
        _payPasswordLabel.alpha = 0.0;
        _passwordTextfield.alpha = 0.0;
        _forgetPasswordButton.alpha = 0.0;
        _captchaLabel.alpha = 0.0;
        _captchaTextfield.alpha = 0.0;
        _sendCaptchaButton.alpha = 0.0;
        _comfirmButton.alpha = 0.0;
        self.lineView1.alpha = 0;
        self.lineView2.alpha = 0;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    [self getTotalKuCoins];
    _didAppear = NO;
    _firstTime = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"KuCoin"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"KuCoin"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = self.view.frame.size;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.scrollView.contentSize.height < 100) {
        _firstTime = YES;
    }
    if (_firstTime) {
        _firstTime = NO;
        if (!_IOS_8_LATER_) {
            if (_type == UsingKuCoinType) {
                CGFloat y = CGRectGetMaxY(_comfirmButton.frame) + 10;
                self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y);
                NSLog(@"h:%f", self.view.frame.size.height);
            }
            else if (_type == RefillKuCoinType){
                CGFloat y = self.view.frame.size.height;
                self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y);
            }
        }
    }
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --
#pragma mark -- callbacks--

- (void)keyboardDidAppear:(NSNotification *)notification
{
    if (_type == UsingKuCoinType) {
        if (!_didAppear) {
            CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
            CGSize contentSize = self.scrollView.contentSize;
            self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + rect.size.height);
            _didAppear = YES;
        }
    }
    
}

- (void)keyboardDidDisappear:(NSNotification *)notification
{
    if (_type == UsingKuCoinType) {
        if (_didAppear) {
            _didAppear = NO;
            CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
            CGSize contentSize = self.scrollView.contentSize;
            self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height - rect.size.height);
        }
    }
}

- (IBAction)recharge:(id)sender
{
   
}

- (IBAction)forgetPassword:(id)sender
{
}

- (IBAction)sendCaptcha:(id)sender
{
    [self.passwordTextfield resignFirstResponder];
    [self.coinNumberTextfield resignFirstResponder];
    [self.captchaTextfield resignFirstResponder];
    NSString *upKey = [[UserInfoManager getUserUpKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=kuPay/kuPay.jsp&v=1.0&client=iphone&method=getPayValidateNum&vo.upkey=%@", upKey];
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(KuCoinViewController *) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(KuCoinViewController*) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showSuccess:[jsonDict objectForKey:@"errMsg"] toView:strongSelf.view];
                        });
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:[jsonDict objectForKey:@"errMsg"] toView:strongSelf.view];
                        });
                    }
                }
            }
        }
    }];
}

- (IBAction)comfirmUsingCoins:(id)sender
{
    [self checkKuCoin];
}

- (void)checkKuCoin
{
    [self.comfirmButton setTitle:@"验证..." forState:UIControlStateNormal];
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=order/myorder.jsp&v=1.0&client=iphone&method=secoo.orders.validateKuPay&vo.upkey=%@&cart=%@", [upKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [self getCartItemString]];
   // url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(KuCoinViewController *) weakSelf = self;
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(KuCoinViewController *) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.comfirmButton setTitle:@"确定" forState:UIControlStateNormal];
        });
        
        if (strongSelf) {
            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(didUsingKuCoin:password:verificationNumber:)]) {
                                [strongSelf.delegate didUsingKuCoin:[strongSelf.coinNumberTextfield.text integerValue] password:strongSelf.passwordTextfield.text verificationNumber:strongSelf.captchaTextfield.text];
                            }
                            [strongSelf.navigationController popViewControllerAnimated:YES];
                        });
                        
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:[jsonDict objectForKey:@"errMsg"] toView:strongSelf.view];
                        });
                    }
                }
                else{
                    NSLog(@"parsing error");
                }
            }
        }
    }];
}

- (NSString *)getCartItemString
{
    NSString *productInfo;
    for (CartItem *cartItem in self.cartItems) {
        NSInteger num = cartItem.quantity;
        NSString *proInfo = [NSString stringWithFormat:@"{\"productId\":%@,\"quantity\":%d,\"type\":%d,\"areaType\":%hd}",cartItem.productId, num, 0, cartItem.areaType];
        if (productInfo == nil) {
            productInfo = proInfo;
        }
        else{
            productInfo = [NSString stringWithFormat:@"%@,%@", productInfo, proInfo];
        }
    }
    productInfo = [NSString stringWithFormat:@"\"cartItems\":[%@]", productInfo];
    
    NSString *kuCoinStr = [NSString stringWithFormat:@",\"isUseBalance\":1,\"payPassword\":\"%@\",\"phoneValidateNum\":\"%@\",\"useBalanceAmount\":\"%d\"", self.passwordTextfield.text, self.captchaTextfield.text, [self.coinNumberTextfield.text integerValue]];
    productInfo = [productInfo stringByAppendingString:kuCoinStr];
    
    productInfo = [[NSString stringWithFormat:@"{%@}", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return productInfo;
}

#pragma mark --
#pragma mark -- network --
- (void)getTotalKuCoins
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=account/myaccount.jsp&v=1.0&client=iphone&method=secoo.user.getBalanceInfo&vo.upkey=%@&fields=txBalance,xfBalance,zjBalance", upKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(KuCoinViewController *) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(KuCoinViewController*) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] intValue] == 0) {
                        NSDictionary *kuCoinDict = [jsonDict objectForKey:@"balanceInfo"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            strongSelf.kuCoinImageView.hidden = NO;
                            strongSelf.kuCoinNumber.text = [NSString stringWithFormat:@"%@库币",[kuCoinDict objectForKey:@"zjBalance"]];
                        });
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:[NSString stringWithFormat:@"获取库币出错：%@", [jsonDict objectForKey:@"errMsg"]] toView:strongSelf.view];
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

#pragma mark --
#pragma mark -- UITextFieldDelegate --

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
