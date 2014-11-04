//
//  RegistrationTableViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/15/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "RegistrationTableViewController.h"
#import "Utils.h"
#import "UserInfoManager.h"
#import "ImageDownloaderManager.h"
#import "NSString+MD5Addition.h"
#import "UserInfoManager.h"
#import "LGURLSession.h"

@interface RegistrationTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *captchaTexField;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (weak, nonatomic) IBOutlet UIButton    *registrationButton;
@property (assign, nonatomic) BOOL downloading;

- (IBAction)changeCaptcha:(id)sender;
- (IBAction)startRegistration:(id)sender;

@end

@implementation RegistrationTableViewController

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
    self.title = @"注册";
    self.registrationButton.layer.cornerRadius = 3;
    if ([self.navigationController.viewControllers count] == 1) {
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelRegistration)];
        self.navigationItem.leftBarButtonItem = cancel;
    } else {
        UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpace.width = -10;
        UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
        self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    }
    
    [self downloadCaptchaImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"Registration"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Registration"];
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.captchaTexField resignFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 44);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --
#pragma mark --utilities
- (void)downloadCaptchaImage
{
    //example http://iphone.secoo.com/getVerifyCode.action?uuid=0.6376385423354805&r=0.3305563819594681
    if (self.downloading) {
        return;
    }
    self.downloading = YES;
    NSString *udid = [UserInfoManager getDeviceUDID];
    NSString *randomStr = [NSString stringWithFormat:@"%d", arc4random()];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getVerifyCode.action?uuid=%@&r=%@", udid, randomStr];
    ImageDownloader *downloader = [[ImageDownloader alloc] init];
    __weak typeof(RegistrationTableViewController) *weakSelf = self;
    [downloader startDownloadImageFromURL:url cached:NO completionHandler:^(NSString *url, UIImage *image, NSError *error) {
        if (error == nil) {
            if (weakSelf && image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.captchaImageView.image = image;
                    weakSelf.downloading = NO;
                });
            }
        }
        else{
            NSLog(@"download captcah image error");
        }
    }];
}

- (NSString *)getAccountString
{
    NSString *number = [Utils stringbyRmovingSpaceFromString:self.phoneNumberTextField.text];
    NSArray *strArray = [number componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    if ([strArray count] > 1 || number == nil) {
        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，你输入的号码格式有误" cancelTitle:@"重来"];
    }
    else if ([number length] != 11){
        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，输入的手机号码不是11位哦。" cancelTitle:@"重来"];
    }
    else{
        //number is the number
        return number;
    }
    return nil;
}

- (NSString *)getPassword
{
    if (self.passwordTextField.text ==  nil || [self.passwordTextField.text isEqualToString:@""]) {
        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，请输入你的密码哦" cancelTitle:@"重来"];
        return nil;
    }
    else if ([self.passwordTextField.text length] < 6){
        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，密码至少要6位哦" cancelTitle:@"重来"];
        return nil;
    }
    return [self.passwordTextField.text stringFromMD5];
}

- (NSString *)getCaptcha
{
    if (_captchaTexField.text == nil || [_captchaTexField.text isEqualToString:@""]) {
        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，请输入验证码哦" cancelTitle:@"重来"];
        return nil;
    }
    return _captchaTexField.text;
}


- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles: nil];
    [alertView show];
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
#pragma mark -- callbacks--
- (IBAction)changeCaptcha:(id)sender
{
    [self downloadCaptchaImage];
}

- (void)cancelRegistration
{
    if (_delegate && [_delegate respondsToSelector:@selector(cancelRegistration)]) {
        [_delegate cancelRegistration];
    }
    NSArray *array = self.navigationController.viewControllers;
    if ([array count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)startRegistration:(id)sender
{
    NSString *phoneNumber = [self getAccountString];
    if (phoneNumber == nil) {
        return;
    }
    NSString *password = [self getPassword];
    if (password == nil) {
        return;
    }
    NSString *captcha = [self getCaptcha];
    if (captcha == nil) {
        return;
    }
    NSString *udid = [UserInfoManager getDeviceUDID];
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *urlRef = [NSString stringWithFormat:@"http://iphone.secoo.com$_$%@$_$%@", versionStr, [_CHANNEL_ID_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *url = [NSString stringWithFormat:@"http://m.secoo.com/getAjaxData.action?vo.password=%@&client=iphone&method=secoo.user.registByPhone&urlfilter=userCenter.mo&vo.phone=%@&verifycode=%@&uuid=%@&urlref=%@", password, phoneNumber, captcha, udid, urlRef];
    __weak typeof(RegistrationTableViewController) *weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"]; //upKey
                if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                    //[UserInfoManager setUserID:[jsonDict objectForKey:@"uid"]];
                    [UserInfoManager setUserPhoneNumber:phoneNumber];
                    [UserInfoManager setUserUpKey:[jsonDict objectForKey:@"upKey"]];
                    [UserInfoManager setLogState:YES];
                    if (weakSelf) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (_delegate && [_delegate respondsToSelector:@selector(didRegister)]) {
                                [_delegate didRegister];
                            }
                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                            
                            //友盟统计
                            [MobClick event:@"iOS_newZhuce"];
                            //存储注册成功的时间
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:@"yyyy-MM-dd"];
                            NSDate *dateNow = [NSDate date];
                            NSString *dateNowString = [formatter stringFromDate:dateNow];
                            [[NSUserDefaults standardUserDefaults] setObject:dateNowString forKey:@"registerSuccess"];
                        });
                    }
                }
                else if([[jsonDict objectForKey:@"recode"] integerValue] == 1007){
                    
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
            NSLog(@"registration error");
        }
    }];
}
@end
