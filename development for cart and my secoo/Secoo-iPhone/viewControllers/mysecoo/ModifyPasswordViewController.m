//
//  ModifyPasswordViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/16/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "LGURLSession.h"
#import "UserInfoManager.h"
#import "MBProgressHUD+Add.h"
#import "NSString+MD5Addition.h"

@interface ModifyPasswordViewController (){
    BOOL _didAppear;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;
@property (weak, nonatomic) IBOutlet UITextField *comfirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)submit:(id)sender;
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改登录密码";
    self.submitButton.layer.cornerRadius = 3;
    
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    _didAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ModifyPassword"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"ModifyPassword"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.scrollView.contentSize.height < 100) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
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

#pragma mark - 返回按钮响应方法
- (void)backToPreviousViewController:(UIBarButtonItem *)sender
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

#pragma mark --
#pragma mark -- callbacks --

- (void)keyboardDidAppear:(NSNotification *)notification
{
    if (!_didAppear) {
        _didAppear = YES;
        CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        CGSize contentSize = self.scrollView.contentSize;
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + rect.size.height / 2.0);
    }
}

- (void)keyboardDidDisappear:(NSNotification *)notification
{
    if (_didAppear) {
        _didAppear = NO;
        CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        CGSize contentSize = self.scrollView.contentSize;
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height - rect.size.height / 2.0);
    }
}

- (IBAction)submit:(id)sender
{
    if (self.PasswordField.text == nil) {
        [Utils showAlertMessage:@"密码不能为空" title:@"错误"];
        return;
    }
    if (![self.PasswordField.text isEqualToString:self.comfirmPasswordField.text]) {
        [Utils showAlertMessage:@"两次输入的密码不匹配" title:@"错误"];
        return;
    }
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=userCenter.mo&v=1.0&client=1&userInfoVO.newLoginPassword=%@&userInfoVO.loginPassword=%@&userInfoVO.upKey=%@&method=secoo.user.modifyPassWord", [self.PasswordField.text stringFromMD5], [self.oldPasswordField.text stringFromMD5], upKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(ModifyPasswordViewController *) weakSelf = self;
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(ModifyPasswordViewController *) strongSelf = weakSelf;
        if (error == nil) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if (strongSelf) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                            [MBProgressHUD showSuccess:@"修改成功" toView:strongSelf.view];
                            [strongSelf performSelector:@selector(goBack) withObject:nil afterDelay:1.0];
                        }
                        else{
                            [MBProgressHUD showError:@"修改失败，请重试" toView:strongSelf.view];
                        }
                    });
                }
            }
            else{
                NSLog(@"parsing error");
            }
        }
        else{
            NSLog(@"change password error:%@", error.description);
        }
    }];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
