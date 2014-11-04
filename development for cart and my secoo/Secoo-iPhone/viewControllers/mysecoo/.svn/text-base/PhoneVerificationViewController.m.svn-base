//
//  PhoneVerificationViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/7/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "PhoneVerificationViewController.h"
#import "PhoneVerficationDetailViewController.h"

@interface PhoneVerificationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *captchaField;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)submit:(id)sender;
@end

@implementation PhoneVerificationViewController

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
    
    [MobClick beginLogPageView:@"PhoneVerification"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"PhoneVerification"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)submit:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhoneVerficationDetailViewController *phoneVerficationDVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PhoneVerficationDetailViewController"];
    [self.navigationController pushViewController:phoneVerficationDVC animated:YES];
}
@end
