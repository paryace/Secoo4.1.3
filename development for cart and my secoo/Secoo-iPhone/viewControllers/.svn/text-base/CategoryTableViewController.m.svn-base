//
//  CategoryTableViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "AppDelegate.h"
#import "CategoryTableViewCell.h"
#import "CategoryEntity.h"
#import "CategoryURLSession.h"
#import "CategoryDetailTableViewController.h"
#import "CategoryDetailURLSession.h"
#import "DottedRectangleView.h"

#define CategoryCellReuseIdentifier @"categorycellIdentifier"

@interface CategoryTableViewController ()<NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL didLoad;
@end

@implementation CategoryTableViewController

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
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = appdelegate.managedObjectContext;
    [self.tableView registerClass:[CategoryTableViewCell class] forCellReuseIdentifier:CategoryCellReuseIdentifier];
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.rowHeight = 50;
    _didLoad = NO;
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        [self startDownloading];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStatusChanged) name:kReachabilityChangedNotification object:nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //友盟统计
    [MobClick endLogPageView:@"listPage"];
    [ManagerDefault standardManagerDefaults].isUsed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //友盟统计
    [MobClick endLogPageView:@"listPage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startDownloading
{
    if (!_didLoad) {
        _didLoad = YES;
        CategoryURLSession *session = [[CategoryURLSession alloc] init];
        session.observerViewController = self;
        [session startConnectionToURL:@"http://iphone.secoo.com/appservice/iphone/classification.action"];
    }
}

#pragma mark --
#pragma mark --
- (void)netWorkStatusChanged
{
    [self startDownloading];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger num = [self.fetchedResultsController.sections count];
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellReuseIdentifier forIndexPath:indexPath];
    // Configure the cell...
    //NSLog(@"configure index: %d", indexPath.row);
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if ( [reachability currentReachabilityStatus]!= NotReachable) {
        CategoryEntity *categories = [self.fetchedResultsController objectAtIndexPath:indexPath];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CategoryDetailTableViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailTableViewController"];
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        detailVC.categoryId = [object valueForKeyPath:@"categoryId"];
        detailVC.listType = ListCategoryType;
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.title = [categories valueForKey:@"name"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else{
        [MBProgressHUD showError:@"亲，没有网络连接哦！" toView:self.navigationController.view];
    }
}

// This method will be called on a secondary thread. Forward to the main thread for safe handling of UIKit objects.
- (void)updateMainContext:(NSNotification *)saveNotification
{
    if ([NSThread isMainThread]) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) {
            NSLog(@"fetch controller fetch error");
        }else{
            [self.tableView reloadData];
        }
    } else {
        [self performSelectorOnMainThread:@selector(updateMainContext:) withObject:saveNotification waitUntilDone:NO];
    }
}

- (void)configureCell:(CategoryTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CategoryEntity *categories = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIImage *icon = [UIImage imageWithData:[categories valueForKey:@"icon"]];
    cell.customImageView.image = icon;
    
    NSString *name = [categories valueForKey:@"name"];
    cell.customTextLabel.text = name;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CategoryEntityName];
    [request setFetchBatchSize:20];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"sortkey" ascending:YES];
    [request setSortDescriptors:@[sorter]];
    
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController = fetchController;
    
    NSError *error;
    if (![fetchController performFetch:&error]) {
        NSLog(@"fetch controller fetching error");
    }
    return _fetchedResultsController;
}

@end
