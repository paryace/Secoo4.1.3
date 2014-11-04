//
//  ChangePaymentPasswordViewController.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-10-8.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ChangePaymentPasswordViewController.h"

@interface ChangePaymentPasswordViewController ()

@property(nonatomic, weak) IBOutlet UITextField *passwordOldTextField;
@property(nonatomic, weak) IBOutlet UITextField *passwordNewTextField;
@property(nonatomic, weak) IBOutlet UITextField *passwordNewAgainTextField;
- (IBAction)submit:(id)sender;
- (IBAction)forgetPassword:(id)sender;

@end

@implementation ChangePaymentPasswordViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChangePaymentPassword"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChangePaymentPassword"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender
{
    
}

- (IBAction)forgetPassword:(id)sender
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
