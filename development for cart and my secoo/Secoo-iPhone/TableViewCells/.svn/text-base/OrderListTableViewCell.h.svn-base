//
//  OrderListTableViewCell.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-10-11.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderListTableViewCell;

@protocol OrderTableCellSpreadDelegate <NSObject>

@optional
- (void)orderTableCell:(OrderListTableViewCell *)cell didSpread:(BOOL)spread;

@end

@interface OrderListTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dictSource;
@property (strong, nonatomic) NSMutableArray *productViewArray;

@property (weak, nonatomic) UILabel *OrderNumberLabel;
@property (weak, nonatomic) UILabel *statusLabel;
@property (weak, nonatomic) UILabel *numberLabel;
@property (weak, nonatomic) UILabel *totalPriceLabel;

@property (weak, nonatomic) id<OrderTableCellSpreadDelegate> delegate;
@property (assign, nonatomic) BOOL isSpreading;

+ (CGFloat)calculateHeight:(NSDictionary *)dict isSpreading:(BOOL)isSpreading;

@end

@interface ProductSubView : UIView

@property(weak, nonatomic) UIImageView* productImageView;
@property(weak, nonatomic) UILabel *title;
@property(weak, nonatomic) UILabel *priceLabel;

@end
