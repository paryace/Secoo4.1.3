//
//  CartViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/23/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CartViewController.h"
#import "CartItem.h"
#import "CartTableViewCell.h"
#import "CartItemAccessor.h"
#import "ProductInfoViewController.h"
#import "CustomerOrderViewController.h"
#import "CartURLSession.h"
#import "ImageDownloaderManager.h"
#import "DotLineView.h"
#import "CouponViewController.h"
#import "AddressEntity.h"
#import "AddressDataAccessor.h"
#import "AddressURLSession.h"

#define CartCellIdentifier @"CartCell"
#define BaseButtonTag 100000

@interface CartViewController ()<UIAlertViewDelegate>
{
    BOOL _editing;
    BOOL _fistTime;
    NSInteger _currentAreaType;
    BOOL _buyAvailable;
}

@property(nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, weak) IBOutlet UILabel *backgroundLabel;

@property(nonatomic, weak) MBProgressHUD *mbProgressHUD;//正在加载

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSMutableDictionary *cartItems;
@property(nonatomic, strong) NSMutableArray *allAreaTypes;
@property(nonatomic, strong) NSMutableDictionary *secooCoin;
@property(nonatomic, strong) NSMutableDictionary *needsUpdateIndicators;

@property(nonatomic, strong) NSMutableDictionary *totalFeeDict;
@property(nonatomic, strong) NSMutableDictionary *downloadImageTasks;

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) UIView *checkOutView;
@property(weak, nonatomic) UILabel *priceLabel;
@property(weak, nonatomic) UILabel *totalPriceLabel;
@property(weak, nonatomic) UILabel *returnValueLabel;

//@property(nonatomic, weak) UILabel *totalPriceLabel;//商品金额
@property(nonatomic, weak) UILabel *favorableLabel;//下单优惠
@property(nonatomic, weak) UILabel *rebateLabel;//返利库币
@property(nonatomic, weak) UILabel *carriageFeeLabel;//运费
@property(nonatomic, weak) UILabel *payLabel;//应付金额
@property(nonatomic, weak) UIButton *payButton;//结算按钮

@property(nonatomic, weak) CustomerOrderViewController *customerOrderVC;

- (NSString *)getNameForAreaType:(NSInteger)AreaType;
@end
/*
 add the same product to cart;
 */

@implementation CartViewController

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
    self.tableView.rowHeight = 82;
//    [self.tableView registerClass:[CartTableViewCell class] forCellReuseIdentifier:CartCellIdentifier];
    self.navigationItem.title = @"购物袋";
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteItems:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _editing = NO;
    _buyAvailable = NO;
    _currentAreaType = -1;
    _fistTime = YES;
    [self refreshAndDownloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCartObject:) name:kDidAddCartItemNotification object:[CartItemAccessor sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCartItems) name:kCartItemDidChangeNotification object:[CartItemAccessor sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewTotalValues:) name:kDidGetTotalValue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDataAvaiable) name:kNeedGetCartInfoAgain object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAndDownloadData) name:@"DeleteOnAreaTypeItems" object:[CartItemAccessor sharedInstance]];
    
    AddressURLSession *session = [[AddressURLSession alloc] init];
    [session upDateAddress];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_fistTime) {
        [self refreshCartItems];
    }
    _fistTime = NO;
    [self addBottomView];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.cartVersion == 2) {
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.backgroundColor = [UIColor whiteColor];
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        NSArray *items = [[CartItemAccessor sharedInstance] getAllItems];
        if ([items count] == 0) {
            //
        }
        else{
            self.navigationItem.rightBarButtonItem = nil;
            NSString *productInfo = nil;
            for (CartItem *item in items) {
                NSString *proInfo = [NSString stringWithFormat:@"{\"productId\":%@,\"quantity\":%d,\"type\":%d,\"areaType\":%hd}",item.productId, item.quantity, 0, item.areaType];
                if (productInfo == nil) {
                    productInfo = proInfo;
                }
                else{
                    productInfo = [NSString stringWithFormat:@"%@,%@", productInfo, proInfo];
                }
            }
            productInfo = [NSString stringWithFormat:@"[%@]", productInfo];
            
            NSString *upkey = [[UserInfoManager getUserUpKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *urlStr = [NSString stringWithFormat:@"http://m.secoo.com/cart.html?vo.upkey=%@&vo.productInfo=%@", upkey, [productInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            //NSString *urlStr = @"http://www.taobao.com";
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
            [webView loadRequest:request];
        }
    }
    
    [MobClick beginLogPageView:@"cartWrapper"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"cartWrapper"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_editing) {
        _editing = NO;
        [self.tableView setEditing:NO animated:NO];
        self.navigationItem.rightBarButtonItem.title = @"删除";
    }
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

- (void)addCartObject:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSInteger areaType = [[info objectForKey:@"areaType"] integerValue];
    if (areaType == _currentAreaType) {
        //if the added item is from the current area type, then download data and refresh
        _currentAreaType = areaType;
        [self refreshAndDownloadData];
    }
    else{
        [self refreshCartItems];
        [self.needsUpdateIndicators setObject:[NSNumber numberWithBool:YES] forKey:[self getNameForAreaType:areaType]];
    }
}

- (void)handleNewTotalValues:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSInteger areaType = [[userInfo objectForKey:@"areaType"] integerValue];
    [self.totalFeeDict setObject:userInfo forKey:[self getNameForAreaType:areaType]];
    if (areaType == _currentAreaType) {
        [self setrebateNumber:[[userInfo objectForKey:@"rateValues"] doubleValue]];
        [self setTotalPrice:[[userInfo objectForKey:@"totalNowPrice"] doubleValue]];
        [self setPayPrice:[[userInfo objectForKey:@"paymentValues"] doubleValue]];
        [self setfavorablePrice:[[userInfo objectForKey:@"subtractAmount"] doubleValue]];
    }
    NSLog(@"get total:%@, return:%@, areaType:%d", [userInfo objectForKey:@"totalNowPrice"], [userInfo objectForKey:@"rateValues"], areaType);
    [self setPayNumber];
    
    //TODO:
    [self addFooterView];
}

- (void)refreshCartItems
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"fetch cart item error %@", error.description);
    };
    NSArray *items = self.fetchedResultsController.fetchedObjects;
    [self.allAreaTypes removeAllObjects];
    [self.cartItems removeAllObjects];
    for (CartItem *item in items) {
        NSInteger areaType = item.areaType;
        NSMutableArray *array = [self.cartItems objectForKey:[self getNameForAreaType:areaType]];
        if (array == nil) {
            if ([self.needsUpdateIndicators objectForKey:[self getNameForAreaType:areaType]] == nil) {
                [self.needsUpdateIndicators setObject:[NSNumber numberWithBool:YES] forKey:[self getNameForAreaType:areaType]];
            }
            NSMutableArray *arr = [NSMutableArray arrayWithObject:item];
            [self.cartItems setObject:arr forKey:[self getNameForAreaType:areaType]];
            BOOL findLargerOne = NO;
            for (int i = 0; i < [self.allAreaTypes count]; ++i) {
                //arrange in ascending order
                NSNumber *number = [self.allAreaTypes objectAtIndex:i];
                if ([number intValue] > areaType) {
                    findLargerOne = YES;
                    [self.allAreaTypes insertObject:[NSNumber numberWithInt:areaType] atIndex:i];
                    break;
                }
            }
            if (!findLargerOne) {
                [self.allAreaTypes addObject:[NSNumber numberWithInt:areaType]];
            }
        }
        else{
            [array addObject:item];
        }
    }
    
    if ([self.allAreaTypes count] > 0) {
        if (_currentAreaType < 0 || _currentAreaType > 4) {
            _currentAreaType = [[self.allAreaTypes objectAtIndex:0] integerValue];
        }
        else{
            //if the corresponding area products get deleted, set new area type
            NSArray *arr = [self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]];
            if (arr == nil || [arr count] == 0) {
                _currentAreaType = [[self.allAreaTypes objectAtIndex:0] integerValue];
            }
        }
    }
    
    [self addHeaderView];
    [self addFooterView];
    [self addBottomView];
    [self addNoCartItemView];
    [self.tableView reloadData];
    
    int total = 0;
    for (CartItem *item in items) {
        total += item.availableAmount;
    }
    [Utils updateCartBadgeNumberWithNumber:total];
    [self setPayNumber];
    //如果没有商品
    if (items.count == 0) {
        self.backgroundImageView.alpha = 1;
        self.backgroundLabel.alpha = 1;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.navigationItem.rightBarButtonItem setTitle:@""];
    } else {
        self.backgroundImageView.alpha = 0;
        self.backgroundLabel.alpha = 0;
        self.tableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        if (_editing) {
            [self.navigationItem.rightBarButtonItem setTitle:@"确定"];
        } else {
            [self.navigationItem.rightBarButtonItem setTitle:@"删除"];
        }
    }
}

- (void)refreshAndDownloadData
{
    [self refreshCartItems];
    [self updateCartInformation];
}

- (void)updateCartInformation
{
    CartURLSession *session = [[CartURLSession alloc] init];
    if (_currentAreaType >= 0 && _currentAreaType < 5) {
        [session updateCartItems:[self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]]];
        [self.needsUpdateIndicators setObject:[NSNumber numberWithBool:NO] forKey:[self getNameForAreaType:_currentAreaType]];
    }
}

//redownload data if we find some products are not enough to meet user's demand
- (void)downloadDataAvaiable
{
    [self refreshCartItems];
    CartURLSession *session = [[CartURLSession alloc] init];
    if (_currentAreaType >= 0 && _currentAreaType < 5) {
        [session updateForAvailableProducts:[self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]]];
    }
    if (self.customerOrderVC) {
        self.customerOrderVC.cartItems = [self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]];
        
        //TODO: delete
        
        [self.customerOrderVC getCheckoutResponseAndShowWarning:NO forAvailable:YES];
    }
}

- (NSString *)getNameForAreaType:(NSInteger)AreaType
{
    switch (AreaType) {
        case 0:
            return @"大陆";
        case 1:
            return @"香港";
        case 2:
            return @"美国";
        case 3:
            return @"日本";
        case 4:
            return @"欧洲";
        default:
            return @"大陆";
            break;
    }
}

#pragma mark --
#pragma mark -- callbacks --
- (void)deleteItems:(UIBarButtonItem *)sender
{
    if (_editing) {
        [self.tableView setEditing:NO animated:YES];
        _editing = NO;
        sender.title = @"删除";
    }
    else{
        _editing = YES;
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"确定";
    }
}

#pragma mark --
#pragma mark --UITableViewDelegate and UITableViewDataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *name = [self getNameForAreaType:_currentAreaType];
    NSArray *arr = [self.cartItems objectForKey:name];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CartCellIdentifier forIndexPath:indexPath];
    NSString *name = [self getNameForAreaType:_currentAreaType];
    NSArray *arr = [self.cartItems objectForKey:name];
    CartItem *item = [arr objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.productName;
    
    //价钱
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f", item.refPrice]];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attribute.length)];
    //数量
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" x%d", item.quantity]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attribute.length)];
    cell.priceLabel.attributedText = attribute;
    
    if (item.availableAmount != item.quantity && item.availableAmount > 0) {
        cell.quantityLabel.text = [NSString stringWithFormat:@"%d", item.availableAmount];
    } else {
        cell.quantityLabel.text = @"";
    }
    
    if (item.inventoryStatus == 2) {
        //无库存
        cell.emptyImageView.hidden = NO;
        cell.emptyLabel.text = @"";
        cell.titleLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
    } else if (item.inventoryStatus == 1){
        //库存不做
        cell.emptyImageView.hidden = YES;
        cell.emptyLabel.text = @"库存不足";
    } else if (item.inventoryStatus == 0){
        //正常
        cell.emptyImageView.hidden = YES;
        cell.emptyLabel.text = @"";
    }
    
    if (item.color) {
        cell.colorLabel.text = item.color;
    } else {
        cell.colorLabel.text = @"";
    }

    if (item.size) {
        cell.sizeLabel.text = item.size;

    } else {
        cell.sizeLabel.text = @"";
    }
    
    if (item.image) {
        UIImage *image = [UIImage imageWithData:item.image];
        cell.alpha = 0.0;
        cell.image.image = image;
        [UIView animateWithDuration:0.2 animations:^{
            cell.alpha = 1.0;
        }];
    } else {
        cell.image.image = [UIImage imageNamed:@"place_holder_160.png"];
        [self downloadImageForIndex:indexPath];
    }
    
    if (indexPath.row > 0) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
        [cell addSubview:lineView];
    }
    return cell;
}

- (void)downloadImageForIndex:(NSIndexPath *)indexPath
{
    // make sure it doesn't have to convert url
    NSString *name = [self getNameForAreaType:_currentAreaType];
    NSArray *arr = [self.cartItems objectForKey:name];
    CartItem *item = [arr objectAtIndex:indexPath.row];
    NSString *imageUrl = item.imageUrl;
    if (imageUrl) {
        if ([self.downloadImageTasks objectForKey:imageUrl] == nil) {
            [self.downloadImageTasks setObject:indexPath forKey:imageUrl];
            __weak typeof(self) weakSelf = self;
            [[ImageDownloaderManager sharedInstance] addImageDowningTask:imageUrl cached:NO completion:^(NSString *url, UIImage *image, NSError *error) {
                typeof(self) strongSelf = weakSelf;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        NSString *name = [strongSelf getNameForAreaType:_currentAreaType];
                        NSArray *arr = [strongSelf.cartItems objectForKey:name];
                        CartItem *item = [arr objectAtIndex:indexPath.row];
                        item.image = UIImageJPEGRepresentation(image, 1.0);
                    }
                    if (error == nil && image != nil) {
                        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    [self.downloadImageTasks removeObjectForKey:url];
                });
            }];
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSString *name = [self getNameForAreaType:_currentAreaType];
        NSArray *arr = [self.cartItems objectForKey:name];
        [self deleteCartItem:[arr objectAtIndex:indexPath.row]];
        [context deleteObject:[arr objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self refreshAndDownloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductInfoViewController *productVC = [storyboard instantiateViewControllerWithIdentifier:@"ProductInfoViewController"];
    CartItem *cartItem = [[self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]] objectAtIndex:indexPath.row];
    productVC.productID = cartItem.productId;
    productVC.hidesBottomBarWhenPushed = YES;
    productVC.navigationItem.title = @"商品详情";
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark --
#pragma mark -- net wroking
- (void)deleteCartItem:(CartItem *)item
{
    NSString *proInfo = [Utils cartProductInfo];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/cart_cartDelete.action?productInfo=%@&areaType=%hd&itemKey=%@", [proInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], item.areaType, [[NSString stringWithFormat:@"%@_%d", item.productId, 0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([UserInfoManager getUserUpKey] && [UserInfoManager didSignIn]) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&upkey=%@", [UserInfoManager getUserUpKey]]];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error  == nil && data) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                if ([[jsonResponse objectForKey:@"recode"] integerValue] == 0) {
                    NSLog(@"delete successfully");
                }
                else if ([[jsonResponse objectForKey:@"recode"] integerValue] == 1007){
                    NSLog(@"wrong user name or password");
                }
            }
        }
    }];
    
    [Utils updateCartBadgeNumberWithNumber:-1];
}

#pragma mark --
#pragma mark -- LoginDelegate --
- (void)didLogin
{
    [self getCheckoutResponse:_buyAvailable];
    [self.payButton setTitle:@"结算中..." forState:UIControlStateNormal];
}

#pragma mark --
#pragma mark -- footer and header --
- (void)addHeaderView
{
    NSInteger total = [self.allAreaTypes count];
    if (total <= 1) {
        if (self.tableView.tableHeaderView) {
            self.tableView.tableHeaderView = nil;
        }
        return;
    }
    
//    CGFloat width = 64;
    CGFloat height = 50;
    CGFloat segmentHeight = 30;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, height - 0.5, view.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [view addSubview:lineView];
    
    NSMutableArray *names = [NSMutableArray array];
    for (int i = 0; i < total; ++i) {
        NSInteger num = [[self.allAreaTypes objectAtIndex:i] integerValue];
        NSString *name = [self getNameForAreaType:num];
        [names addObject:name];
    }
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:names];
//    CGRect frame = self.navigationController.navigationBar.frame;
//    segmentControl.frame = CGRectMake((frame.size.width - width * total) / 2.0, (height - segmentHeight) / 2.0, width * total, segmentHeight);
    segmentControl.frame = CGRectMake(10, (height - segmentHeight) / 2.0, view.frame.size.width-20, segmentHeight);
    [view addSubview:segmentControl];
    [segmentControl addTarget:self action:@selector(handleSegmentEvent:) forControlEvents:UIControlEventValueChanged];
    NSInteger selectedIndex = 0;
    for (int i = 0; i < [self.allAreaTypes count]; ++i) {
        if ([[self.allAreaTypes objectAtIndex:i] integerValue] == _currentAreaType) {
            selectedIndex = i;
            break;
        }
    }
    segmentControl.tintColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
    segmentControl.selectedSegmentIndex = selectedIndex;
    self.tableView.tableHeaderView = view;
}

- (void)handleSegmentEvent:(UISegmentedControl *)segmentControl
{
    NSInteger index = segmentControl.selectedSegmentIndex;
    NSInteger num = [[self.allAreaTypes objectAtIndex:index] integerValue];
    [self didPressButton:num];
}

- (void)didPressButton:(NSInteger )areaType
{
    _currentAreaType = areaType;
    [self.tableView reloadData];
    
    NSDictionary *userInfo = [self.totalFeeDict objectForKey:[self getNameForAreaType:_currentAreaType]];
    [self setPayPrice:[[userInfo objectForKey:@"paymentValues"] doubleValue]];
    
    if ([[self.needsUpdateIndicators objectForKey:[self getNameForAreaType:_currentAreaType]] boolValue]) {
        [self updateCartInformation];
    }
    
    [self addFooterView];

    [self setPayNumber];
}

- (void)addFooterView
{
    NSInteger total = [self.allAreaTypes count];
    if (total == 0) {
        self.tableView.tableFooterView = nil;
        return;
    }
    
    if (!(0 == _currentAreaType || 2 == _currentAreaType)) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 40)];
        footerView.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = footerView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, footerView.frame.size.width - 20, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        [footerView addSubview:label];
        
        if (1 == _currentAreaType) {
            label.text = @"应付金额 = 港币价总金额 * 汇率";
        } else if (3 == _currentAreaType) {
            label.text = @"应付金额 = 日元价总金额 * 汇率";
        } else if (4 == _currentAreaType) {
            label.text = @"应付金额 = 欧元价总金额 * 汇率";
        } else {
            [label removeFromSuperview];
            self.tableView.tableFooterView = nil;
        }
        return;
    }
    
    NSInteger totalPrice = 0, returnValue = 0, subtractAmount = 0, carriageFee = 0;
    NSDictionary *dict = [self.totalFeeDict objectForKey:[self getNameForAreaType:_currentAreaType]];
    if (dict) {
        totalPrice = [[dict objectForKey:@"totalNowPrice"] doubleValue];
        returnValue = [[dict objectForKey:@"rateValues"] doubleValue];
        subtractAmount = [[dict objectForKey:@"subtractAmount"] doubleValue];
        carriageFee = [[dict objectForKey:@"carriageFee"] doubleValue];
    } else {
        NSArray *array = [self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]];
        for (CartItem *item in array) {
            totalPrice += item.quantity * item.refPrice;
            totalPrice += item.returnValue;
        }
    }
    
    float offset = 0;
    float width = CGRectGetWidth(self.view.frame) - offset * 2;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 100)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(offset, 10, width, 80)];
    backgroundView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [footerView addSubview:backgroundView];
    
    //商品金额
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, width, 20)];
    priceLabel.backgroundColor = [UIColor clearColor];
    self.totalPriceLabel = priceLabel;
    [backgroundView addSubview:priceLabel];
    [self setTotalPrice:totalPrice];
    UIView *lastView = priceLabel;
    
    //下单优惠
    if (subtractAmount > 0) {
        UILabel *favorable =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame), width, 20)];
        favorable.backgroundColor = [UIColor clearColor];
        self.favorableLabel = favorable;
        [backgroundView addSubview:favorable];
        [self setfavorablePrice:subtractAmount];
        lastView = favorable;
    }
    
    //返利库币
    if (returnValue > 0) {
        UILabel *rebateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame), width, 20)];
        rebateLabel.backgroundColor = [UIColor clearColor];
        self.rebateLabel = rebateLabel;
        [backgroundView addSubview:rebateLabel];
        [self setrebateNumber:returnValue];
        lastView = rebateLabel;
    }
    
    //运费
    if (carriageFee > 0) {
        UILabel *carriageFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame), width, 20)];
        carriageFeeLabel.backgroundColor = [UIColor clearColor];
        self.carriageFeeLabel = carriageFeeLabel;
        [backgroundView addSubview:carriageFeeLabel];
        [self setCarriageFeePrice:(float)carriageFee];
        lastView = carriageFeeLabel;
    }
    
    //美国
    if (2 == _currentAreaType) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame)+10, width, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        label.text = @"应付金额 = 美元价总金额 * 汇率 + 运费";
        [label sizeToFit];
        [backgroundView addSubview:label];
        lastView = label;
    }
    
    CGRect frame = backgroundView.frame;
    frame.size.height = CGRectGetMaxY(lastView.frame) + 10;
    backgroundView.frame = frame;
}

- (void)addBottomView
{
    NSInteger total = [self.allAreaTypes count];
    if (total == 0) {
        [self.checkOutView removeFromSuperview];
        UIEdgeInsets inset = self.tableView.contentInset;
        self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0, 0, 0);
        return;
    }
    
    CGFloat height = 64;
    CGFloat originY = CGRectGetHeight(self.view.frame) - height;
    //NSLog(@"originY:%f", originY);
    float version = floorf(NSFoundationVersionNumber);
    if (!(version > NSFoundationVersionNumber_iOS_6_1)) {
        originY = SCREEN_HEIGHT - height - 20;
        if (!self.navigationController.navigationBar.hidden) {
            originY -= CGRectGetHeight(self.navigationController.navigationBar.frame);
            //NSLog(@"originY-:%f", originY);
        }
        if (!self.tabBarController.tabBar.hidden) {
            originY -= CGRectGetHeight(self.tabBarController.tabBar.frame);
            //NSLog(@"originY--:%f", originY);
        }
        UIEdgeInsets inset = self.tableView.contentInset;
        self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0, CGRectGetHeight(self.checkOutView.frame), 0);
    }
    else{
        if (!self.tabBarController.tabBar.hidden) {
            CGFloat len = CGRectGetHeight(self.tabBarController.tabBar.frame);
            originY -= len;
            //NSLog(@"originY--:%f", originY);
            UIEdgeInsets inset = self.tableView.contentInset;
            self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0, CGRectGetHeight(self.checkOutView.frame) + len, 0);
        }
        else{
            UIEdgeInsets inset = self.tableView.contentInset;
            self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0, CGRectGetHeight(self.checkOutView.frame), 0);
        }
    }
    //NSLog(@"originY---:%f", originY);
    if (self.checkOutView == nil) {
        [self.checkOutView removeFromSuperview];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth(self.view.frame), height)];
        view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [self.view addSubview:view];
        self.checkOutView = view;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), 1)];
        lineView.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
        [view addSubview:lineView];
        
        float offset = 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offset, 11, 200, 18)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
        label.text = @"应付金额";
        [view addSubview:label];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, CGRectGetMaxY(label.frame)+3, 200, 21)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont systemFontOfSize:19];
        priceLabel.textColor = [UIColor colorWithRed:222/255.0 green:0 blue:0 alpha:1];
        priceLabel.text = @"";
        self.payLabel = priceLabel;
        [view addSubview:priceLabel];
        self.priceLabel = priceLabel;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[NSString stringWithFormat:@"去结算"] forState:UIControlStateNormal];
        button.frame = CGRectMake(CGRectGetWidth(view.frame)-140, 12, 130, 40);
        button.backgroundColor = [UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 3;
        [button addTarget:self action:@selector(checkOut:) forControlEvents:UIControlEventTouchUpInside];
        self.payButton = button;
        [view addSubview:button];
        
        [self setPayNumber];
    }
    else{
        //TODO: 改变价格
        self.checkOutView.frame = CGRectMake(0, originY, CGRectGetWidth(self.view.frame), height);
    }
    
    NSInteger totalPrice = 0;
    NSDictionary *dict = [self.totalFeeDict objectForKey:[self getNameForAreaType:_currentAreaType]];
    if (dict) {
        totalPrice = [[dict objectForKey:@"totalNowPrice"] doubleValue];
    }
    else{
        NSArray *array = [self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]];
        for (CartItem *item in array) {
            totalPrice += item.quantity * item.refPrice;
        }
    }
    //paymentValues
    [self setPayPrice:[[dict objectForKey:@"paymentValues"] doubleValue]];
}

- (void)checkOut:(UIButton *)sender
{
    //友盟统计
    [MobClick event:@"iOS_jiesuan_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_jiesuan_uv"];
    
    if (![Utils checkNewworkStatusAndWarning:YES toView:self.view]) {
        return;
    }
    NSArray *array = [self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]];
    for (CartItem *item in array) {
        if (item.inventoryStatus == 2 || item.inventoryStatus == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，你的购物袋中有商品售罄或库存不足，你可以继续提交，售罄商品不会算入其中；库存不足商品，你会买走我们库存中有的数量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            [alertView show];
            return;
        }
    }
    
    if ([UserInfoManager didSignIn] && [UserInfoManager getUserUpKey]) {
        [self getCheckoutResponse:_buyAvailable];
        [sender setTitle:@"结算中..." forState:UIControlStateNormal];
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginTableViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
        loginVC.delegate = self;
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:naviVC animated:YES completion:nil];
    }
}

- (void)getCheckoutResponse:(BOOL)forAvailable
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSArray *array = [self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]];
    if ([array count] == 0) {
        return;
    }
    
    NSString *productInfo = [self getProductInfoString:forAvailable];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/cartshowconfirm.action?upkey=%@&cart=%@&areaType=%d", [upKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], productInfo, _currentAreaType];
    
    __weak typeof(CartViewController *) weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(CartViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *receiveDic = (NSDictionary *)jsonResponse;
                        NSDictionary *rp_result = [receiveDic objectForKey:@"rp_result"];
                        
                        if (0 == [[rp_result objectForKey:@"recode"] intValue]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [strongSelf.payButton setTitle:@"去结算" forState:UIControlStateNormal];
                                [self setPayNumber];
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                CustomerOrderViewController *customOrderVC = [storyboard instantiateViewControllerWithIdentifier:@"CustomerOrderViewController"];
                                strongSelf.customerOrderVC = customOrderVC;
                                customOrderVC.hidesBottomBarWhenPushed = YES;
                                customOrderVC.buyNowProductId = nil;
                                customOrderVC.isBuyNow = NO;
                                customOrderVC.jsonDictionary = rp_result;
                                customOrderVC.productArray = [[rp_result objectForKey:@"cart"] objectForKey:@"cartItems"];
                                customOrderVC.payAndDeliver = [rp_result objectForKey:@"payAndDeliver"];
                                customOrderVC.cartItems = [strongSelf.cartItems objectForKey:[strongSelf getNameForAreaType:_currentAreaType]];
                                customOrderVC.forAvailable = _buyAvailable;
//                                [strongSelf.mbProgressHUD hide:YES];
                                [strongSelf.navigationController pushViewController:customOrderVC animated:YES];
                                
                                BOOL ok = NO;
                                for (NSDictionary *dict in customOrderVC.productArray) {
                                    if ([[dict objectForKey:@"inventoryStatus"] integerValue] != 0) {
                                        ok = YES;
                                        break;
                                    }
                                }
                                if (ok) {
                                    [strongSelf updateCartInformation];
                                }
                            });
                        }
                        else if ([[rp_result objectForKey:@"recode"] intValue] == 1060){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [strongSelf updateCartInformation];
                                [strongSelf.payButton setTitle:@"去结算" forState:UIControlStateNormal];
                                [self setPayNumber];
//                                [strongSelf.mbProgressHUD hide:YES];
                                [MBProgressHUD showError:[rp_result objectForKey:@"errMsg"] toView:strongSelf.view];
                            });
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [strongSelf updateCartInformation];
                                [strongSelf.payButton setTitle:@"去结算" forState:UIControlStateNormal];
                                [self setPayNumber];
//                                [strongSelf.mbProgressHUD hide:YES];
                                [MBProgressHUD showError:[rp_result objectForKey:@"errMsg"] toView:strongSelf.view];
                            });
                        }
                    }
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [strongSelf.payButton setTitle:@"再试一下" forState:UIControlStateNormal];
                    [self setPayNumber];
//                    [strongSelf.mbProgressHUD hide:YES];
                    [MBProgressHUD showError:@"亲，出错了，请再试一下" toView:strongSelf.view];
                });
            }
        }
    }];
}

- (NSString *)getProductInfoString:(BOOL)forAvailable
{
    NSString *productInfo;
    NSArray *array = [self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]];
    for (CartItem *cartItem in array) {
        int16_t number = cartItem.quantity;
        if (forAvailable) {
            number = cartItem.availableAmount;
            if (cartItem.inventoryStatus == 2) {
                continue;
            }
        }
        
        NSString *proInfo = [NSString stringWithFormat:@"{\"productId\":%@,\"quantity\":%d,\"type\":%d,\"areaType\":%hd}",cartItem.productId, number, 0, cartItem.areaType];
        if (productInfo == nil) {
            productInfo = proInfo;
        }
        else{
            productInfo = [NSString stringWithFormat:@"%@,%@", productInfo, proInfo];
        }
    }
    if (productInfo == nil) {
        return nil;
    }
    productInfo = [[NSString stringWithFormat:@"\"cartItems\":[%@]", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AddressEntity *addressEntity = [[AddressDataAccessor sharedInstance] getDefaulAddress];
    if (addressEntity) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"shippingId\":\"%lld\"", addressEntity.addressId]];
    }
    productInfo = [productInfo stringByAppendingString:@",\"aid\":1"];
    productInfo = [[NSString stringWithFormat:@"{%@}", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return productInfo;
}

- (void)addNoCartItemView
{
    if ([self.allAreaTypes count] == 0) {
        //TODO:
    }
}

#pragma mark -
//设置商品总金额
- (void)setTotalPrice:(float)price
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"商品金额: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f", price]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.totalPriceLabel.attributedText = attribute;
}

//设置下单优惠
- (void)setfavorablePrice:(float)price
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"下单优惠: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ -%.2f",price]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    text = [[NSMutableAttributedString alloc] initWithString:@" (仅限APP端下单)"];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    self.favorableLabel.attributedText = attribute;
}

//设置返利
- (void)setrebateNumber:(int)number
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"返利库币: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+ %d库币", number]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1/255.0 green:184/255.0 blue:0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.rebateLabel.attributedText = attribute;
}

//设置运费
- (void)setCarriageFeePrice:(float)price
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"需付运费: "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f", price]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:153/255.0 blue:23/255.0 alpha:1] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    self.carriageFeeLabel.attributedText = attribute;
}

//设置应付金额
- (void)setPayPrice:(float)price
{
    self.payLabel.text = [NSString stringWithFormat:@"¥ %.2f", price];
}

//设置结算按钮显示数量
- (void)setPayNumber
{
    int number = 0;
    NSArray *array = [self.cartItems objectForKey:[self getNameForAreaType:_currentAreaType]];
    for (int i = 0; i < [array count]; ++i) {
        CartItem *cartItem = [array objectAtIndex:i];
        int num = cartItem.availableAmount;
        number += num;
    }
    
    if (0 >= number) {
        [self.payButton setTitle:[NSString stringWithFormat:@"去结算"] forState:UIControlStateNormal];
    } else {
        [self.payButton setTitle:[NSString stringWithFormat:@"去结算(%d)", number] forState:UIControlStateNormal];
    }
}

#pragma mark--
#pragma mark-- UIAlertViewDelegate--
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        _buyAvailable = YES;
        [self getCheckoutResponse:_buyAvailable];
        [self.payButton setTitle:@"结算中..." forState:UIControlStateNormal];
    }
}

#pragma mark--
#pragma mark-- getter and setter --

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
        
        [request setFetchBatchSize:20];
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"addDate" ascending:YES];
        [request setSortDescriptors:@[sorter]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
    }
    return _fetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _managedObjectContext = delegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (NSMutableDictionary *)cartItems
{
    if (_cartItems == nil) {
        _cartItems = [[NSMutableDictionary alloc] init];
    }
    return _cartItems;
}

- (NSMutableArray *)allAreaTypes
{
    if (_allAreaTypes == nil) {
        _allAreaTypes = [[NSMutableArray alloc] init];
    }
    return _allAreaTypes;
}

- (NSMutableDictionary *)secooCoin
{
    if (_secooCoin == nil) {
        _secooCoin = [[NSMutableDictionary alloc] init];
    }
    return _secooCoin;
}

- (NSMutableDictionary *)needsUpdateIndicators
{
    if (_needsUpdateIndicators == nil) {
        _needsUpdateIndicators = [[NSMutableDictionary alloc] init];
    }
    return _needsUpdateIndicators;
}

- (NSMutableDictionary *)totalFeeDict
{
    if (_totalFeeDict == nil) {
        _totalFeeDict = [[NSMutableDictionary alloc] init];
    }
    return _totalFeeDict;
}

- (NSMutableDictionary *)downloadImageTasks
{
    if (_downloadImageTasks == nil) {
        _downloadImageTasks = [[NSMutableDictionary alloc] init];
    }
    return _downloadImageTasks;
}

@end
