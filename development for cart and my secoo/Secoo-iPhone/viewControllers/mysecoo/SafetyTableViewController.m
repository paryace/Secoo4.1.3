//
//  SafetyTableViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/7/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "SafetyTableViewController.h"
#import "PhoneVerificationViewController.h"
#import "SetPaymentPasswordViewController.h"
#import "ModifyPasswordViewController.h"

@interface SafetyTableViewController ()

@end

@implementation SafetyTableViewController

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
    self.title = @"账户安全";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"SafetyTVC"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"SafetyTVC"];
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

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 0) {
        //登录密码
        ModifyPasswordViewController *modifyPassowrdVC = [storyboard instantiateViewControllerWithIdentifier:@"ModifyPasswordViewController"];
        [self.navigationController pushViewController:modifyPassowrdVC animated:YES];
    }
    else if(indexPath.row == 1) {
        //手机验证
        PhoneVerificationViewController *phoneVerificationVC = [storyboard instantiateViewControllerWithIdentifier:@"PhoneVerificationViewController"];
        [self.navigationController pushViewController:phoneVerificationVC animated:YES];
    }
    else if (indexPath.row == 2) {
        //支付密码 TODO
        SetPaymentPasswordViewController *setPaymentPasswordVC = [storyboard instantiateViewControllerWithIdentifier:@"SetPaymentPasswordViewController"];
        [self.navigationController pushViewController:setPaymentPasswordVC animated:YES];
    }
}

@end
