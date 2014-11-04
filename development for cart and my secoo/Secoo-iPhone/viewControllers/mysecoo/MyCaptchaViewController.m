//
//  CaptchaViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "MyCaptchaViewController.h"
#import "LGURLSession.h"
#import "NSString+MD5Addition.h"

@interface CaptchaViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *captchaField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *comfirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (assign, nonatomic) BOOL isLoading;

- (IBAction)submit:(id)sender;

@end

@implementation CaptchaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self sendCaptcha];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"再次发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendCaptcha)];
    self.navigationItem.rightBarButtonItem = right;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = self.view.frame.size;
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

#pragma mark --
#pragma mark -- callbacks--

- (void)keyboardDidAppear:(NSNotification *)notification
{
    CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGSize contentSize = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + rect.size.height);
}

- (void)keyboardDidDisappear:(NSNotification *)notification
{
    CGRect rect = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGSize contentSize = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height - rect.size.height);
}

- (void)sendCaptcha
{
    if (self.isLoading) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=userCenter.mo&v=1.0&client=iphone&method=secoo.user.findPassword&vo.userName=%@&vo.step=2&vo.mobile=%@&vo.type=mobile", [Utils stringbyRmovingSpaceFromString:self.accountName], self.phoneNumber];
    __weak typeof(CaptchaViewController) *weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    self.isLoading = YES;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (weakSelf) {
            weakSelf.isLoading = NO;
            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSString *result = [jsonResponse objectForKey:@"result"];
                    if ([result isEqualToString:@"sucess"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showSuccess:[jsonResponse objectForKey:@"info"] toView:weakSelf.view];
                        });
                    }
                }
            }
            else{
                NSLog(@"sending verificaiton code error:%@", error.description);
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


- (IBAction)submit:(id)sender
{
    NSString *verificationCode = self.captchaField.text;
    NSString *password = [self.passwordField.text stringFromMD5];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=userCenter.mo&v=1.0&client=iphone&method=secoo.user.findPassword&vo.userName=%@&vo.step=3&vo.mobile=%@&vo.type=verify&vo.mobileCode=%@&vo.password=%@", [Utils stringbyRmovingSpaceFromString:self.accountName], self.phoneNumber, verificationCode, password];
    __weak typeof(CaptchaViewController) *weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (weakSelf) {
            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSString *result = [jsonResponse objectForKey:@"result"];
                    
                    if ([result isEqualToString:@"sucess"]) {
                        if (jsonError == nil) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD showSuccess:[jsonResponse objectForKey:@"info"] toView:weakSelf.view];
                                [weakSelf performSelector:@selector(goBack) withObject:nil afterDelay:1.0];
                            });
                        }
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf showAlertViewWithTitle:@"亲，错了" message:[jsonResponse objectForKey:@"info"] cancelTitle:@"重来"];
                        });
                    }
                }
                
            }
            else{
                NSLog(@"verification error:%@", error.description);
            }
            
        }
    }];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles: nil];
    [alertView show];
}

- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
