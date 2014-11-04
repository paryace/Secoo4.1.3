//
//  CartItemAccessor.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/23/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartItemAccessor : NSObject

+ (CartItemAccessor *)sharedInstance;
- (NSArray *)getAllItems;

- (void)addItemWithID:(NSString *)productID productName:(NSString *)name price:(int)refPrice areaType:(short)areaType level:(NSString *)level color:(NSString *)color size:(NSString *)size upKey:(NSString *)upKey type:(int)type;

- (NSInteger)numberOfCartItems;
- (NSInteger)numberOfCartItemsForProductId:(NSString *)productId;

- (void)updateAvailableNumber:(int16_t)number productId:(NSString *)productId;
- (void)deleteObjectsWithAreaType:(int16_t)areaType;
- (void)deleteObjectWithProductId:(NSString *)productId;

@end
