//
//  FindPaymentPasswordViewController.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-10-8.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "FindPaymentPasswordViewController.h"

@interface FindPaymentPasswordViewController ()

@property(nonatomic, weak) IBOutlet UITextField *codeTextField;
@property(nonatomic, weak) IBOutlet UIImageView *codeImageView;
@property(nonatomic, weak) IBOutlet UILabel     *warningLabel;
- (IBAction)submit:(id)sender;

@end

@implementation FindPaymentPasswordViewController

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
    [MobClick beginLogPageView:@"FindPaymentPassword"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FindPaymentPassword"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender
{
    
}

#pragma mark - UITextField Delegate Method
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
