//
//  ExchangeRateInfoViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/29/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "ExchangeRateInfoViewController.h"
#import "LGURLSession.h"
#import "UserInfoManager.h"

@interface ExchangeRateInfoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *identityCardField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicatorView;

- (IBAction)submit:(id)sender;
@end

@implementation ExchangeRateInfoViewController

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
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitExchangeInfo:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.phoneNumberField.text = [UserInfoManager userPhoneNumber];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ExchangeRateInfo"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"ExchangeRateInfo"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.view.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayActivityView
{
    if (self.activityIndicatorView == nil) {
        CGRect frame = CGRectMake((self.view.frame.size.width - 50) / 2.0, 160, 50, 50);
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [self.view addSubview:activityIndicator];
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.activityIndicatorView = activityIndicator;
    }
    [self.activityIndicatorView startAnimating];
}

#pragma mark --
#pragma mark -- callbacks --
- (void)submitExchangeInfo:(UIBarButtonItem *)rightButton
{
    if (![self checkValidationOfTextField]) {
        return;
    }
    [self submitUserInfoToServer];
    [self displayActivityView];
}

- (IBAction)submit:(id)sender
{
    if (![self checkValidationOfTextField]) {
        return;
    }
    [self submitUserInfoToServer];
    [self displayActivityView];
}

- (BOOL)checkValidationOfTextField
{
    if (![Utils isValidString:self.nameField.text]) {
        [MBProgressHUD showError:@"请填写名字" toView:self.view];
        return NO;
    }
    if (![Utils isValidString:self.identityCardField.text]) {
        [MBProgressHUD showError:@"请填写身份证号码" toView:self.view];
        return NO;
    }
    if (![Utils isValidString:self.phoneNumberField.text]) {
        [MBProgressHUD showError:@"请填写手机号码" toView:self.view];
        return NO;
    }
    if (![Utils isValidString:self.bankCardField.text]) {
        [MBProgressHUD showError:@"请填写银行卡号" toView:self.view];
        return NO;
    }
    return YES;
}

- (void)submitUserInfoToServer
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *userName = [self.nameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=exchange/UserExchange.jsp&v=1.0&client=iphone&vo.upkey=%@&method=secoo.exchange.insertUserInfo&realName=%@&cardNum=%@&mobile=%@&bankNo=%@", upKey, userName, self.identityCardField.text, self.phoneNumberField.text, self.bankCardField.text];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(ExchangeRateInfoViewController *) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(ExchangeRateInfoViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf.activityIndicatorView stopAnimating];
                            [strongSelf.activityIndicatorView removeFromSuperview];
                            if (_delegate && [_delegate respondsToSelector:@selector(didProvideExchangeRateInfo)]) {
                                [_delegate didProvideExchangeRateInfo];
                            }
                            [MBProgressHUD showError:@"提交成功！" toView:strongSelf.view];
                            [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:0.8];
                        });
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf.activityIndicatorView stopAnimating];
                            [strongSelf.activityIndicatorView removeFromSuperview];
                            [MBProgressHUD showError:[jsonDict objectForKey:@"retmsg"] toView:strongSelf.view];
                        });
                    }
                }
            }
            else{
                NSLog(@"writing user exchange user information failed:%@", error.description);
            }
        }
    }];
}

- (void)dismissSelf
{
    [self.navigationController popViewControllerAnimated:YES];
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
