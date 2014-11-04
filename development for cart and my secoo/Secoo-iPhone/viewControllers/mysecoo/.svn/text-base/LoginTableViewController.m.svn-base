//
//  LoginTableViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/15/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "LoginTableViewController.h"
#import "RegistrationTableViewController.h"
#import "FindPasswordTableViewController.h"
#import "Utils.h"
#import "Reachability.h"
#import "LGURLSession.h"
#import "NSString+MD5Addition.h"
#import "MBProgressHUD+Add.h"
#import "UserInfoManager.h"

@interface LoginTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)logIn:(id)sender;
- (IBAction)forgetPassword:(id)sender;
- (IBAction)signUp:(id)sender;
@end

@implementation LoginTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"用户登录";
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelLogIn)];
    self.navigationItem.leftBarButtonItem = cancel;
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = back;
    self.backView.backgroundColor = BACKGROUND_COLOR;
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.logInButton.layer.cornerRadius = 3;
    self.signUpButton.layer.cornerRadius = 3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"Login"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Login"];
    
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 64);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark -- Utilities--
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles: nil];
    [alertView show];
}

- (NSString *)getAccountString
{
    if (self.accountTextField.text == nil) {
        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，请输入账号" cancelTitle:@"重来"];
    }
    return self.accountTextField.text;
//    NSString *number = [Utils stringbyRmovingSpaceFromString:self.accountTextField.text];
//    NSArray *strArray = [number componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
//    if ([strArray count] > 1 || number == nil) {
//        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，你输入的号码格式有误" cancelTitle:@"重来"];
//    }
//    else if ([number length] != 11){
//        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，输入的手机号码不是11位哦。" cancelTitle:@"重来"];
//    }
//    else{
//        //number is the number
//        return number;
//    }
//    return nil;
}

- (NSString *)getPassword
{
    if (_passwordTextField.text == nil || [_passwordTextField.text isEqualToString:@""]) {
        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，请输入你得密码哦" cancelTitle:@"重来"];
        return nil;
    }
    NSString *password = [_passwordTextField.text stringFromMD5];
    [UserInfoManager setUserPassword:password];
    return password;
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

#pragma mark --
#pragma mark --callbacks--

- (IBAction)logIn:(id)sender
{
    NSString *account = [self getAccountString];
    if (account == nil) {
        return;
    }
    NSString *password = [self getPassword];
    if (password == nil) {
        return;
    }
    
    [sender setTitle:@"发送中..." forState:UIControlStateNormal];
    
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=userCenter.mo&v=1.0&client=iphone&method=secoo.user.login&vo.userName=%@&vo.password=%@", account, password];
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(LoginTableViewController *)weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil && data) {
            NSError *jsonError;//recode, uid, upKey
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                    [UserInfoManager setUserID:[jsonDict objectForKey:@"uid"]];
                    [UserInfoManager setUserPhoneNumber:account];
                    [UserInfoManager setUserUpKey:[jsonDict objectForKey:@"upKey"]];
                    [UserInfoManager setLogState:YES];
                    if (weakSelf) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //[MBProgressHUD showSuccess:@"登录成功" toView:weakSelf.view];
                            if (_delegate && [_delegate respondsToSelector:@selector(didLogin)]) {
                                [_delegate didLogin];
                            }
                            [weakSelf dismissViewControllerAnimated:YES completion:^{
                                //TODO 测试
                                [[[ManagerDefault standardManagerDefaults] currentWebView] stringByEvaluatingJavaScriptFromString:@"sendLoginResult('true')"];
                            }];
                        });
                    }
                }
                else if([[jsonDict objectForKey:@"recode"] integerValue] == 1007){
                    if (weakSelf) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf showAlertViewWithTitle:@"亲，出错了" message:@"填写的账户或密码有错误！" cancelTitle:@"重来"];
                            [sender setTitle:@"重新提交" forState:UIControlStateNormal];
                        });
                    }
                } else {
                    NSString *errMsg = [jsonDict objectForKey:@"errMsg"];
                    if (errMsg) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[errMsg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                            [alert show];
                        });
                    }
                }
            }
            else{
                NSLog(@"parsing error when getting login response");
            }
        }
        else{
            NSLog(@"login error:%@ ----%@", error.description, error.debugDescription);
        }
    }];
}

- (IBAction)forgetPassword:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FindPasswordTableViewController *registrationVC = [storyboard instantiateViewControllerWithIdentifier:@"FindPasswordTableViewController"];
    [self.navigationController pushViewController:registrationVC animated:YES];
}

- (IBAction)signUp:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistrationTableViewController *registrationVC = [storyboard instantiateViewControllerWithIdentifier:@"RegistrationTableViewController"];
    [self.navigationController pushViewController:registrationVC animated:YES];
}

- (void)cancelLogIn
{
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelLogin)]) {
        [_delegate didCancelLogin];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
