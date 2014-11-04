//
//  CouponViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/26/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CouponViewController.h"
#import "LGURLSession.h"
#import "UserInfoManager.h"
#import "CouponTableViewCell.h"
#import "ActivateCouponViewController.h"

typedef enum : NSUInteger {
    CouponStatusUnused,
    CouponStatusUsed,
    CouponStatusExpired,
} CouponStatus;

@interface CouponViewController (){
    CouponStatus _couponStatus;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) UISegmentedControl *segmentControl;

@property (strong, nonatomic) NSArray *coupons;
@property (strong, nonatomic) NSArray *usedCoupons;
@property (strong, nonatomic) NSArray *expiredCoupons;

@end

@implementation CouponViewController

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
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    UIBarButtonItem *activateButton = [[UIBarButtonItem alloc] initWithTitle:@"激活" style:UIBarButtonItemStyleBordered target:self action:@selector(handleRightBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = activateButton;
    [self addSegmenControll];
    _couponStatus = CouponStatusUnused;
    [self addTableFooterView];
    [self getAllUnusedCoupons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.segmentControl setHidden:NO];
    
    [MobClick beginLogPageView:@"CouponVC"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.segmentControl setHidden:YES];
    
    [MobClick endLogPageView:@"CouponVC"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.segmentControl removeFromSuperview];
}

- (void)addSegmenControll
{
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"未使用", @"已使用", @"已过期"]];
    CGRect frame = self.navigationController.navigationBar.frame;
    segmentControl.frame = CGRectMake((frame.size.width - 180) / 2.0, (frame.size.height - 30) / 2.0, 180, 30);
    [self.navigationController.navigationBar addSubview:segmentControl];
    [segmentControl addTarget:self action:@selector(handleSegmentEvent:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl = segmentControl;
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = [UIColor colorWithWhite:68.0 / 255.0 alpha:1.0];
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

#pragma mark --
#pragma mark -- callbacks--

- (void)handleSegmentEvent:(UISegmentedControl *)segmentControl
{
    if (segmentControl.selectedSegmentIndex == 0) {
        _couponStatus = CouponStatusUnused;
        [self.tableView reloadData];
    }
    else if (segmentControl.selectedSegmentIndex == 1) {
        _couponStatus = CouponStatusUsed;
        if (self.usedCoupons == nil) {
            [self getAllUsedCoupons];
        }
        else{
            [self.tableView reloadData];
        }
    }
    else if (segmentControl.selectedSegmentIndex == 2) {
        _couponStatus = CouponStatusExpired;
        if (self.expiredCoupons == nil) {
            [self getExpiredCoupons];
        }
        else{
            [self.tableView reloadData];
        }
    }
}

- (void)handleRightBarButtonItemAction:(UIBarButtonItem *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivateCouponViewController *activateCouponVC = [storyboard instantiateViewControllerWithIdentifier:@"ActivateCouponViewController"];
    [self.navigationController pushViewController:activateCouponVC animated:YES];
}

- (void)getAllUnusedCoupons
{
    [self startActivityIndicatorView];
    NSString *couponURL = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=/ticket/myticket.jsp&v=1.0&client=iphone&method=secoo.ticketListByWsy.get&vo.upkey=%@&fields=ticketStartTimeVal,ticketMoney,ticketLastTimeVal, minOrderAmount", [UserInfoManager getUserUpKey]];
    couponURL = [couponURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(CouponViewController*) weakSelf = self;
    [session startConnectionToURL:couponURL completion:^(NSData *data, NSError *error) {
        if (weakSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.indicatorView stopAnimating];
                [weakSelf.indicatorView removeFromSuperview];
            });
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        weakSelf.coupons = [jsonDict objectForKey:@"zticketListByWsy"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView reloadData];
                        });
                    }
                    else{
                        NSLog(@"error:%@", [jsonDict objectForKey:@"errMsg"]);
                    }
                }
            }
            else{
                NSLog(@"get coupon error :%@", error.description);
            }

        }
    }];
}

- (void)getExpiredCoupons
{
    [self startActivityIndicatorView];
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=ticket/myticket.jsp&v=1.0&client=iphone&method=secoo.ticketListByGq.get&fields=ticketStartTimeVal,ticketMoney,ticketLastTimeVal, minOrderAmount&vo.upkey=%@", upKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(CouponViewController*) weakSelf = self;
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(CouponViewController*) strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.indicatorView stopAnimating];
                [strongSelf.indicatorView removeFromSuperview];
            });
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        strongSelf.expiredCoupons = [jsonDict objectForKey:@"zticketListByGq"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf.tableView reloadData];
                        });
                    }
                    else{
                        NSLog(@"error:%@", [jsonDict objectForKey:@"errMsg"]);
                    }
                }
            }
            else{
                NSLog(@"get coupon error :%@", error.description);
            }
        }
    }];
}

- (void)getAllUsedCoupons
{
    [self startActivityIndicatorView];
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=ticket/myticket.jsp&v=1.0&client=iphone&method=secoo.ticketListByYsy.get&fields=ticketStartTimeVal,ticketMoney,ticketLastTimeVal, minOrderAmount&vo.upkey=%@", upKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(CouponViewController*) weakSelf = self;
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(CouponViewController*) strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.indicatorView stopAnimating];
                [strongSelf.indicatorView removeFromSuperview];
            });
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                        strongSelf.usedCoupons = [jsonDict objectForKey:@"zticketListByYsy"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf.tableView reloadData];
                        });
                    }
                    else{
                        NSLog(@"error:%@", [jsonDict objectForKey:@"errMsg"]);
                    }
                }
            }
            else{
                NSLog(@"get coupon error :%@", error.description);
            }
        }
    }];
}

#pragma mark --
#pragma mark --UITableViewDelegate and UITableViewDataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (_couponStatus == CouponStatusUnused) {
        count = [self.coupons count];
    }
    else if (_couponStatus == CouponStatusUsed){
        count = [self.usedCoupons count];
    }
    else if (_couponStatus == CouponStatusExpired){
        count = [self.expiredCoupons count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CouponTableViewCell";
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dict;
    if (_couponStatus == CouponStatusUnused) {
        dict = [self.coupons objectAtIndex:indexPath.row];
    }
    else if (_couponStatus == CouponStatusUsed) {
        dict = [self.usedCoupons objectAtIndex:indexPath.row];
    }
    else if (_couponStatus == CouponStatusExpired){
        dict = [self.expiredCoupons objectAtIndex:indexPath.row];
    }
    
    double price = [[dict objectForKey:@"ticketMoney"] doubleValue];
    NSInteger minOrderMoney = [[dict objectForKey:@"minOrderAmount"] integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *starDate = [NSDate dateWithTimeIntervalSince1970:((double)([[dict objectForKey:@"ticketStartTimeVal"] longLongValue] / 1000))];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:((double)([[dict objectForKey:@"ticketLastTimeVal"] longLongValue] / 1000))];
    NSString *startStr= [formatter stringFromDate:starDate];
    NSString *endStr = [formatter stringFromDate:endDate];
    
    cell.backgroungImageView.image = _IMAGE_WITH_NAME([self imageNameWithPrice:price]);
    cell.valueLabel.text = [NSString stringWithFormat:@"%.0f", price];
    cell.dateLabel.text = [NSString stringWithFormat:@"有效期：%@至%@", startStr, endStr];
    if (minOrderMoney == 0) {
        cell.usageLabel.text = nil;
    }
    else{
        NSInteger value = (NSInteger)price;
        cell.usageLabel.text = [NSString stringWithFormat:@"满%d减%d", minOrderMoney, value];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_couponStatus == CouponStatusUnused) {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectCoupon:)]) {
            [self.navigationController popViewControllerAnimated:YES];
            NSDictionary *dict = [self.coupons objectAtIndex:indexPath.row];
            [_delegate didSelectCoupon:dict];
        }
    }
}

- (void)addTableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.tableView.tableFooterView = view;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, view.frame.size.width - 20, 30)];
    [view addSubview:lable];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"1.一笔订单只能使用"];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"一张优惠券哦"]];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
    [attribute appendAttributedString:text];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
    lable.attributedText = attribute;
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lable.frame), view.frame.size.width - 20, 30)];
    lable1.textColor = [UIColor lightGrayColor];
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.text = @"2.一笔订单只能选用一种优惠方式";
    [view addSubview:lable1];
}

- (NSString *)imageNameWithPrice:(double)price
{
    if (price < 100) {
        return @"coupon-100";
    } else if (price < 300) {
        return @"coupon-200";
    } else if (price < 500) {
        return @"coupon-500";
    } else if (price < 1000) {
        return @"coupon-1K";
    }
    return @"coupon>1K";
}

- (NSArray *)sortArray:(NSArray *)array
{
    if ([array count] == 0) {
        return nil;
    }
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:[array count]];
    [sortedArray addObject:[array objectAtIndex:0]];
    for (int i = 1; i < [array count]; ++i) {
        NSDictionary *dict = [array objectAtIndex:i];
        long long endTime = [[dict objectForKey:@"ticketLastTimeVal"] longLongValue];
        NSInteger minOrder = [[dict objectForKey:@"minOrderAmount"] integerValue];
        double price = [[dict objectForKey:@"ticketMoney"] doubleValue];
        
        BOOL findIt = NO;
        for (int j = 0; j < [sortedArray count]; ++j) {
            NSDictionary *subDict = [sortedArray objectAtIndex:j];
            NSInteger subOrder = [[subDict objectForKey:@"minOrderAmount"] integerValue];
            long long subTime = [[subDict objectForKey:@"ticketLastTimeVal"] longLongValue];
            double subPrice = [[subDict objectForKey:@"ticketMoney"] doubleValue];
            if (endTime < subTime) {
                [sortedArray insertObject:dict atIndex:j];
                findIt = YES;
                break;
            }
            else if((endTime == subTime) && (minOrder < subOrder)){
                [sortedArray insertObject:dict atIndex:j];
                findIt = YES;
                break;
            }
            else if ((endTime == subTime) && (minOrder == subOrder) && (price > subPrice)){
                [sortedArray insertObject:dict atIndex:j];
                findIt = YES;
                break;
            }
        }
        if (!findIt) {
            [sortedArray addObject:dict];
        }
    }
    return sortedArray;
}

#pragma mark --
#pragma mark -- setter and getter --
- (void)setCoupons:(NSArray *)coupons
{
    if(coupons != _coupons){
        _coupons = [self sortArray:coupons];
    }
}

@end
