//
//  OrderTypeAccessor.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/23/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "OrderTypeAccessor.h"
#import "OrderPayType.h"

@interface OrderTypeAccessor ()

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation OrderTypeAccessor

+ (OrderTypeAccessor *)sharedInstance
{
    static OrderTypeAccessor *accessor;
    if (accessor == nil) {
        accessor = [[OrderTypeAccessor alloc] init];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        accessor.managedObjectContext = delegate.managedObjectContext;
    }
    return accessor;
}

- (void)savePayType:(NSString *)payType forOrderId:(NSInteger )orderId
{
    OrderPayType *item = [NSEntityDescription insertNewObjectForEntityForName:@"OrderPayType" inManagedObjectContext:self.managedObjectContext];
    item.orderId = orderId;
    item.mobilePayType = payType;
    if (![self.managedObjectContext save:nil]) {
        NSLog(@"save paytype error");
    }
}

- (NSString *)getPayTypeForOrderId:(NSInteger )orderId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderPayType"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderId==%d", orderId];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([array count] > 0) {
            OrderPayType *orderType = [array objectAtIndex:0];
            return orderType.mobilePayType;
        }
    }
    return nil;
}

- (void)deletePayTypeForOrderId:(NSInteger)orderId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OrderPayType"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderId==%d", orderId];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        for (OrderPayType *orderType  in array) {
            [self.managedObjectContext deleteObject:orderType];
        }
        if (![self.managedObjectContext save:nil]) {
            NSLog(@"save error");
        }
    }
    else{
        NSLog(@"get order paytype error");
    }
}

@end
