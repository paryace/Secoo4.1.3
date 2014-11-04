//
//  AddressDataAccessor.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/16/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "AddressDataAccessor.h"
#import "AppDelegate.h"
#import "UserInfoManager.h"

@interface AddressDataAccessor ()

@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation AddressDataAccessor

+ (AddressDataAccessor *)sharedInstance
{
    static AddressDataAccessor *accessor;
    if (accessor == nil) {
        accessor = [[AddressDataAccessor alloc] init];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        accessor.managedObjectContext = delegate.managedObjectContext;
    }
    return accessor;
}

- (NSArray *)getAllAddresse
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
    [request setFetchBatchSize:20];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [request setSortDescriptors:@[sorter]];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        return  items;
    }
    else {
        NSLog(@"fetch hot icons error");
        return nil;
    }
}

- (AddressEntity *)getDefaulAddress
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
    [request setFetchBatchSize:20];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"defaultAddress == YES"];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([items count] > 0) {
            return  [items objectAtIndex:0];
        }
        else{
            AddressEntity *address = [self getLastTimeAddress];
            if (address == nil) {
                return [self getOneAddress];
            }
            return address;
        }
    }
    else {
        NSLog(@"fetch hot icons error");
        return nil;
    }
}

- (AddressEntity *)getLastTimeAddress
{
    NSString *addId = [UserInfoManager getLastTimeAddressID];
    if (addId == nil) {
        return nil;
    }
    NSInteger AddID = [addId integerValue];
    AddressEntity *addressEntity = [self getAddress:AddID];
    return addressEntity;
}

- (AddressEntity *)getAddress:(int64_t)addressId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
    [request setFetchBatchSize:20];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"addressId==%lld", addressId];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([items count] > 0) {
            return [items objectAtIndex:0];
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

- (AddressEntity *)getOneAddress
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
    [request setFetchBatchSize:20];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId like %@", [UserInfoManager getUserID]];
    //[request setPredicate:predicate];
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([items count] > 0) {
            return [items objectAtIndex:0];
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

// This method will be called on a secondary thread. Forward to the main thread for safe handling of UIKit objects.
- (void)updateMainContext:(NSNotification *)saveNotification
{
    if ([NSThread isMainThread]) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:AddressDataDidChangeNotification object:self];
    }
    else {
        [self performSelectorOnMainThread:@selector(updateMainContext:) withObject:saveNotification waitUntilDone:NO];
    }
}

@end
