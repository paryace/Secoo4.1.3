//
//  SecooServiceTableViewController.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-10-17.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "SecooServiceTableViewController.h"
#import "DetailViewController.h"

@interface SecooServiceTableViewController ()

@property(nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SecooServiceTableViewController

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
    
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];

    self.title = @"寺库客服";
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.tableHeaderView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"SecooService"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"SecooService"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"400 658 6659" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        [alertView show];
    } else if (1 == indexPath.row) {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.urlString = MAINTAIN_SERVICE;
        detailVC.navTitle = @"养护说明";
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if (2 == indexPath.row) {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.urlString = AFTER_SERVICE;
        detailVC.navTitle = @"售后服务";
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼叫
    if (1 == buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006586659"]];
    }
}

@end
