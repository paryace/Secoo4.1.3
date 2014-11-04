//
//  OrderTypeAccessor.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/23/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTypeAccessor : NSObject

+ (OrderTypeAccessor *)sharedInstance;

- (void)savePayType:(NSString *)payType forOrderId:(NSInteger )orderId;
- (void)deletePayTypeForOrderId:(NSInteger)orderId;
- (NSString *)getPayTypeForOrderId:(NSInteger )orderId;

@end
