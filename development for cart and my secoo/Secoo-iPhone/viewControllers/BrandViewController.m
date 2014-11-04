//
//  BrandViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/2/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "BrandViewController.h"
#import "BrandDataAccessor.h"
#import "HotBrand.h"
#import "AllBrand.h"
#import "HotBrandCollectionViewCell.h"
#import "ImageDownloaderManager.h"
#import "BrandURLSession.h"
#import "Foundation/NSObjCRuntime.h"
#import "AppDelegate.h"
//#import "Reachability.h"
#import "CategoryDetailTableViewController.h"

@interface BrandViewController ()<BrandURLSessionDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isLoading;
    BOOL _noMorePage;
    BOOL _didLoadAllBrands;
    BOOL _isLoadingAllbrands;
}

//显示A-Z时的tableView
@property(nonatomic, weak) BrandTableView *brandTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//data source for collectionview
@property (strong, nonatomic) NSArray *brands;
@property (strong, nonatomic) NSMutableDictionary *downloadImageTasks;
@property (strong, nonatomic) NSString *hotBrandUrl;
@property (strong, nonatomic) NSString *allBrandUrl;

@property (assign, nonatomic) NSInteger currentPage;

//data source for tableview
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

//FIX: no network connection now, the user turn on it immediately. need to refresh;
@implementation BrandViewController

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
    self.collectionView.backgroundColor = BACKGROUND_COLOR;
    [self.collectionView registerClass:[HotBrandCollectionViewCell class] forCellWithReuseIdentifier:@"HotBrandCollectionViewCell"];
    [self loadDataAndRefresh];
    _currentPage = 1;
    self.hotBrandUrl = @"http://iphone.secoo.com/appservice/iphone/big_brand.action?";
    self.allBrandUrl = @"http://iphone.secoo.com/appservice/iphone/all_brand.action";
    [self loadHotBrandAtPage:_currentPage];
    
    _noMorePage = NO;
    _didLoadAllBrands = NO;
    _isLoadingAllbrands = NO;
    
    float version = floorf(NSFoundationVersionNumber);
    if ((version > NSFoundationVersionNumber_iOS_6_1)) {
        CGFloat width = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
        CGFloat bottomInset = self.tabBarController.tabBar.frame.size.height;
        self.collectionView.contentInset = UIEdgeInsetsMake(-width, 0, -bottomInset, 0);
    }
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = appdelegate.managedObjectContext;
    
    //设置切换大小图按钮
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"A-Z" style:UIBarButtonItemStyleBordered target:self action:@selector(handleRightBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotBrandDataChanged) name:BrandDataDidChangedNotification object:[BrandDataAccessor sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStatusChanged) name:kReachabilityChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.brandTableView) {
        NSIndexPath *indexPath = [self.brandTableView.tableView indexPathForSelectedRow];
        if (indexPath) {
            [self.brandTableView.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
    //友盟统计
    [MobClick beginLogPageView:@"brandPage"];
    [ManagerDefault standardManagerDefaults].isUsed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"brandPage"];//友盟统计
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self saveChangeAndReleaseObjects];
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


#pragma mark --
#pragma mark --Utilities

- (void)loadAndRefreshAllBrandsTableView
{
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    if (error == nil) {
        [self.brandTableView.tableView reloadData];
    }
    else{
        NSLog(@"fetch error");
    }
}

- (void)saveChangeAndReleaseObjects
{
    [[BrandDataAccessor sharedInstance] saveContext];
    for (NSManagedObject *object in self.brands) {
        [[BrandDataAccessor sharedInstance] releaseManagedOject:object];
    }
    for (NSManagedObject *object in self.fetchedResultsController.fetchedObjects) {
        [[BrandDataAccessor sharedInstance] releaseManagedOject:object];
    }
}

- (void)loadHotBrandAtPage:(NSInteger)pageNumber
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!= NotReachable) {
        _isLoading = YES;
        BrandURLSession *session = [[BrandURLSession alloc] init];
        session.delegate = self;
        session.isHotSession = YES;
        [session startConnectionToURL:[NSString stringWithFormat:@"%@page=%d", self.hotBrandUrl, pageNumber]];
    }
}

#pragma mark - 将16进制字符串转换成 UIColor
- (UIColor *)generateColorObjectWithHex:(NSString *)hexString
{
    unsigned int red = 0, green = 0, blue = 0;
    NSRange range = {0, 2};
    range.location = 0;
    
    NSString *redString = [hexString substringWithRange:range];
    NSScanner *redScanner = [NSScanner scannerWithString:redString];
    [redScanner scanHexInt:&red];
    
    range.location = 2;
    NSScanner *greenScanner = [NSScanner scannerWithString:[hexString substringWithRange:range]];
    [greenScanner scanHexInt:&green];
    
    range.location = 4;
    NSScanner *blueScanner = [NSScanner scannerWithString:[hexString substringWithRange:range]];
    [blueScanner scanHexInt:&blue];
    
    __autoreleasing UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    return color;
}

#pragma mark --
#pragma mark -- Load Data from database or newwork
- (void)loadDataAndRefresh
{
    self.brands = [[BrandDataAccessor sharedInstance] getHotBrandIcons];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    HotBrand *brand;
    if ([self.brands count] > 0) {
        brand = [self.brands objectAtIndex:0];
    }
    flowLayout.itemSize = CGSizeMake(160, brand.height * 160.0f / brand.width);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [self.collectionView reloadData];
}

- (void)downloadImageForIndex:(NSIndexPath *)indexPath
{
    // make sure it doesn't have to convert url
    HotBrand *brand = [self.brands objectAtIndex:indexPath.row];
    NSString *imageUrl = brand.imageUrl;
    if (imageUrl) {
        if ([self.downloadImageTasks objectForKey:imageUrl] == nil) {
            [self.downloadImageTasks setObject:indexPath forKey:imageUrl];
            __weak typeof(self) weakSelf = self;
            [[ImageDownloaderManager sharedInstance] addImageDowningTask:imageUrl cached:NO completion:^(NSString *url, UIImage *image, NSError *error) {
                typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (image) {
                            HotBrand *brand = [strongSelf.brands objectAtIndex:indexPath.row];
                            brand.icon = UIImageJPEGRepresentation(image, 1.0);
                            brand.updateDate = [[NSDate date] timeIntervalSince1970];
                            //NSLog(@"download image for cell:%d", indexPath.row);
                        }
                        if (error == nil && image != nil) {
                            [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                        }
                        [strongSelf.downloadImageTasks removeObjectForKey:url];
                    });
                }
            }];
        }
    }
}

#pragma mark --
#pragma mark -- callbacks--
- (void)hotBrandDataChanged
{
    if (self.brandTableView == nil) {
        [self loadDataAndRefresh];
    }
    else{
        if (_didLoadAllBrands && !_isLoadingAllbrands) {
            [self loadAndRefreshAllBrandsTableView];
        }
    }
}

- (void)netWorkStatusChanged
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        [self loadDataAndRefresh];
        [self loadHotBrandAtPage:1];
        if (self.brandTableView) {
            NSError *fetchError;
            [self.fetchedResultsController performFetch:&fetchError];
            if (fetchError == nil) {
                [self.brandTableView.tableView reloadData];
            }
            else{
                NSLog(@"fetch controller error");
            }
            
            if (!_didLoadAllBrands && !_isLoadingAllbrands) {
                _isLoadingAllbrands = YES;
                BrandURLSession *session = [[BrandURLSession alloc] init];
                session.isHotSession = NO;
                [session startConnectionToURL:self.allBrandUrl];
                session.delegate = self;
            }
        }
    }
}

- (void)loadCategoryDetailViewControllerForBrandID:(NSString *)brandId name:(NSString *)name
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if (reachability.currentReachabilityStatus != NotReachable ) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CategoryDetailTableViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailTableViewController"];
        detailVC.listType = ListBrandType;
        detailVC.brandId = brandId;
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.title = name;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else{
        [MBProgressHUD showError:@"亲，没有网络连接哦！" toView:self.navigationController.view];
    }
}

#pragma mark - 点击切换大小图按钮
- (void)handleRightBarButtonItemAction:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"A-Z"]) {
        [self saveChangeAndReleaseObjects];
        sender.title = @"大图";
        if (self.brandTableView == nil) {
            BrandTableView *brandTableView = [[BrandTableView alloc] initWithFrame:self.view.frame];
            self.brandTableView = brandTableView;
            [self.view addSubview:brandTableView];
            brandTableView.tableView.delegate = self;
            brandTableView.tableView.dataSource = self;
            float version = floorf(NSFoundationVersionNumber);
            if ((version > NSFoundationVersionNumber_iOS_6_1)) {
                self.brandTableView.tableView.contentInset = UIEdgeInsetsMake(64, 0, 60, 0);
            }
        }
        
        NSError *fetchError;
        [self.fetchedResultsController performFetch:&fetchError];
        if (fetchError == nil) {
            [self.brandTableView.tableView reloadData];
        }
        else{
            NSLog(@"fetch controller error");
        }
        
        if ([Reachability reachabilityForInternetConnection] != NotReachable) {
            if (!_didLoadAllBrands && !_isLoadingAllbrands) {
                _isLoadingAllbrands = YES;
                BrandURLSession *session = [[BrandURLSession alloc] init];
                session.isHotSession = NO;
                [session startConnectionToURL:self.allBrandUrl];
                session.delegate = self;
            }
        }
    }
    else {
        [self loadDataAndRefresh];
        sender.title = @"A-Z";
        [self.brandTableView removeFromSuperview];
    }
}

#pragma mark --
#pragma mark -- UICollectionViewDelegate--
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.brands count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotBrandCollectionViewCell" forIndexPath:indexPath];
    cell.brandImageView.image = nil;
    HotBrand *brand = [self.brands objectAtIndex:indexPath.row];
    NSData *imageData = brand.icon;
    if (imageData) {
        NSTimeInterval date = brand.updateDate;
        //NSLog(@"%f hour ago", ([[NSDate date] timeIntervalSince1970] - date) / 60 / 60);
        if (([[NSDate date] timeIntervalSince1970] - date) < 7 * 86400) {
            UIImage *image = [UIImage imageWithData:brand.icon];
            if (image) {
                cell.brandImageView.alpha = 0.0;
                cell.brandImageView.image = image;
                [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.brandImageView.alpha = 1.0;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
    else{
        //NSLog(@"no image data cell:%d", indexPath.row);
    }
    if (cell.brandImageView.image == nil) {
        //NSLog(@"no image for cell: %d", indexPath.row);
        if (!self.collectionView.dragging && !self.collectionView.decelerating) {
            [self downloadImageForIndex:indexPath];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotBrand *brand = [self.brands objectAtIndex:indexPath.row];
    [self loadCategoryDetailViewControllerForBrandID:[NSString stringWithFormat:@"%d", brand.brandId] name:brand.cname];
}

#pragma mark --
#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_noMorePage) {
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat height = scrollView.contentSize.height - scrollView.frame.size.height;
        if (contentOffsetY > height) {
            if (!_isLoading) {
                if (([self.brands count] > 0) && ([self.brands count] % 30 == 0)) {
                   // NSLog(@"loading page %d", [self.brands count] / 30 + 1);
                    [self loadHotBrandAtPage:[self.brands count] / 30 + 1];
                }
                else{
                    
                }
            }
        }
        else{
            //
        }

    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self downloadForVisibleCells];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self downloadForVisibleCells];
}

- (void)downloadForVisibleCells
{
    NSArray *array = [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in array) {
        HotBrand *brand = [self.brands objectAtIndex:indexPath.row];
        if ([self.downloadImageTasks objectForKey:indexPath] == nil && brand.icon == nil) {
            [self downloadImageForIndex:indexPath];
        }
    }
}

#pragma mark --
#pragma mark --BrandURLSessionDelegate
- (void)didFinishedLoadingPage:(NSInteger)pageNumber
{
    _isLoading = NO;
    if (pageNumber < 0) {
        _noMorePage = YES;
    }
    else{
        //begin to load another page
        [self loadHotBrandAtPage:pageNumber + 1];
    }
}

- (void)didFinishedLoadingAllBrand
{
    _didLoadAllBrands = YES;
    _isLoadingAllbrands = NO;
}


#pragma mark --
#pragma mark --UITableViewDelegate and UITableViewDataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.fetchedResultsController.sections count] > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    else{
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.fetchedResultsController.sections count] > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
        return [sectionInfo name];
    }
    else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Brand_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    
    AllBrand *brand = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIColor *color = [self generateColorObjectWithHex:brand.color];
    cell.textLabel.textColor = color;
    cell.textLabel.text = brand.cname;
    
    cell.detailTextLabel.text = brand.ename;
    cell.detailTextLabel.textColor = color;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllBrand *brand = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self loadCategoryDetailViewControllerForBrandID:[NSString stringWithFormat:@"%d", brand.brandId] name:brand.cname];
}


#pragma mark --
#pragma mark --setter and getter
- (NSMutableDictionary *)downloadImageTasks
{
    if (_downloadImageTasks == nil) {
        _downloadImageTasks = [[NSMutableDictionary alloc] init];
    }
    return _downloadImageTasks;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AllBrand"];
    [request setFetchBatchSize:20];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [request setSortDescriptors:@[sorter]];
    
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"cap" cacheName:nil];
    _fetchedResultsController = fetchController;
    
    NSError *error;
    if (![fetchController performFetch:&error]) {
        NSLog(@"fetch controller fetching error");
    }
    return _fetchedResultsController;
}

@end
