//
//  CheckCenterWarnView.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CheckCenterWarningView.h"
#import "ImageDownloaderManager.h"

@interface CheckCenterWarningView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *soldOutProducts;
@property(nonatomic, strong) NSMutableDictionary *imageDict;
@property(nonatomic, strong) NSMutableDictionary *downloadingUrl;

@property(nonatomic, weak) UIView *centerView;
@property(nonatomic, weak) UITableView *tableView;

@end

@implementation CheckCenterWarningView

- (instancetype)initWithFrame:(CGRect)frame andSoleOutProduct:(NSArray *)array allSoldOut:(BOOL)allSoldOut
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
        self.allSoldOut = allSoldOut;
        _soldOutProducts = array;
        CGSize screenSize = frame.size;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, (screenSize.height - 420) / 2.0, screenSize.width - 60, 420)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 4;
        _centerView = view;
        [self addSubview:view];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dummyHandler)];
        [view addGestureRecognizer:tap1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(view.frame) - 20, 20)];
        label.textColor = [UIColor redColor];
        label.text = @"此商品已库存不足!";
        if (self.allSoldOut) {
            label.text = @"商品全部售罄!";
        }
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        NSString *str = @"你可以继续提交订单，售罄的商品不会计入，库存不足的商品, 你会买到库存有的数量计入你的订单";
        if(self.allSoldOut){
            str = @"你的商品全部售罄，再去逛逛吧";
        }
        CGFloat width = CGRectGetWidth(view.frame) - 60;
        CGSize strSize = [Utils getSizeOfString:str ofFont:[UIFont systemFontOfSize:12] withMaxWidth:width];
        UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5 + CGRectGetMaxY(label.frame), width, strSize.height)];
        warnLabel.lineBreakMode = NSLineBreakByWordWrapping;
        warnLabel.numberOfLines = 0;
        warnLabel.font = [UIFont systemFontOfSize:12];
        warnLabel.backgroundColor = [UIColor clearColor];
        warnLabel.text = str;
        [view addSubview:warnLabel];
        
        CGFloat rowHeight = 105;
        CGFloat height = 2 * rowHeight;;
        if ([array count] == 1) {
            height = rowHeight;
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(warnLabel.frame), CGRectGetWidth(view.frame) - 40, 0.5)];
        [view addSubview:lineView];
        lineView.backgroundColor = [UIColor grayColor];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(warnLabel.frame) + 1, CGRectGetWidth(view.frame) - 40, height)];
        [view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView reloadData];
        tableView.rowHeight = rowHeight;
        self.tableView = tableView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.layer.cornerRadius = 3;
        button.backgroundColor = [UIColor colorWithRed:238.0 / 255.0 green:134.0 / 255.0 blue:20.0 / 255.0 alpha:1.0];
        NSString *title = @"继续提交订单";
        if (self.allSoldOut) {
            title = @"重新挑选商品";
        }
        [button setTitle:title forState:UIControlStateNormal];
        button.frame = CGRectMake(30, CGRectGetMaxY(tableView.frame) + 5, CGRectGetWidth(view.frame) - 60, 35);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:button];
        frame = view.frame;
        frame.size.height = CGRectGetMaxY(button.frame) + 10;
        view.frame = frame;
        
        [button addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)dummyHandler
{}

- (void)submitOrder
{
    if (_delegate && [_delegate respondsToSelector:@selector(didWantToSubmit:)]) {
        [_delegate didWantToSubmit:self];
    }
    [self removeFromSuperview];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(didCancel:)]) {
        [_delegate didCancel:self];
    }
    [self removeFromSuperview];
}

#pragma mark - TableView Delegate & Datasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.soldOutProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"soldoutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    NSDictionary *dict = [self.soldOutProducts objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"productName"];
    
    if ([self.imageDict objectForKey:indexPath] == nil) {
        cell.imageView.image = [UIImage imageNamed:@"Icon-60.png"];
        if ([self.downloadingUrl objectForKey:indexPath] == nil) {
            NSString *imageUrl = [Utils convertToRealUrl:[dict objectForKey:@"productImg"] ofsize:80];
            [self.downloadingUrl setObject:imageUrl forKey:indexPath];
            __weak typeof(CheckCenterWarningView *) weakSelf = self;
            [[ImageDownloaderManager sharedInstance] addImageDowningTask:imageUrl cached:YES completion:^(NSString *url, UIImage *image, NSError *error) {
                typeof(CheckCenterWarningView *) strongSelf = weakSelf;
                if (strongSelf) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.downloadingUrl removeObjectForKey:indexPath];
                    });
                    if (error == nil) {
                        if(image){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                cell.imageView.image = image;
                                [strongSelf.imageDict setObject:image forKey:indexPath];
                            });
                        }
                    }
                }
            }];
        }
    }
    else{
        cell.imageView.image = [self.imageDict objectForKey:indexPath];
    }
    
    //TODO:
    return cell;
}

#pragma mark -- setter and getter --

- (NSMutableDictionary *)imageDict
{
    if (_imageDict == nil) {
        _imageDict = [[NSMutableDictionary alloc] init];
    }
    return _imageDict;
}

- (NSMutableDictionary *)downloadingUrl
{
    if (_downloadingUrl == nil) {
        _downloadingUrl = [[NSMutableDictionary alloc] init];
    }
    return _downloadingUrl;
}

@end
