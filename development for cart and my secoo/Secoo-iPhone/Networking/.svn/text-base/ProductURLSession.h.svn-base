//
//  ProductURLSession.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/25/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "LGURLSession.h"

@protocol ProductInfoDelegate <NSObject>

@optional
- (void)getProductInfo:(NSDictionary *)productInfo;

@end

@interface ProductURLSession : LGURLSession

@property(weak, nonatomic) id<ProductInfoDelegate> delegate;
@end
