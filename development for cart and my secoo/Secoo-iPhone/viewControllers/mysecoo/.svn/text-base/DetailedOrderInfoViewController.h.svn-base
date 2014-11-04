//
//  DetailedOrderInfoViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/13/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeRateInfoViewController.h"

@protocol OrderOperationDelegate <NSObject>

@optional;
- (void)didPayForOrderId:(NSString *)orderId;
- (void)didCancelOrderId:(NSString *)orderId;

@end

@interface DetailedOrderInfoViewController : UIViewController<UIAlertViewDelegate, ExchangeRateInfoDelegate>

@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, assign) NSInteger goBackType;//0, normal, 1, product info viewcontroller, 2, main page
@property(nonatomic, weak) id<OrderOperationDelegate> delegate;

@end
