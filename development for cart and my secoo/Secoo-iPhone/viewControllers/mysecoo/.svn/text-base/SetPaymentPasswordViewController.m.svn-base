//
//  SetPaymentPasswordViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/7/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "SetPaymentPasswordViewController.h"

@interface SetPaymentPasswordViewController ()

@property(nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property(nonatomic, weak) IBOutlet UITextField *passwordAgainTextField;
- (IBAction)submit:(id)sender;

@end

@implementation SetPaymentPasswordViewController

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
    [MobClick beginLogPageView:@"SetPaymentPassword"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SetPaymentPassword"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//提交按钮
- (IBAction)submit:(id)sender
{
    
}

#pragma mark - UITextField Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
