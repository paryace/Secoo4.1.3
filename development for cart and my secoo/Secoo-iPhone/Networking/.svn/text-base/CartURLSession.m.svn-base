//
//  CartURLSession.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/25/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CartURLSession.h"
#import "CartItem.h"
#import "CartItemAccessor.h"
#import "LGURLSession.h"
#import "UserInfoManager.h"

@interface CartURLSession ()

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, assign) NSInteger areaType;
@end

@implementation CartURLSession

- (void)dealloc
{
    if ([[CartItemAccessor sharedInstance] respondsToSelector:@selector(updateMainContext:)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:[CartItemAccessor sharedInstance] name:NSManagedObjectContextDidSaveNotification object:self.managedObjectContext];
    }
}

- (void)updateForAvailableProducts:(NSArray *)array
{
    [self update:array forAvailable:YES];
}

- (void)updateCartItems:(NSArray *)array
{
    [self update:array forAvailable:NO];
}

- (void)update:(NSArray *)array forAvailable:(BOOL)forAvailabel
{
    if ([array count] == 0) {
        return;
    }
    //allow products to add many times
    NSString *productInfo;
    for (CartItem *cartItem in array) {
        int number = cartItem.quantity;
        if (forAvailabel) {
            number = cartItem.availableAmount;
        }
        NSString *proInfo = [NSString stringWithFormat:@"{\"productId\":%@,\"quantity\":%d,\"type\":%d,\"areaType\":%hd}",cartItem.productId, number, 0, cartItem.areaType];
        if (productInfo == nil) {
            productInfo = proInfo;
        }
        else{
            productInfo = [NSString stringWithFormat:@"%@,%@", productInfo, proInfo];
        }
        _areaType = cartItem.areaType;
    }
    productInfo = [NSString stringWithFormat:@"[%@]", productInfo];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/cart_cartGet.action?productInfo=%@&areaType=%d", [productInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _areaType];
    
    if ([UserInfoManager getUserUpKey] && [UserInfoManager didSignIn]) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&upkey=%@", [UserInfoManager getUserUpKey]]];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *dict = [jsonResponse objectForKey:@"rp_result"];
                if ([[dict objectForKey:@"recode"] integerValue] == 0) {
                    NSDictionary *cart = [dict objectForKey:@"cart"];
                    if (!forAvailabel) {
                        [self handleCartInfomation:cart];
                    }
                    else{
                        [self handleAvaiableProductInfo:cart];
                    }
                }
                else{
                    NSLog(@"error happened during getting cart");
                }
            }
        }
    }];
}

- (void)handleAvaiableProductInfo:(NSDictionary *)cart
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *totalPrice = [cart objectForKey:@"rmbTotalSecooPrice"];
        if (_areaType != 0) {
            totalPrice = [cart objectForKey:@"rmbTotalSecooPrice"];
        }
        NSNumber *substractAmount = [cart objectForKey:@"subtractAmount"];
        if (substractAmount == nil) {
            substractAmount = [NSNumber numberWithInt:0];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidGetTotalValue object:nil userInfo:@{@"totalNowPrice": totalPrice, @"rateValues":[cart objectForKey:@"rateValues"], @"paymentValues":[cart objectForKey:@"rmbRealCurrentTotalPrice"], @"subtractAmount":substractAmount ,@"areaType":[NSNumber numberWithInt:_areaType], @"carriageFee":[cart objectForKey:@"rmbDeliverFee"]}];
    });

}

- (void)handleCartInfomation:(NSDictionary *)cart
{
    NSArray *cartItems = [cart objectForKey:@"cartItems"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *totalPrice = [cart objectForKey:@"rmbTotalSecooPrice"];
        if (_areaType != 0) {
            totalPrice = [cart objectForKey:@"rmbTotalSecooPrice"];
        }
        BOOL notEnoughProducts = NO, noProducts = NO;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < [cartItems count]; ++i) {
            NSDictionary *netDict = [cartItems objectAtIndex:i];
            if ([[netDict objectForKey:@"inventoryStatus"] integerValue] == 2) {
                noProducts = YES;
            }
            else if ([[netDict objectForKey:@"inventoryStatus"] integerValue] == 1){
                notEnoughProducts = YES;
                if ([[netDict objectForKey:@"inventoryStatus"] integerValue] == 1) {
                    [array addObject:[netDict objectForKey:@"productId"]];
                }
            }
        }
        
        //if have enough products, show user the total money
        if (!notEnoughProducts && !noProducts) {
            NSNumber *substractAmount = [cart objectForKey:@"subtractAmount"];
            if (substractAmount == nil) {
                substractAmount = [NSNumber numberWithInt:0];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidGetTotalValue object:nil userInfo:@{@"totalNowPrice": totalPrice, @"rateValues":[cart objectForKey:@"rateValues"], @"paymentValues":[cart objectForKey:@"rmbRealCurrentTotalPrice"], @"subtractAmount":substractAmount, @"areaType":[NSNumber numberWithInt:_areaType], @"carriageFee":[cart objectForKey:@"rmbDeliverFee"]}];
        }
        else if (noProducts && !notEnoughProducts){
            [[NSNotificationCenter defaultCenter] postNotificationName:kSoldoutProductsNotifcation object:nil userInfo:nil];
        }
        else if (notEnoughProducts){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            int __block finished = 0;
            int total = [array count];
            for (NSNumber *productId in array) {
                long long pId = [productId longLongValue];
                NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/query_soldOut.action?productId=%lld", pId];
                [dict setObject:productId forKey:url];
                
                LGURLSession *session = [[LGURLSession alloc] init];
                [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
                    if (error == nil) {
                        NSError *jsonError;
                        id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                        if (jsonError == nil) {
                            NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                            NSInteger number = [[jsonDict objectForKey:@"size"] integerValue];
                            if (number >= 0) {
                                NSString *proid = [NSString stringWithFormat:@"%lld", [[dict objectForKey:url] longLongValue]];
                                finished ++;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[CartItemAccessor sharedInstance] updateAvailableNumber:number productId:proid];
                                    if ((finished == total) && !noProducts) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:kNeedGetCartInfoAgain object:nil userInfo:nil];
                                    }
                                });
                            }
                        }
                    }
                }];
            }
        }
    });
    
    if ([cart count] > 0) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"areaType==%d", _areaType];
        [request setPredicate:predicate];
        
        [self.managedObjectContext performBlock:^{
            NSError *error;
            NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
            if ([items count] == [cartItems count]) {
                if (error == nil) {
                    BOOL hasChange = NO;
                    for (int i = 0; i < [cartItems count]; ++i) {
                        NSDictionary *netDict = [cartItems objectAtIndex:i];
                        if (i < [items count]) {
                            CartItem *item = [items objectAtIndex:i];
                            if (item.returnValue != [[netDict objectForKey:@"returnRateValue"] intValue]) {
                                hasChange = YES;
                                item.returnValue = [[netDict objectForKey:@"returnRateValue"] intValue];
                            }
                            
                            if (![item.imageUrl isEqualToString:[Utils convertToRealUrl:[netDict objectForKey:@"image"] ofsize:80]]) {
                                hasChange = YES;
                                item.imageUrl = [Utils convertToRealUrl:[netDict objectForKey:@"image"] ofsize:80];
                            }
                            
                            if (![item.productName isEqualToString:[netDict objectForKey:@"name"]]) {
                                item.productName = [netDict objectForKey:@"name"];
                                hasChange = YES;
                            }
                            if (_areaType == 0) {
                                //nowPrice
                                if (item.refPrice != [[netDict objectForKey:@"rmbUserDiscountPrice"] doubleValue]) {
                                    hasChange = YES;
                                    item.refPrice = [[netDict objectForKey:@"rmbUserDiscountPrice"] doubleValue];
                                }
                            }
                            else{
                                if (item.refPrice != [[netDict objectForKey:@"rmbUserDiscountPrice"] doubleValue]) {
                                    hasChange = YES;
                                    item.refPrice = [[netDict objectForKey:@"rmbUserDiscountPrice"] doubleValue];
                                }
                            }
                            
                            if (item.inventoryStatus != [[netDict objectForKey:@"inventoryStatus"] integerValue]) {
                                hasChange = YES;
                                item.inventoryStatus = [[netDict objectForKey:@"inventoryStatus"] integerValue];
                                if (item.inventoryStatus == 2) {
                                    item.availableAmount = 0;
                                }
                                else if (item.inventoryStatus == 0){
                                    item.availableAmount = item.quantity;
                                }
                            }
                        }
                    }
                    
                    if (hasChange) {
                        NSError *error;
                        [self.managedObjectContext save:&error];
                        if (error) {
                            NSLog(@"save cartitem error %@", error.description);
                        }
                    }
                }
                else{
                    NSLog(@"fetch all address error");
                }
            }
        }];
    }
}

#pragma mark --
#pragma mark -- getter and setter --
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _managedObjectContext.undoManager = nil;
        NSPersistentStoreCoordinator *coordinator = MainPersistentStoreCoordinator;
        if (!coordinator) {
            return nil;
        }
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        if ([[CartItemAccessor sharedInstance] respondsToSelector:@selector(updateMainContext:)]) {
            [[NSNotificationCenter defaultCenter] addObserver:[CartItemAccessor sharedInstance] selector:@selector(updateMainContext:) name:NSManagedObjectContextDidSaveNotification object:_managedObjectContext];
        }
    }
    return _managedObjectContext;
}

@end
