//
//  CategoryDetailTableViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CategoryDetailTableViewController.h"
#import "CategoryDetailTableViewCell.h"
#import "ImageDownloaderManager.h"
#import "DiskCachedImage.h"
#import "SubView.h"
#import "ProductInfoViewController.h"

#define CategoryDetailCellReuseIdentifier @"categorydetailcellIdentifier"
#define BigCategoryDetailCellReuseIdentifier @"bigcategorydetailcellIdentifier"

typedef enum{
    ShowingBigIconState,
    ShowingSamllIconState,
} ShowingState;

@interface CategoryDetailTableViewController ()<SubViewDelegate>
{
    CGFloat originalOffsetY;
    CGFloat floatViewOriginalY;
    BOOL isLoading;
    BOOL didLoadFirstBatch;
    NSUInteger currentPage;
    NSUInteger maxPage;
    NSInteger currentSelectedButton;
    
    //
    BOOL didChangeDataSource;
    BOOL _didDisplayNoMoreToLoad;
    
    NSInteger lowerRow;
    NSInteger upperRow;
}

@property (assign, nonatomic) ShowingState showingstate;
@property (strong, nonatomic) IBOutlet UIView *floatView;
@property (weak, nonatomic) IBOutlet UIButton *rankButton;
@property (weak, nonatomic) IBOutlet UIButton *brandButton;
@property (weak, nonatomic) IBOutlet UIButton *classificationButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *products;
@property(nonatomic, strong) NSDictionary *orderFilterList;
@property(nonatomic, strong) NSDictionary *brandFilterList;
@property(nonatomic, strong) NSDictionary *categoryFilterList;
@property(nonatomic, strong) NSArray *filterArray;

//the filter conditions
@property(nonatomic, strong) NSMutableDictionary *selectedFirstFilter;
@property(nonatomic, strong) NSMutableDictionary *selectedSecondFilter;
@property(nonatomic, strong) NSMutableDictionary *selectedThirdFilter;
@property(nonatomic, strong) NSMutableDictionary *filterDict;

@property(nonatomic, strong) NSMutableDictionary *imageUrls;
@property(nonatomic, strong) NSMutableDictionary *bigImageUrls;

@property(strong, nonatomic) UIActivityIndicatorView *activityView;
@property(strong, nonatomic) SubTableViewController *subTableViewController;
@property(weak, nonatomic) UITableView *subTableView;
@property(weak, nonatomic) SubView *filterView;
@property(weak, nonatomic) UIButton *grayButton;
@property(strong, nonatomic) NSString *url;

@property(strong, nonatomic) NSMutableArray *downloadingUrls;

//interact with js. May deprecate when no needed
@property (strong, nonatomic) WebViewJavascriptBridge *javaBridger;
@property (strong, nonatomic) UIWebView *webView;

- (IBAction)buttonPressed:(id)sender;

@end

@implementation CategoryDetailTableViewController

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
    //starting to load data from server
    // configure floatview
    [self setOriginalParameter];
    float version = floorf(NSFoundationVersionNumber);
    if ((version > NSFoundationVersionNumber_iOS_6_1)) {
        CGFloat width = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
        self.tableView.contentInset = UIEdgeInsetsMake(-width, 0, 0, 0);
    }
    UIView *floatView = [[UIView alloc] initWithFrame:CGRectMake(0, floatViewOriginalY, SCREEN_WIDTH, 40)];
    _floatView = floatView;
    [self setUpButtons];
    
    CGFloat originalY = 10;
    CGFloat height = _floatView.frame.size.height - 2 * originalY;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(80, originalY, 1, height)];
    line1.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_floatView addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(160, originalY, 1, height)];
    [_floatView addSubview:line2];
    line2.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(240, originalY, 1, height)];
    line3.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_floatView addSubview:line3];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _floatView.bounds.size.height-1, _floatView.bounds.size.width, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [_floatView addSubview:lineLabel];
    self.tableView.rowHeight = 124;
    
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    //set the rightbuttonitem
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"大图" style:UIBarButtonItemStylePlain target:self action:@selector(showBigIcon)];
    self.navigationItem.rightBarButtonItem = rightButton;
    isLoading = YES;
    didLoadFirstBatch = NO;
    currentPage = 1;
    _showingstate = ShowingSamllIconState;
    currentSelectedButton = -1;
    didChangeDataSource = NO;
    _didDisplayNoMoreToLoad = NO;
    
    //
    if (_listType == ListCategoryType) {
        self.baseURL = @"http://iphone.secoo.com/appservice/iphone/search_cateGoods.action?selectFlag=0";
        NSString *url = [[NSString alloc] initWithFormat:@"http://iphone.secoo.com/appservice/iphone/search_cateGoods.action?selectFlag=1&categoryId=%@", _categoryId];
        CategoryDetailURLSession *session = [[CategoryDetailURLSession alloc] init];
        [session startConnectionToURL:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        session.delegate = self;
    }
    else if (_listType == ListBrandType){
        self.baseURL = @"http://iphone.secoo.com/appservice/iphone/search_brandGoods.action?selectFlag=0";
        NSString *url = [[NSString alloc] initWithFormat:@"http://iphone.secoo.com/appservice/iphone/search_brandGoods.action?selectFlag=1&brandId=%@", _brandId];
        CategoryDetailURLSession *session = [[CategoryDetailURLSession alloc] init];
        [session startConnectionToURL:url];
        session.delegate = self;

    }
    else if (_listType == ListSearchType){
        self.baseURL = [[NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/search_goods.action?selectFlag=0&keyword=%@", _keyWord] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = [[NSString alloc] initWithFormat:@"http://iphone.secoo.com/appservice/iphone/search_goods.action?selectFlag=1&keyword=%@", _keyWord];
        CategoryDetailURLSession *session = [[CategoryDetailURLSession alloc] init];
        NSString *compatibleURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *finalURL = [compatibleURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [session startConnectionToURL:finalURL];
        session.delegate = self;
    }
    else if (_listType == ListWarehouseType){
        self.baseURL = @"http://iphone.secoo.com/appservice/iphone/search_goods.action?selectFlag=0";
        NSString *url = [[NSString alloc] initWithFormat:@"http://iphone.secoo.com/appservice/iphone/search_goods.action?selectFlag=1&warehouse=%@", _wareHouseId];
        CategoryDetailURLSession *session = [[CategoryDetailURLSession alloc] init];
        NSString *compatibleURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [session startConnectionToURL:compatibleURL];
        session.delegate = self;
    }
    
    //
    if (_categoryId) {
        self.url = [NSString stringWithFormat:@"%@&categoryId=%@", self.baseURL, _categoryId];
    }
    else if (_brandId) {
        self.url =  [[NSString stringWithFormat:@"%@&brandId=%@", self.baseURL, _brandId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else if (_wareHouseId){
        //self.url = self.baseURL;
        self.url = [[NSString stringWithFormat:@"%@&warehouse=%@", self.baseURL, _wareHouseId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else{
        self.url = self.baseURL;
    }
    
    ///
    [self addFLoatToNavigationVC];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    maxPage = 0;
    
    lowerRow = 0;
    upperRow = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //友盟统计
    [MobClick beginLogPageView:@"prodList"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isLoading) {
        UIActivityIndicatorView *view = self.activityView;
        [self.view addSubview:view];
        [self.view bringSubviewToFront:view];
        [view startAnimating];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_subTableView removeFromSuperview];
    [_grayButton removeFromSuperview];
    [_activityView removeFromSuperview];
    [_filterView removeFromSuperview];
    
    //友盟统计
    [MobClick endLogPageView:@"prodList"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self freeSomeImages:YES upper:YES];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    [self.downloadingUrls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *downloadingSession = (NSString *)obj;
        [[ImageDownloaderManager sharedInstance] cancelSession:downloadingSession];
    }];
}

- (void)setUpButtons
{
    for (int i = 0; i < 4; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button.titleLabel setNumberOfLines:0];
        button.frame = CGRectMake(i * SCREEN_WIDTH / 4.0, 0, SCREEN_WIDTH / 4.0, 40);
        [_floatView addSubview:button];
        button.backgroundColor = [UIColor whiteColor];
        NSString *name;
        switch (i) {
            case 0:
                name = @"排序";
                _rankButton = button;
                break;
            case 1:
                name = @"品牌";
                _brandButton = button;
                break;
            case 2:
                name = @"分类";
                _classificationButton = button;
                break;
            case 3:
                name = @"筛选";
                _filterButton = button;
                break;
            default:
                break;
        }
        button.tag = 10000 + i;
        [button setTitle:name forState:UIControlStateNormal];
    }
}

- (void)showBigIcon
{
    if (_showingstate == ShowingSamllIconState) {
        self.navigationItem.rightBarButtonItem.title = @"小图";
        _showingstate = ShowingBigIconState;
        self.tableView.rowHeight = 380;
        if ([self.imageUrls count] > 20) {
            for (int i = 0; i < [self.imageUrls count]; ++i) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                DiskCachedImage *diskImage = [self.imageUrls objectForKey:indexPath];
                [self releaseDiskImage:diskImage];
            }
        }
    }
    else{
        _showingstate = ShowingSamllIconState;
        self.navigationItem.rightBarButtonItem.title = @"大图";
        self.tableView.rowHeight = 124;
        if ([self.bigImageUrls count] > 10) {
            for (int i = 0; i < [self.bigImageUrls count]; ++i) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                DiskCachedImage *diskImage = [self.bigImageUrls objectForKey:indexPath];
                [self releaseDiskImage:diskImage];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 返回按钮响应方法
- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BigCategoryDetailCellReuseIdentifier
    CategoryDetailTableViewCell* cell;
    if (_showingstate == ShowingSamllIconState) {
        cell = [tableView dequeueReusableCellWithIdentifier:CategoryDetailCellReuseIdentifier forIndexPath:indexPath];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:BigCategoryDetailCellReuseIdentifier forIndexPath:indexPath];
    }
    if (indexPath.row >= upperRow) {
        upperRow = indexPath.row;
    }
    if (indexPath.row <= lowerRow) {
        lowerRow = indexPath.row;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CategoryDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.products objectAtIndex:indexPath.row];
    NSString *name = [dict valueForKeyPath:@"productName"];
    if (name) {
        cell.customTitleLabel.text = name;
    }
    else{
        cell.customTitleLabel.text = @"unknown product";
    }
    
    NSString *price = [dict valueForKeyPath:@"refPrice"];//refPrice
    if (price) {
        cell.customPriceLabel.text = [NSString stringWithFormat:@"¥%@",price];
    }
    else{
        cell.customPriceLabel.text = @"unknown price";
    }
    
    NSString *level = [dict valueForKeyPath:@"level"];
    if (level) {
        if ([level isEqualToString:@"N"]) {
            level = @"";
            cell.customLevelLabel.alpha = 0;
        } else if ([level isEqualToString:@"S"]) {
            level = @"未使用";
            cell.customLevelLabel.alpha = 1;
        } else {
            level = @"已使用";
            cell.customLevelLabel.alpha = 1;
        }
        cell.customLevelLabel.text = level;
    }
    else{
        cell.customLevelLabel.text = @"unknown level";
    }
    if (_showingstate == ShowingSamllIconState) {
        [self setImageForImageView:cell.customImageView atIndexPath:indexPath fromDict:dict isBig:NO];
    }
    else{
        [self setImageForImageView:cell.customImageView atIndexPath:indexPath fromDict:dict isBig:YES];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger activityType = [[dict objectForKey:@"activityType"] integerValue];
    if (activityType == 1) {
        //拍卖商品
        UIImageView *flagView = (UIImageView *) [cell.contentView viewWithTag:100000];
        if (flagView == nil) {
            flagView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.customImageView.frame.origin.x, cell.customImageView.frame.origin.y, 25, 25)];
            flagView.tag = 100000;
            [cell.contentView addSubview:flagView];
        }
        flagView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"auctionFlag" ofType:@"png"]];
    }
    else if (activityType == 2){
        //商品闪购
        UIImageView *flagView = (UIImageView *) [cell.contentView viewWithTag:100000];
        if (flagView == nil) {
            flagView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.customImageView.frame.origin.x, cell.customImageView.frame.origin.y, 25, 25)];
            flagView.tag = 100000;
            [cell.contentView addSubview:flagView];
        }
        flagView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fastPurchaseFlag" ofType:@"png"]];
    }
    else{
        UIImageView *flagView = (UIImageView *) [cell.contentView viewWithTag:100000];
        [flagView removeFromSuperview];
    }
}

- (void)setImageForImageView:(UIImageView *)imageView atIndexPath:(NSIndexPath*)indexPath fromDict:(NSDictionary *)dict isBig:(BOOL)isBig
{
    NSString *imgeUrl;
    NSMutableDictionary *imageUrldict;
    if (!isBig) {
        imgeUrl = [self convertToRealUrl:[dict valueForKeyPath:@"imgUrl"] isBig:NO];
        imageUrldict = self.imageUrls;
    }
    else{
        imgeUrl = [self convertToRealUrl:[dict valueForKeyPath:@"imgUrl"] isBig:YES];
        imageUrldict = self.bigImageUrls;
    }
    
    if ([imageUrldict objectForKey:indexPath]) {
        DiskCachedImage *diskImage = [imageUrldict objectForKey:indexPath];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:diskImage selector:@selector(getImage:) object:^(UIImage *dimage) {
            if (dimage) {
                if (dimage != imageView.image) {
                    imageView.alpha = 0.0;
                    imageView.image = dimage;
                    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        imageView.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
            else{
                imageView.image = nil;
            }
        }];
        [[DiskCachedImageManager sharedInstance] addReadOperation:operation];
    }
    else{
        imageView.image = nil;
        imageView.alpha = 0.0;
//        if (isBig) {
//            UIImage *image = [UIImage imageNamed:@"place_holder_500.png"];
//            imageView.image = image;
//        }
//        else{
//            UIImage *image = [UIImage imageNamed:@"place_holder_160.png"];
//            imageView.image = image;
//        }
        //NSLog(@"dragging %hhd  %hhd", self.tableView.dragging, self.tableView.decelerating);
        if (!self.tableView.dragging && !self.tableView.decelerating) {
            [self downloadForCellAtIndex:indexPath];
        }
    }
}

- (void)downloadForVisibleCells
{
    NSArray *array = [self.tableView indexPathsForVisibleRows];
    NSMutableDictionary *imageUrldict;
    if (self.showingstate == ShowingSamllIconState) {
        imageUrldict = self.imageUrls;
    }
    else{
        imageUrldict = self.bigImageUrls;
    }
    for (NSIndexPath *indexPath in array) {
        if ([imageUrldict objectForKey:indexPath] == nil) {
            [self downloadForCellAtIndex:indexPath];
        }
    }
}

- (void)downloadForCellAtIndex:(NSIndexPath *)indexPath
{
    BOOL isBig;
    NSMutableDictionary *imageUrldict;
    if (self.showingstate == ShowingSamllIconState) {
        isBig = NO;
        imageUrldict = self.imageUrls;
    }
    else{
        isBig = YES;
        imageUrldict = self.bigImageUrls;
    }
    NSDictionary *dict = [self.products objectAtIndex:indexPath.row];
    NSString *imgeUrl = [ self convertToRealUrl:[dict valueForKeyPath:@"imgUrl"] isBig:isBig];
    if ([imageUrldict objectForKey:imgeUrl] == nil) {
        [imageUrldict setObject:indexPath forKey:imgeUrl];
        __weak CategoryDetailTableViewController* weakSelf = self;
        [self.downloadingUrls addObject:imgeUrl];
        NSMutableArray *downloadingUrls = self.downloadingUrls;
        UITableView *tableView = self.tableView;
        [[ImageDownloaderManager sharedInstance] addImageDowningTask:imgeUrl cached:YES completion:^(NSString *url, UIImage *image, NSError *error) {
            CategoryDetailTableViewController* strongSelf = weakSelf;
            if (strongSelf) {
                if (image) {
                    UIImage *resizedImage;
                    if (strongSelf.showingstate == ShowingBigIconState) {
                        resizedImage = [Utils resizeImage:image toSize:CGSizeMake(300, 300)];
                    }
                    else{
                        resizedImage = [Utils resizeImage:image toSize:CGSizeMake(105, 105)];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [downloadingUrls removeObject:url];
                        NSIndexPath *indexPath = [imageUrldict objectForKey:url];
                        CategoryDetailTableViewCell *cell = (CategoryDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                        cell.customImageView.alpha = 0.0;
                        cell.customImageView.image = resizedImage;
                        
                        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            cell.customImageView.alpha = 1.0;
                        } completion:^(BOOL finished) {
                            
                        }];
                        DiskCachedImage *diskImage = [[DiskCachedImage alloc] init];
                        if (indexPath) {
                            [imageUrldict setObject:diskImage forKey:indexPath];
                        }
                        [diskImage setDiskImage:resizedImage];
                        [imageUrldict removeObjectForKey:url];
                    });
                }
                else{
                    // set to nil than it will start load next time;  make it can only try 2-3 times
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [imageUrldict removeObjectForKey:url];
                    });
                }
            }
        }];
    }
}

- (NSString *)convertToRealUrl:(NSString *)url isBig:(BOOL)isBig
{
    //http://pic.secoo.com/product/200/200/23/28/10432328.jpg
    
    if ([url hasPrefix:@"http://"]) {
        return url;
    }
    NSString *realURL;
    if (isBig) {
        realURL = [[NSString alloc] initWithFormat:@"http://pic.secoo.com/product/500/500/%@", url];
    }
    else{
       realURL = [[NSString alloc] initWithFormat:@"http://pic.secoo.com/product/200/200/%@", url];
    }
    return realURL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.products objectAtIndex:indexPath.row];
    NSInteger activityType = [[dict objectForKey:@"activityType"] integerValue];
    if (activityType != 1) {//0 normal, 1 auction, 3 fast purchase
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductInfoViewController *productVC = [storyboard instantiateViewControllerWithIdentifier:@"ProductInfoViewController"];
        productVC.productID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"productId"]];
        productVC.title = @"商品详情";
        [self.navigationController pushViewController:productVC animated:YES];
    }
    else{
        //if it is  an auction product
        NSInteger activityId = [[dict objectForKey:@"activityId"] integerValue];
        //long productId = [[dict objectForKey:@"productId"] longValue];
        NSString *commandStr = [NSString stringWithFormat:@"ios2JSAuctionCommand(%@, %d)", [dict objectForKey:@"productId"], activityId];
        [self.webView stringByEvaluatingJavaScriptFromString:commandStr];
    }
}

#pragma mark --DetailProductsDelegate-----
- (void)getProducts:(NSArray *)products filterList:(NSArray *)filterList maxPage:(int)maxPage_ currPage:(int)currPage
{
    //key: marketPrice secooPrice, activityId, activityType source
    if (filterList) {
        self.orderFilterList = [filterList objectAtIndex:0];
        self.brandFilterList = [filterList objectAtIndex:1];
        self.categoryFilterList = [filterList objectAtIndex:2];
        
        static BOOL setButtonNames = NO;
        if (!setButtonNames) {
            setButtonNames = YES;
            [self.rankButton setTitle:[self.orderFilterList valueForKey:@"name"] forState:UIControlStateNormal];
            [self.brandButton setTitle:[self.brandFilterList valueForKey:@"name"] forState:UIControlStateNormal];
            [self.classificationButton setTitle:[self.categoryFilterList valueForKey:@"name"] forState:UIControlStateNormal];
            
            [self setFilterDictValues];
        }
        self.filterArray = [filterList subarrayWithRange:NSMakeRange(3, [filterList count] - 3)];
        if (self.subTableView) {
            self.subTableViewController.orderFilterList = [_orderFilterList objectForKey:@"value"];
            self.subTableViewController.brandFilterList = [_brandFilterList objectForKey:@"value"];
            self.subTableViewController.categoryFilterList = [_categoryFilterList objectForKey:@"value"];
            [self.subTableView reloadData];
        }
    }
    currentPage = currPage;
    maxPage = maxPage_;
    if (didChangeDataSource) {
        didChangeDataSource = NO;
        [self.products removeAllObjects];
    }
    didLoadFirstBatch = YES;
    if (isLoading) {
        isLoading = NO;
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        self.activityView = nil;
    }
    if ([products count] > 0) {
        [self.products addObjectsFromArray:products];
        _didDisplayNoMoreToLoad = NO;
    }
    else{
        [MBProgressHUD showError:@"没有更多商品了" toView:self.view];
    }
    [self.tableView reloadData];
}

- (void)setFilterDictValues
{
    //categoryId, orderType, brandId
    if (_brandId) {
        if ([[_brandFilterList objectForKey:@"key"] isEqualToString:@"brandId"]) {
            [_selectedFirstFilter setObject:_brandId forKey:@"brandId"];
            [_brandButton setTitle:_brandId forState:UIControlStateNormal];
        }
        else if ([[_orderFilterList objectForKey:@"key"] isEqualToString:@"brandId"]){
            [_selectedFirstFilter setObject:_brandId forKey:@"brandId"];
            [_rankButton setTitle:_brandId forState:UIControlStateNormal];
        }
        else if ([[_categoryFilterList objectForKey:@"key"] isEqualToString:@"brandId"]){
            [_selectedThirdFilter setObject:_brandId forKey:@"brandId"];
            [_classificationButton setTitle:_brandId forState:UIControlStateNormal];
        }
    }
}

#pragma mark ----------------------------UIScrollView Delegate --------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (didLoadFirstBatch) {
        if (contentOffsetY > (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if (!isLoading) {
                //NSLog(@"current page :%d", currentPage);
                if (currentPage < maxPage) {
                    if (_showingstate == ShowingBigIconState) {
                        UIEdgeInsets inset = scrollView.contentInset;
                        scrollView.contentInset = UIEdgeInsetsMake(inset.top, 0, 380, 0);
                    }
                    else{
                        UIEdgeInsets inset = scrollView.contentInset;
                        scrollView.contentInset = UIEdgeInsetsMake(inset.top, 0, 124, 0);
                    }
                    NSString *pageStr = [[NSString alloc] initWithFormat:@"&currPage=%d", currentPage + 1];
                    NSString *url = [self.url stringByAppendingString:pageStr];
                    NSString *compatibleURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    CategoryDetailURLSession *session = [[CategoryDetailURLSession alloc] init];
                    [session startConnectionToURL:compatibleURL];
                    session.delegate = self;
                    UIActivityIndicatorView *view = self.activityView;
                    view.frame = CGRectMake((scrollView.frame.size.width - 50) / 2.0, scrollView.contentSize.height - 15, 50, 50);
                    [self.tableView addSubview:view];
                    [view startAnimating];
                    isLoading = YES;
                }
                else{
                    if ((scrollView.dragging || scrollView.decelerating) && !_didDisplayNoMoreToLoad) {
                        _didDisplayNoMoreToLoad = YES;
                        UIEdgeInsets inset = scrollView.contentInset;
                        scrollView.contentInset = UIEdgeInsetsMake(inset.top, 0, 0, 0);
                        [MBProgressHUD showError:@"没有更多商品了" toView:self.view];
                    }
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
        if ([self.products count] > 20) {
            [self freeSomeImages:YES upper:YES];
        }
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self downloadForVisibleCells];
    if ([self.products count] > 20) {
        [self freeSomeImages:YES upper:YES];
    }
}

- (void)freeSomeImages:(BOOL)lower upper:(BOOL)upper
{
    NSArray *array = [self.tableView indexPathsForVisibleRows];
    int minIndex = 9999999, maxIndex = 0;
    for (NSIndexPath *indexPath in array) {
        if (indexPath.row > maxIndex) {
            maxIndex = indexPath.row;
        }
        if (indexPath.row < minIndex){
            minIndex = indexPath.row;
        }
    }
    if (minIndex > maxIndex) {
        return;
    }
    if (_showingstate == ShowingBigIconState) {
        if (upper) {
            for (int i = minIndex - 5; i > lowerRow; --i) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                DiskCachedImage *diskImage = [self.bigImageUrls objectForKey:indexPath];
                [self releaseDiskImage:diskImage];
            }
            lowerRow = minIndex - 5;
        }
        
        if (lower) {
            for (int i = maxIndex + 5; i < upperRow; ++i) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                DiskCachedImage *diskImage = [self.bigImageUrls objectForKey:indexPath];
                [self releaseDiskImage:diskImage];
            }
            upperRow = maxIndex + 5;
        }
    }
    else{
        if (upper) {
            for (int i = minIndex - 10; i > lowerRow; --i) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                DiskCachedImage *diskImage = [self.imageUrls objectForKey:indexPath];
                [self releaseDiskImage:diskImage];
            }
            lowerRow = minIndex - 10;
        }
        
        if (lower) {
            for (int i = maxIndex + 10; i < upperRow; ++i) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                DiskCachedImage *diskImage = [self.imageUrls objectForKey:indexPath];
                [self releaseDiskImage:diskImage];
            }
            upperRow = maxIndex + 10;
        }
    }
}

- (void)releaseDiskImage:(DiskCachedImage *)diskImage
{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:diskImage selector:@selector(releaseImage) object:nil];
    [[DiskCachedImageManager sharedInstance] addWriteOperation:operation];
}

- (void)addFLoatToNavigationVC
{
    CGRect frame = _floatView.frame;
    UIView *view = [[UIView alloc] initWithFrame:_floatView.frame];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
    [self.view addSubview:_floatView];
    float version = floorf(NSFoundationVersionNumber);
    if ((version > NSFoundationVersionNumber_iOS_6_1)) {
        _floatView.frame = CGRectMake(0, originalOffsetY, frame.size.width, frame.size.height);
    }
    else{
        _floatView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    [self.view bringSubviewToFront:_floatView];
}

#pragma mark ------------------------------the float view and sub table view controller-----------------------------------------
- (void)setUpSubTableView:(SubTableViewState)state
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(removeSubTableView:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, floatViewOriginalY + _floatView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height);
    button.backgroundColor = [UIColor darkGrayColor];
    button.alpha = 0.5;
    [self.view addSubview:button];
    _grayButton = button;
    _grayButton.alpha = 0.0;
    
    UITableView *subTableView = self.subTableViewController.tableView;
    self.subTableViewController.delegate = self;
    self.subTableViewController.state = state;
    self.subTableViewController.orderFilterList = [_orderFilterList objectForKey:@"value"];
    self.subTableViewController.brandFilterList = [_brandFilterList objectForKey:@"value"];
    self.subTableViewController.categoryFilterList = [_categoryFilterList objectForKey:@"value"];
    
    self.subTableViewController.orderType = [_orderFilterList objectForKey:@"key"];
    self.subTableViewController.brandType = [_brandFilterList objectForKey:@"key"];
    self.subTableViewController.classificationType = [_categoryFilterList objectForKey:@"key"];
    
    self.subTableViewController.selectedFirstFilter = self.selectedFirstFilter;
    self.subTableViewController.selectedSecondFilter = self.selectedSecondFilter;
    self.subTableViewController.selectedThirdFilter = self.selectedThirdFilter;
    
    _subTableView = subTableView;
    subTableView.frame = CGRectMake(0, _floatView.frame.origin.y + _floatView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height - 200);
    [self.view addSubview:subTableView];
    subTableView.alpha = 0.0;
    
    [UIView animateWithDuration:0.1 animations:^{
        subTableView.alpha = 1.0;
        button.alpha = 0.5;
    }];
}

- (void)addFilterSubView:(SubTableViewState)state
{
    if (!self.filterView) {
        if (currentSelectedButton == SubTableViewStateFilter) {
            SubView *view = [[SubView alloc] initWithFrame:_subTableView.frame delegate:self dataSource:self.filterArray];
            self.filterView = view;
            view.filterDict = self.filterDict;
            [self.view addSubview:view];
        }
    } else {
        [self.filterView removeFromSuperview];
    }
}

- (void)removeSubTableView:(UIButton *)sender
{
    currentSelectedButton = -1;
    [UIView animateWithDuration:0.1 animations:^{
        _grayButton.alpha = 0.0;
        _subTableView.alpha = 0.0;
        if (self.filterView) {
            _filterView.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        [_grayButton removeFromSuperview];
        [_subTableView removeFromSuperview];
        [self setButtonsState:nil];
        self.subTableViewController = nil;
        [self.filterView removeFromSuperview];
    }];
}

- (void)setButtonsState:(UIButton *)sender
{
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    int tag = sender.tag;
    for (int i = 0; i < 4; ++i) {
        if (i != tag - 10000) {
            UIButton *view = (UIButton *)[_floatView viewWithTag:i + 10000];
            [view setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)buttonPressed:(id)sender
{
    UIButton *view = (UIButton *)sender;
    int tag = view.tag - 10000;
    if (tag  == currentSelectedButton) {
        //-1 represent no button is selected right now;
        [self removeSubTableView:_grayButton];
        return;
    }
    else{
        currentSelectedButton = tag;
    }
    
    [self setButtonsState:view];
    if (_subTableViewController == nil) {
        [self setUpSubTableView:tag];
    }
    else{
        _subTableViewController.state = tag;
        [_subTableView reloadData];
    }
    
    [self addFilterSubView:tag];
}

#pragma mark - SubTableView Delegate Method

- (void)configureURL
{
    NSString *url = self.baseURL;
    NSString *str =[self.selectedFirstFilter objectForKey:[_orderFilterList objectForKey:@"key"]];
    BOOL hasCategory = false;
    BOOL hasCategoryBrandId = false;
    if (str) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", [_orderFilterList objectForKey:@"key"], str]];
        if ([[_orderFilterList objectForKey:@"key"] isEqualToString:@"categoryId"]) {
            hasCategory = YES;
        }
        if ([[_orderFilterList objectForKey:@"key"] isEqualToString:@"brandId"]) {
            hasCategoryBrandId = YES;
        }
    }
    else{
        if ([self.orderFilterList valueForKey:@"name"]) {
            [self.rankButton setTitle:[self.orderFilterList valueForKey:@"name"] forState:UIControlStateNormal];
        }
    }
    if ([self.selectedSecondFilter objectForKey:[_brandFilterList objectForKey:@"key"]]) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", [_brandFilterList objectForKey:@"key"], [self.selectedSecondFilter objectForKey:[_brandFilterList objectForKey:@"key"]]]];
        if ([[_brandFilterList objectForKey:@"key"] isEqualToString:@"categoryId"]) {
            hasCategory = YES;
        }
        if ([[_brandFilterList objectForKey:@"key"] isEqualToString:@"brandId"]) {
            hasCategoryBrandId = YES;
        }
    }
    else{
        if ([self.brandFilterList valueForKey:@"name"]) {
            [self.brandButton setTitle:[self.brandFilterList valueForKey:@"name"] forState:UIControlStateNormal];
        }
    }
    if ([self.selectedThirdFilter objectForKey:[_categoryFilterList objectForKey:@"key"]]) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", [_categoryFilterList objectForKey:@"key"], [self.selectedThirdFilter objectForKey:[_categoryFilterList objectForKey:@"key"]]]];
        if ([[_categoryFilterList objectForKey:@"key"] isEqualToString:@"categoryId"]) {
            hasCategory = YES;
        }
        if ([[_categoryFilterList objectForKey:@"key"] isEqualToString:@"brandId"]) {
            hasCategoryBrandId = YES;
        }
    }
    else{
        if ([self.categoryFilterList valueForKey:@"name"]) {
            [self.classificationButton setTitle:[self.categoryFilterList valueForKey:@"name"] forState:UIControlStateNormal];
        }
    }
    if (!hasCategory) {
        if (_categoryId) {
            url = [url stringByAppendingString:[NSString stringWithFormat:@"&categoryId=%@", _categoryId]];
        }
    }
    if (!hasCategoryBrandId) {
        if (_brandId) {
            url = [url stringByAppendingString:[NSString stringWithFormat:@"&brandId=%@", _brandId]];
        }
    }
    
    NSArray *allKeys = [self.filterDict allKeys];
    BOOL hasWarehouse = NO;
    for (NSString *key in allKeys) {
        if ([key isEqualToString:@"warehouse"]) {
            hasWarehouse = YES;
        }
        NSString *content = [self.filterDict objectForKey:key];
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key ,content]];
    }
    if (!hasWarehouse) {
        if (_wareHouseId) {
            url = [url stringByAppendingString:[NSString stringWithFormat:@"&warehouse=%@", _wareHouseId]];
        }
    }
    NSLog(@"configured url:%@", url);
    self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)didSelectAt:(NSString *)type withTypeID:(NSString *)typeID cellText:(NSString *)text
{
    //NSLog(@"type %@, typeID %@, cellText %@", type, typeID, text);
    //改变筛选button的title
    switch (currentSelectedButton) {
        case SubTableViewStateRank:
            [_rankButton setTitle:text forState:UIControlStateNormal];
            break;
        case SubTableViewStateBrand:
            [_brandButton setTitle:text forState:UIControlStateNormal];
            break;
        case SubTableViewStateClassificaton:
            [_classificationButton setTitle:text forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    currentPage = 1;
    didChangeDataSource = YES;
    didLoadFirstBatch = NO;
    [self configureURL];
    CategoryDetailURLSession *session = [[CategoryDetailURLSession alloc] init];
    NSString *url = [self.url stringByReplacingOccurrencesOfString:@"selectFlag=0" withString:@"selectFlag=1"];
    [session startConnectionToURL:url];
    session.delegate = self;
    [self removeSubTableView:_grayButton];
    [self.imageUrls removeAllObjects];
    [self.bigImageUrls removeAllObjects];
    
    [self showActivityView];
}

- (void)showActivityView
{
    UIActivityIndicatorView *view = self.activityView;
    view.frame = CGRectMake((self.view.frame.size.width - 50) / 2.0, (self.view.frame.size.height - 50) / 2.0, 50, 50);
    [self.view addSubview:view];
    [view startAnimating];
    isLoading = YES;
}

#pragma mark - SubViewDelegate Method
- (void)hasSelectWithFilterDict:(NSDictionary *)filterDict
{
    [self configureURL];
    currentPage = 1;
    didChangeDataSource = YES;
    didLoadFirstBatch = NO;
    CategoryDetailURLSession *session = [[CategoryDetailURLSession alloc] init];
    NSString *url = [self.url stringByReplacingOccurrencesOfString:@"selectFlag=0" withString:@"selectFlag=1"];
    [session startConnectionToURL:url];
    session.delegate = self;
    [self removeSubTableView:_grayButton];
    [self.imageUrls removeAllObjects];
    [self.bigImageUrls removeAllObjects];
    [self showActivityView];
}

#pragma mark --------------------------getter and setter----------------------------------
- (void)setOriginalParameter
{
    originalOffsetY = 0;
    if (![UIApplication sharedApplication].statusBarHidden) {
        floatViewOriginalY += [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    if (self.navigationController) {
        if (!self.navigationController.navigationBarHidden) {
            floatViewOriginalY += self.navigationController.navigationBar.frame.size.height;
        }
    }
    if (_IOS_7_LATER_) {
        originalOffsetY = floatViewOriginalY;
    }
}

- (SubTableViewController *)subTableViewController
{
    if (_subTableViewController == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SubTableViewController *subVC = [storyboard instantiateViewControllerWithIdentifier:@"SubTableViewController"];
        _subTableViewController = subVC;
        _subTableViewController.delegate = self;
    }
    return _subTableViewController;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView = view;
        _activityView.frame = CGRectMake(0, 0, 50, 50);
        _activityView.center = self.view.window.center;
        _activityView.hidesWhenStopped = YES;
    }
    return _activityView;
}

- (NSMutableDictionary *)imageUrls
{
    if (_imageUrls == nil) {
        _imageUrls = [[NSMutableDictionary alloc] init];
    }
    return _imageUrls;
}

- (NSMutableDictionary *)bigImageUrls
{
    if (_bigImageUrls == nil) {
        _bigImageUrls = [[NSMutableDictionary alloc] init];
    }
    return _bigImageUrls;
}

- (NSMutableArray *)products
{
    if (_products == nil) {
        _products = [[NSMutableArray alloc] init];
    }
    return _products;
}

- (NSMutableArray *)downloadingUrls
{
    if (_downloadingUrls == nil) {
        _downloadingUrls = [[NSMutableArray alloc] init];
    }
    return _downloadingUrls;
}

- (NSMutableDictionary *)selectedFirstFilter
{
    if (_selectedFirstFilter == nil) {
        _selectedFirstFilter = [[NSMutableDictionary alloc] init];
    }
    return _selectedFirstFilter;
}

- (NSMutableDictionary *)selectedSecondFilter
{
    if (_selectedSecondFilter == nil) {
        _selectedSecondFilter = [[NSMutableDictionary alloc] init];
    }
    return _selectedSecondFilter;
}

- (NSMutableDictionary *)selectedThirdFilter
{
    if (_selectedThirdFilter == nil) {
        _selectedThirdFilter = [[NSMutableDictionary alloc] init];
    }
    return _selectedThirdFilter;
}

- (NSMutableDictionary *)filterDict
{
    if (_filterDict == nil) {
        _filterDict = [[NSMutableDictionary alloc] init];
    }
    return _filterDict;
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        AppDelegate *delegte = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _webView = delegte.webView;
    }
    return _webView;
}

@end
