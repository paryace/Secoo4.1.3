//
//  OrderListViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/10/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "OrderListViewController.h"
#import "ImageDownloaderManager.h"
#import "UserInfoManager.h"
#import "LGURLSession.h"
#import "OrderListTableViewCell.h"
#import "DetailedOrderInfoViewController.h"
#import "ActionView.h"

@interface OrderListViewController ()<ActionViewDelegate, OrderTableCellSpreadDelegate, OrderOperationDelegate>
{
    int _currentPage;
    int _totalPage;
    BOOL _isLoading;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIActivityIndicatorView  *indicatorView;

@property (strong, nonatomic) NSMutableArray *orders;
@property (strong, nonatomic) NSMutableDictionary *images;
@property (strong, nonatomic) NSMutableDictionary *downloadImageTasks;
@property (strong, nonatomic) NSMutableDictionary *spreadingState;

@end

@implementation OrderListViewController

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
    self.title = @"我的订单";
    [self startActivityIndicatorView];
    [self.tableView registerClass:[OrderListTableViewCell class] forCellReuseIdentifier:@"OrderListTableViewCell"];
    _totalPage = 0;
    [self getOrderListAtPage:1 qyDate:@"2" qyStatus:@"0"];
    
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    [MobClick beginLogPageView:@"OrderList"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"OrderList"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    NSArray *allKeys = [self.downloadImageTasks allKeys];
    [allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *downloadingSession = (NSString *)obj;
        [[ImageDownloaderManager sharedInstance] cancelSession:downloadingSession];
    }];
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startActivityIndicatorView
{
    CGRect frame = CGRectMake((self.view.frame.size.width - 50) / 2.0, (self.view.frame.size.height - 50) / 2.0, 50, 50);
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [self.view addSubview:indicatorView];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [indicatorView startAnimating];
    self.indicatorView = indicatorView;
}

#pragma mark - 点击我的订单
- (void)handleMyOrderStateAction:(UIButton *)sender
{
//    NSLog(@"%s", __FUNCTION__);
//    ActionView *actionView = [[ActionView alloc] initWithTitleArray:@[@"待付款",@"待配送",@"待自提"] delegate:self];
//    [actionView show];
}

#pragma mark - ActionViewDelegate Method
- (void)didClickActionButtonWithIndex:(int)index
{
    NSLog(@"buttonIndex %d", index);
    if (0 == index) {
        
    } else if (1 == index) {
        
    } else if (2 == index) {
        
    }
}


#pragma mark --
#pragma mark --newtwork--
- (void)getOrderListAtPage:(NSInteger)pageNumber qyDate:(NSString *)qyDate qyStatus:(NSString *)qyStatus
{
    _isLoading = YES;
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=order/myorder.jsp&v=1.0&client=iphone&vo.upkey=%@&qydate=%@&qystatus=%@&pageSize=15&method=secoo.orders.list&currPage=%d&fields=orderId,amount,orderAmt,status,payStatus,orderDate,rebate,products", upKey, qyDate, qyStatus, pageNumber];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(OrderListViewController *)weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(OrderListViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.indicatorView) {
                    [strongSelf.indicatorView stopAnimating];
                    [strongSelf.indicatorView removeFromSuperview];
                }
            });
            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        NSDictionary *subPageDict = [jsonDict objectForKey:@"page"];
                        NSArray *orderArray = [jsonDict objectForKey:@"orders"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _currentPage = [[subPageDict objectForKey:@"currPage"] integerValue];
                            _totalPage = [[subPageDict objectForKey:@"maxPage"] integerValue];
                            [strongSelf.orders addObjectsFromArray:orderArray];
                            //areaType(int), payStatus(NSString), products(NSArray) orderAmt(double) orderDate(long)
                            //orderType(int) enableCancel(BOOL) status(NSString) orderId(long)
                            [strongSelf.tableView reloadData];
                        });
                    }
                    
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                _isLoading = NO;
            });
        }
    }];
}

#pragma mark --
#pragma mark -- UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    if ([self.spreadingState objectForKey:[NSString stringWithFormat:@"row%d", indexPath.row]] == nil) {
        cell.isSpreading = NO;
    }
    else{
        cell.isSpreading = [[self.spreadingState objectForKey:[NSString stringWithFormat:@"row%d", indexPath.row]] boolValue];
    }
    
    NSDictionary *dict = [self.orders objectAtIndex:indexPath.row];
    cell.dictSource = dict;
    NSArray *products = [dict objectForKey:@"products"];
    int areaType = [[dict objectForKey:@"areaType"] intValue];
    float price = [[dict objectForKey:@"orderAmt"] floatValue];
    NSString *totalPrice = [NSString stringWithFormat:@"实付款:%@", [Utils moneyTypeWithAreaType:areaType price:price]];//实付款
    
    cell.OrderNumberLabel.text = [NSString stringWithFormat:@"订单号: %lld", [[dict objectForKey:@"orderId"] longLongValue]];
    cell.statusLabel.text = [dict objectForKey:@"status"];
    cell.numberLabel.text = [NSString stringWithFormat:@"共%d件", [products count]];
    cell.totalPriceLabel.text = totalPrice;
    
    NSInteger count = 2;
    if (cell.isSpreading == YES) {
        count = [products count];
    }
    if (count > [products count]) {
        count = [products count];
    }
    for (int i = 0; i < count; ++i) {
        NSDictionary *proDict = [products objectAtIndex:i];
        ProductSubView *productView = [cell.productViewArray objectAtIndex:i];
        NSString *imageUrl = [Utils convertToRealUrl:[proDict objectForKey:@"pictureUrl"] ofsize:80];
        if ([self.images objectForKey:imageUrl] == nil) {
            if (!self.tableView.dragging && !self.tableView.decelerating) {
               [self downloadImageForUrl:imageUrl];
            }
            //TODO:change default image
            productView.productImageView.image = _IMAGE_WITH_NAME(@"Icon-60");
        }
        else{
            productView.productImageView.image = [self.images objectForKey:imageUrl];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.orders objectAtIndex:indexPath.row];
    NSNumber *number = [self.spreadingState objectForKey:[NSString stringWithFormat:@"row%d", indexPath.row]];
    BOOL spreading = [number boolValue];
    CGFloat height = [OrderListTableViewCell calculateHeight:dict isSpreading:spreading];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.orders objectAtIndex:indexPath.row];
    long long orderID = [[dict objectForKey:@"orderId"] longLongValue];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailedOrderInfoViewController *detailedOrderInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"DetailedOrderInfoViewController"];
    detailedOrderInfoVC.orderId = [NSString stringWithFormat:@"%lld", orderID];
    detailedOrderInfoVC.goBackType = 0;
    detailedOrderInfoVC.delegate = self;
    [self.navigationController pushViewController:detailedOrderInfoVC animated:YES];
}

#pragma mark --
#pragma mark -- OrderOperationDelegate --
- (void)didPayForOrderId:(NSString *)orderId
{
    for (NSDictionary *dict in self.orders) {
        long long ordID = [[dict objectForKey:@"orderId"] longLongValue];
        if (ordID == [orderId longLongValue]) {
            [dict setValue:@"配货中" forKey:@"status"];
            break;
        }
    }
    [self.tableView reloadData];
}

- (void)didCancelOrderId:(NSString *)orderId
{
    for (NSDictionary *dict in self.orders) {
        long long ordID = [[dict objectForKey:@"orderId"] longLongValue];
        if (ordID == [orderId longLongValue]) {
            [dict setValue:@"已取消" forKey:@"status"];
            break;
        }
    }
    [self.tableView reloadData];
}

#pragma mark --
#pragma mark -- OrderTableCellDelegate --
- (void)orderTableCell:(OrderListTableViewCell *)cell didSpread:(BOOL)spread
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.spreadingState setObject:[NSNumber numberWithBool:spread] forKey:[NSString stringWithFormat:@"row%d", indexPath.row]];
    [self.tableView reloadData];
}

#pragma mark --
#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat height = scrollView.contentSize.height - scrollView.frame.size.height;
    if (contentOffsetY > height) {
        if (!_isLoading && _currentPage < _totalPage) {
            [self getOrderListAtPage:_currentPage + 1 qyDate:@"2" qyStatus:@"0"];
        }
        else if (_currentPage >= _totalPage){
            if (_totalPage > 0) {
                if (scrollView.dragging || scrollView.decelerating) {
                    [MBProgressHUD showError:@"亲，没有订单了" toView:self.view];
                }
                
            }
        }
        else{
            [MBProgressHUD showSuccess:@"亲，正在下载订单" toView:self.view];
        }
    }
    else{
        //
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

- (void)downloadImageForUrl:(NSString *)imageUrl
{
    if (imageUrl) {
        if ([self.downloadImageTasks objectForKey:imageUrl] == nil) {
            [self.downloadImageTasks setObject:@"downloading" forKey:imageUrl];
            __weak typeof(self) weakSelf = self;
            [[ImageDownloaderManager sharedInstance] addImageDowningTask:imageUrl cached:YES completion:^(NSString *url, UIImage *image, NSError *error) {
                typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil && image != nil) {
                            [strongSelf.images setObject:image forKey:imageUrl];
                            [strongSelf.tableView reloadData];
                        }
                        [strongSelf.downloadImageTasks removeObjectForKey:url];
                    });
                }
            }];
        }
    }
}

- (void)downloadImageForIndex:(NSIndexPath *)indexPath
{
    // make sure it doesn't have to convert url
    NSDictionary *order = [self.orders objectAtIndex:indexPath.row];
    NSArray *product = [order objectForKey:@"products"];
    if ([product count] == 0) {
        return;
    }
    NSString *imageUrl;
    for (NSDictionary *proDict in product) {
        imageUrl = [Utils convertToRealUrl:[proDict objectForKey:@"pictureUrl"] ofsize:80];
        [self downloadImageForUrl:imageUrl];
    }
}

- (void)downloadForVisibleCells
{
    NSArray *array = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in array) {
        if ([self.downloadImageTasks objectForKey:indexPath] == nil) {
            [self downloadImageForIndex:indexPath];
        }
    }
}

#pragma mark --
#pragma mark -- setter and getter --
- (NSMutableArray *)orders
{
    if (_orders == nil) {
        _orders = [[NSMutableArray alloc] init];
    }
    return _orders;
}

- (NSMutableDictionary *)images
{
    if (_images == nil) {
        _images = [[NSMutableDictionary alloc] init];
    }
    return _images;
}

- (NSMutableDictionary *)downloadImageTasks
{
    if (_downloadImageTasks == nil) {
        _downloadImageTasks = [[NSMutableDictionary alloc] init];
    }
    return _downloadImageTasks;
}

- (NSMutableDictionary *)spreadingState
{
    if (_spreadingState == nil) {
        _spreadingState = [[NSMutableDictionary alloc] init];
    }
    return _spreadingState;
}

@end
