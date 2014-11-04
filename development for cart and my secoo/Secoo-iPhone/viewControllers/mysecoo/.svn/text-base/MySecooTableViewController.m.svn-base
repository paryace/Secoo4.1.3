//
//  MySecooTableViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/15/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "MySecooTableViewController.h"
#import "UserInfoTableViewController.h"
#import "LoginTableViewController.h"
#import "SecooInfoTableViewController.h"
#import "RegistrationTableViewController.h"
#import "UserInfoManager.h"
#import "UMFeedback.h"
#import "UserInfoManager.h"
#import "UINavigationBar+CustomNavBar.h"
#import "CouponViewController.h"
#import "KuCoinViewController.h"
#import "OrderListViewController.h"
#import "AddressViewController.h"
#import "SecooServiceTableViewController.h"

@interface MySecooTableViewController ()<LoginDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumberLabel;
@property (strong, nonatomic) NSIndexPath *logInIndexPath;
@end

@implementation MySecooTableViewController

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
    
    self.tableView.sectionHeaderHeight = 0;
//    float version = floorf(NSFoundationVersionNumber);
//    if ((version > NSFoundationVersionNumber_iOS_6_1)) {
//        self.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
//    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserInfoManager didSignIn]) {
        self.tableView.tableHeaderView = nil;
        UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleBordered target:self action:@selector(handleRightBarButtonItemAction:)];
        self.navigationItem.rightBarButtonItem = logOut;
        self.userPhoneNumberLabel.text = [UserInfoManager userPhoneNumber];
    } else {
        [self addHeaderTableView];
        self.navigationItem.rightBarButtonItem = nil;
        self.userPhoneNumberLabel.text = nil;
    }
    
    [MobClick beginLogPageView:@"MySecoo"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MySecoo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//退出登录
- (void)handleRightBarButtonItemAction:(UIBarButtonItem *)sender
{
    [UserInfoManager setLogState:NO];
    [self addHeaderTableView];
    self.userPhoneNumberLabel.text = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    UIWebView *webView = [(AppDelegate *)[UIApplication sharedApplication].delegate webView];
    [webView stringByEvaluatingJavaScriptFromString:@"deleteUpKeyFromJS()"];
}

- (void)addHeaderTableView
{
    CGFloat headerHeight = 60;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
    headerView.backgroundColor = [UIColor redColor];
    CGFloat gap = 10, height = 30;
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(gap, (headerHeight - height) / 2.0, (self.view.frame.size.width - gap * 3) / 2.0, height)];
    [loginButton addTarget:self action:@selector(logIn:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:MAIN_YELLOW_COLOR forState:UIControlStateNormal];
    [headerView addSubview:loginButton];
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(gap / 2 + self.view.frame.size.width / 2, (headerHeight - height) / 2.0, (self.view.frame.size.width - gap * 3) / 2.0, height)];
    [headerView addSubview:registerButton];
    [registerButton addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:MAIN_YELLOW_COLOR forState:UIControlStateNormal];
    
    headerView.backgroundColor = BACKGROUND_COLOR;
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
}

#pragma mark --
#pragma mark -- callbacks 

- (void)logIn:(UIButton *)button
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginTableViewController *logInVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logInVC];
    [nav.navigationBar customNavBar];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)registerUser:(UIButton *)button
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistrationTableViewController *registrationVC = [storyboard instantiateViewControllerWithIdentifier:@"RegistrationTableViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registrationVC];
    [nav.navigationBar customNavBar];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark --
#pragma mark -- LoginDelegate --
- (void)didLogin
{
    if(self.logInIndexPath){
        UIViewController *vc = [self getViewControllerForIndex:self.logInIndexPath];
        if (vc == nil) {
            return;
        }
        NSArray *vcs = self.navigationController.viewControllers;
        NSMutableArray *array = [NSMutableArray arrayWithArray:vcs];
        [array addObject:vc];
        self.navigationController.viewControllers = array;
    }
}

- (void)didCancelLogin
{
    self.logInIndexPath = nil;
}

#pragma mark --
#pragma mark -- UITableViewDelegate--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![UserInfoManager didSignIn]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (indexPath.section == 0 || indexPath.section == 1) {
            self.logInIndexPath = indexPath;
            LoginTableViewController *logInVC = [storyBoard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
            logInVC.delegate = self;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logInVC];
            [nav.navigationBar customNavBar];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
    }
    [self pushViewControllerWithIndexPath:indexPath];
}

- (void)pushViewControllerWithIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section || 1 == indexPath.section) {
        UIViewController *vc = [self getViewControllerForIndex:indexPath];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (2 == indexPath.section) {
        if (0 == indexPath.row) {
            //关于寺库
            SecooInfoTableViewController *secooInfoTVC = [[SecooInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            secooInfoTVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:secooInfoTVC animated:YES];
        } else if (1 == indexPath.row) {
            //寺库客服
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SecooServiceTableViewController *secooServiceTVC = [storyBoard instantiateViewControllerWithIdentifier:@"SecooServiceTableViewController"];
            secooServiceTVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:secooServiceTVC animated:YES];
            
        } else if (2 == indexPath.row) {
            //给寺库评分
            NSString *appStoreString = @"itms://itunes.apple.com/cn/app/si-ku-she-chi-pin/id644873678?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreString]];
        } else if (3 == indexPath.row) {
            //用户反馈 TODO
            [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
        }
    }
}

- (UIViewController *)getViewControllerForIndex:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (0 == indexPath.section) {
        if (indexPath.row == 0) {
            UserInfoTableViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoTableViewController"];
            userInfoVC.hidesBottomBarWhenPushed = YES;
            return userInfoVC;
        }
        else if (indexPath.row == 1){//order list
            OrderListViewController *orderListVC = [storyBoard instantiateViewControllerWithIdentifier:@"OrderListViewController"];
            orderListVC.hidesBottomBarWhenPushed = YES;
            return orderListVC;
        } else if (2 == indexPath.row) {
            //我的拍卖
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.navTitle = @"我的拍卖";
            detailVC.urlString = AUCTION_URL;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else if (3 == indexPath.row) {
            //我的寄卖
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.navTitle = @"我的寄卖";
            detailVC.urlString = JIMAI_URL;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    else if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            CouponViewController *couponVC = [storyBoard instantiateViewControllerWithIdentifier:@"CouponViewController"];
            couponVC.hidesBottomBarWhenPushed = YES;
            return couponVC;
        }
        else if (1 == indexPath.row){
            KuCoinViewController *kuCoinVC = [storyBoard instantiateViewControllerWithIdentifier:@"KuCoinViewController"];
            kuCoinVC.hidesBottomBarWhenPushed = YES;
            kuCoinVC.type = RefillKuCoinType;
            return kuCoinVC;
        }
        else if (2 == indexPath.row){
            AddressViewController *addressVC = [storyBoard instantiateViewControllerWithIdentifier:@"AddressViewController"];
            addressVC.hidesBottomBarWhenPushed = YES;
            return addressVC;
        }
    }
    return nil;
}

@end
