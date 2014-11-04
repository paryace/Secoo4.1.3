//
//  CartItemAccessor.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/23/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CartItemAccessor.h"
#import "Cartitem.h"

@interface CartItemAccessor ()

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation CartItemAccessor

+ (CartItemAccessor *)sharedInstance
{
    static CartItemAccessor *accessor;
    if (accessor == nil) {
        accessor = [[CartItemAccessor alloc] init];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        accessor.managedObjectContext = delegate.managedObjectContext;
    }
    return accessor;
}

- (NSArray *)getAllItems
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        return array;
    }
    return nil;
}

- (void)addItemWithID:(NSString *)productID productName:(NSString *)name price:(int)refPrice areaType:(short)areaType level:(NSString *)level color:(NSString *)color size:(NSString *)size upKey:(NSString *)upKey type:(int)type
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productId like %@", productID];
    request.predicate = predicate;
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    CartItem *item;
    if ([array count] > 0 && error == nil) {
        item = [array objectAtIndex:0];
        item.quantity ++;
        item.availableAmount ++;
    }
    else{
        item = [NSEntityDescription insertNewObjectForEntityForName:@"CartItem" inManagedObjectContext:self.managedObjectContext];
        item.quantity = 1;
        item.availableAmount = 1;
    }
    
    item.productId = productID;
    item.productName = name;
    item.refPrice = refPrice;
    item.areaType = areaType;
    item.level = level;
    if (color) {
        item.color = color;
    }
    if (size) {
        item.size = size;
    }
    if (upKey) {
        item.upKey = upKey;
    }
    item.type = type;
    item.addDate = [[NSDate date] timeIntervalSince1970];
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"saving error %@", error.description);
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCartItemNotification object:[CartItemAccessor sharedInstance] userInfo:@{@"areaType": [NSNumber numberWithInt:areaType]}];
}

- (void)updateAvailableNumber:(int16_t)number productId:(NSString *)productId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productId like %@", productId];
    request.predicate = predicate;
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([array count] > 0) {
        CartItem *item = [array objectAtIndex:0];
        item.availableAmount = number;
        NSLog(@"save number :%d", number);
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"saving error %@", error.description);
            return;
        }
    }
}

- (void)deleteObjectsWithAreaType:(int16_t)areaType
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"areaType==%d", areaType];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        for (CartItem *item in array) {
            [self.managedObjectContext deleteObject:item];
        }
        BOOL ok = [self.managedObjectContext save:&error];
        if (ok) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteOnAreaTypeItems" object:self];
        }
    }
}

- (void)deleteObjectWithProductId:(NSString *)productId
{
    if (productId == nil) {
        return;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productId like %@", productId];
    request.predicate = predicate;
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        return;
    }
    else{
        for (CartItem *item in items) {
            [self.managedObjectContext deleteObject:item];
        }
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"saving error %@", error.description);
            return;
        }
    }
}

- (NSInteger)numberOfCartItemsForProductId:(NSString *)productId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productId like %@", productId];
    request.predicate = predicate;
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        return -1;
    }
    else if ([items count] > 0){
        CartItem *item = [items objectAtIndex:0];
        return item.quantity;
    }
    return -1;
}

- (NSInteger)numberOfCartItems
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        return 0;
    }
    else{
        int total = 0;
        for (CartItem *item in items) {
            total += item.availableAmount;
        }
        return total;
    }
    return 0;
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
//    request.resultType = NSCountResultType;
//    NSError *error;
//    NSArray *num = [self.managedObjectContext executeFetchRequest:request error:&error];
//    if (error) {
//        return -1;
//    }
//    return [[num objectAtIndex:0] integerValue];
}

- (BOOL)hasItemWithProductId:(NSString *)productId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CartItem"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productId like %@", productId];
    request.predicate = predicate;
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([array count] > 0) {
            return YES;
        }
    }
    return NO;
}

// This method will be called on a secondary thread. Forward to the main thread for safe handling of UIKit objects.
- (void)updateMainContext:(NSNotification *)saveNotification
{
    if ([NSThread isMainThread]) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCartItemDidChangeNotification object:self];
    }
    else {
        [self performSelectorOnMainThread:@selector(updateMainContext:) withObject:saveNotification waitUntilDone:NO];
    }
}

@end
