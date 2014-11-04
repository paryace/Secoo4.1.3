//
//  SecooInfoBrandTableViewController.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-15.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "SecooInfoBrandTableViewController.h"
#import "SecooInfoOriginViewController.h"

@interface SecooInfoBrandTableViewController ()

@end

@implementation SecooInfoBrandTableViewController

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
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = back;
    
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
    
    [MobClick beginLogPageView:@"SecooInfoBrand"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SecooInfoBrand"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELL_INFO_BRAND";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (!_IOS_7_LATER_) {
            cell.textLabel.font = [UIFont systemFontOfSize:17];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"网上商城";
            break;
        case 1:
            cell.textLabel.text = @"库会所";
            break;
        case 2:
            cell.textLabel.text = @"鉴定中心";
            break;
        case 3:
            cell.textLabel.text = @"养护中心";
            break;
        case 4:
            cell.textLabel.text = @"寺库商学院";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecooInfoOriginViewController *secooVC = [[SecooInfoOriginViewController alloc] init];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    secooVC.navigationItem.title = cell.textLabel.text;
    switch (indexPath.row) {
        case 0:
            secooVC.secooInfoName = SecooInfoShopstore;
            break;
        case 1:
            secooVC.secooInfoName = SecooInfoClub;
            break;
        case 2:
            secooVC.secooInfoName = SecooInfoAuthenticate;
            break;
        case 3:
            secooVC.secooInfoName = SecooInfoConserve;
            break;
        case 4:
            secooVC.secooInfoName = SecooInfoSchool;
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:secooVC animated:YES];
}



@end
