//
//  FindPasswordTableViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/16/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "FindPasswordTableViewController.h"
#import "Utils.h"
#import "UserInfoManager.h"
#import "ImageDownloaderManager.h"
#import "NSString+MD5Addition.h"
#import "UserInfoManager.h"
#import "LGURLSession.h"
#import "MBProgressHUD+Add.h"
#import "MyCaptchaViewController.h"

@interface FindPasswordTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *captchaField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (assign, nonatomic) BOOL isDownloading;

- (IBAction)submit:(id)sender;

@end

@implementation FindPasswordTableViewController

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
    
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"FindPassword"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FindPassword"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 44);
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
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
#pragma mark -- Utilities--

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles: nil];
    [alertView show];
}

#pragma mark --
#pragma mark --callbacks --
- (IBAction)submit:(id)sender
{
    NSString *accountName = [Utils stringbyRmovingSpaceFromString:self.phoneNumberField.text];
    if (accountName == nil || [accountName isEqualToString:@""]) {
        [self showAlertViewWithTitle:@"亲，出错了" message:@"亲，你输入的账户名有误" cancelTitle:@"重来"];
        return;
    }
    [self.phoneNumberField resignFirstResponder];
    LGURLSession *session = [[LGURLSession alloc] init];
    [self.submitButton setTitle:@"发送中....." forState:UIControlStateNormal];
    
    //LGLGURL
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=userCenter.mo&v=1.0&client=iphone&method=secoo.user.findPassword&vo.userName=%@&vo.step=1", accountName];
    __weak typeof(FindPasswordTableViewController) *weakSelf = self;
    self.isDownloading = YES;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.submitButton setTitle:@"发送" forState:UIControlStateNormal];
        });
        weakSelf.isDownloading = NO;
        if (error == nil) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSString *result = [jsonResponse objectForKey:@"result"];
                
                if ([result isEqualToString:@"sucess"]) {
                    id jsonDict = [NSJSONSerialization JSONObjectWithData:[[jsonResponse objectForKey:@"info"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
                    NSString *choices = [jsonDict objectForKey:@"findPassChoices"];
                    if ([choices isEqualToString:@"all"] || [choices isEqualToString:@"mobile"]) {
                        NSString *phoneNumber = [jsonDict objectForKey:@"mobilePhone"];
                        if (weakSelf) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                CaptchaViewController *captchaVC = [storboard instantiateViewControllerWithIdentifier:@"CaptchaViewController"];
                                captchaVC.accountName = weakSelf.phoneNumberField.text;
                                captchaVC.phoneNumber = phoneNumber;
                                [weakSelf.navigationController pushViewController:captchaVC animated:YES];
                            });
                        }
                    }
                    else{
                        if (weakSelf) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf showAlertViewWithTitle:@"亲，错了" message:@"你没有绑定手机号码" cancelTitle:@"知道了"];
                                [weakSelf.submitButton setTitle:@"发送" forState:UIControlStateNormal];
                            });
                        }
                    }
                }
                else{
                    if (weakSelf) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf showAlertViewWithTitle:@"亲，错了" message:[jsonResponse objectForKey:@"info"] cancelTitle:@"重来"];
                            [weakSelf.submitButton setTitle:@"发送" forState:UIControlStateNormal];
                        });
                    }
                }
            }
            else{
                NSLog(@"parsing find password error :%@", error.description);
            }
        }
        else{
            NSLog(@"find password lgurlsession error:%@", error.description);
        }
    }];
}

@end
