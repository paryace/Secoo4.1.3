//
//  SecooInfoTableViewController.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-15.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "SecooInfoTableViewController.h"
#import "SecooInfoOriginViewController.h"
#import "SecooInfoBrandTableViewController.h"

@interface SecooInfoTableViewController ()

@end

@implementation SecooInfoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"关于寺库";
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
    
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self setExtraCellLineHidden:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AboutSecooInfo"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"AboutSecooInfo"];
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

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SECOO_INFO_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (!_IOS_7_LATER_) {
            cell.textLabel.font = [UIFont systemFontOfSize:17];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (0 == indexPath.row) {
        cell.textLabel.text = @"寺库起源";
    } else if (1 == indexPath.row) {
        cell.textLabel.text = @"旗下品牌";
    } else if (2 == indexPath.row) {
        cell.textLabel.text = @"集团荣誉";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        SecooInfoOriginViewController *secooInfoOriginVC = [[SecooInfoOriginViewController alloc] init];
        secooInfoOriginVC.navigationItem.title = @"寺库起源";
        secooInfoOriginVC.secooInfoName = SecooInfoOrigin;
        [self.navigationController pushViewController:secooInfoOriginVC animated:YES];
    } else if (1 == indexPath.row) {
        SecooInfoBrandTableViewController *secooInfoBrandTVC = [[SecooInfoBrandTableViewController alloc] initWithStyle:UITableViewStylePlain];
        secooInfoBrandTVC.navigationItem.title = @"旗下品牌";
        [self.navigationController pushViewController:secooInfoBrandTVC animated:YES];
    } else if (2 == indexPath.row) {
        SecooInfoOriginViewController *secooHonorVC = [[SecooInfoOriginViewController alloc] init];
        secooHonorVC.navigationItem.title = @"集团荣誉";
        secooHonorVC.secooInfoName = SecooInfoHonor;
        [self.navigationController pushViewController:secooHonorVC animated:YES];
    }
}

@end
