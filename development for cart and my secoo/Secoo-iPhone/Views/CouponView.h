//
//  CouponView.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-28.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponViewDelegate <NSObject>

- (void)didSelectOneCouponViewWithInfo:(NSDictionary *)info;

@end

//          优惠券
@interface CouponView : UIView

- (instancetype)initWithFrame:(CGRect)frame couponInfo:(NSDictionary *)couponInfo delegate:(id<CouponViewDelegate>)delegate;

@end
