//
//  UserInfoTableViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/15/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "AddressViewController.h"
#import "UserInfoManager.h"
#import "SafetyTableViewController.h"
#import "UpLoadCertificateViewController.h"
#import "CertificateManagedViewController.h"

@interface UserInfoTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinNumberLabel;
@end

@implementation UserInfoTableViewController

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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.title = @"账户信息";
    
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    [self setExtraCellLineHidden:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserInfoManager didSignIn]) {
        self.phoneNumberLabel.text = [UserInfoManager userPhoneNumber];
    }
    
    [MobClick beginLogPageView:@"UserInfo"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"UserInfo"];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 1) {
        //账户安全
        SafetyTableViewController *safetyVC = [storyBoard instantiateViewControllerWithIdentifier:@"SafetyTableViewController"];
        [self.navigationController pushViewController:safetyVC animated:YES];
    }
    else if (indexPath.row == 2){
        //证件管理
        if (0) {
            CertificateManagedViewController *certificateManagedVC = [storyBoard instantiateViewControllerWithIdentifier:@"CertificateManagedViewController"];
            certificateManagedVC.navigationItem.title = @"证件管理";
            [self.navigationController pushViewController:certificateManagedVC animated:YES];
        } else {
            UpLoadCertificateViewController *upLoadCertificateVC = [storyBoard instantiateViewControllerWithIdentifier:@"UpLoadCertificateViewController"];
            upLoadCertificateVC.navigationItem.title = @"证件管理";
            [self.navigationController pushViewController:upLoadCertificateVC animated:YES];
        }
    }
}
@end
