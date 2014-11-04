//
//  ActivateCouponViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/16/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "ActivateCouponViewController.h"
#import "LGURLSession.h"
#import "UserInfoManager.h"

@interface ActivateCouponViewController ()

@property (weak, nonatomic) IBOutlet UIButton *activateButton;
@property (weak, nonatomic) IBOutlet UITextField *couponPasswordField;


- (IBAction)activateCoupon:(id)sender;
@end

@implementation ActivateCouponViewController

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
    self.activateButton.layer.cornerRadius = 3;
    
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ActiveCoupon"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ActiveCoupon"];
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

- (IBAction)activateCoupon:(id)sender
{
    if (self.couponPasswordField.text == nil) {
        [Utils showAlertMessage:@"密码不能为空" title:@"错误"];
        return;
    }
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=ticket/myticket.jsp&v=1.0&client=iphone&method=secoo.subTicket&vo.ticketsnval=%@&vo.upkey=%@", self.couponPasswordField.text, upKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(ActivateCouponViewController *) weakSelf = self;
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(ActivateCouponViewController *) strongSelf = weakSelf;
        if (error == nil) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if (strongSelf) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                            [MBProgressHUD showSuccess:@"激活成功" toView:strongSelf.view];
                        }
                        else if ([[jsonDict objectForKey:@"recode"] integerValue] == -1){
                            [Utils showAlertMessage:@"此优惠券是过期优惠券，请激活其他优惠券" title:@"错误"];
                        }
                        else if ([[jsonDict objectForKey:@"recode"] integerValue] == 1){
                            [Utils showAlertMessage:@"优惠券密码无效，请重试" title:@"错误"];
                        }
                        else if ([[jsonDict objectForKey:@"recode"] integerValue] == 2){
                            [Utils showAlertMessage:@"此优惠券是已经被使用过了，请激活其他优惠券" title:@"错误"];
                        }
                        else if ([[jsonDict objectForKey:@"recode"] integerValue] == 3){
                            [Utils showAlertMessage:@"绑定用户失败!" title:@"错误"];
                        }
                        else if ([[jsonDict objectForKey:@"recode"] integerValue] == 4){
                            [Utils showAlertMessage:@"绑定用户失败!" title:@"错误"];
                        }
                        else{
                            [Utils showAlertMessage:@"激活失败，请重试" title:@"错误"];
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

@end
