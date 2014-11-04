//
//  CouponViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/26/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponViewControllerDelegate <NSObject>

- (void)didSelectCoupon:(NSDictionary *)coupon;

@end

@interface CouponViewController : UIViewController

@property(weak, nonatomic) id<CouponViewControllerDelegate>delegate;

@end
