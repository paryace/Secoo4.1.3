//
//  CustomerOrderViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/24/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"
#import "KuCoinViewController.h"

@interface CustomerOrderViewController : UIViewController<CheckButtonDelegate, KuCoinOperationDelegate, UITextFieldDelegate>{
    BOOL      _forAvailable;
}

@property(nonatomic, strong) NSDictionary *jsonDictionary;//解析结果 rp_result
@property(nonatomic, strong) NSArray *productArray;//所有商品
@property(nonatomic, strong) NSArray *payAndDeliver;//配送方式和支付方式
@property(nonatomic, strong) NSArray *cartItems;
@property(nonatomic, assign) BOOL forAvailable;
@property(nonatomic, assign) BOOL isBuyNow;
@property(nonatomic, strong) NSString *buyNowProductId;

- (NSString *)getProductInfoStringWithCouponOrKuCoin:(BOOL)forAvailable;
- (void)getCheckoutResponseAndShowWarning:(BOOL)willShow forAvailable:(BOOL)forAvailable;
@end
