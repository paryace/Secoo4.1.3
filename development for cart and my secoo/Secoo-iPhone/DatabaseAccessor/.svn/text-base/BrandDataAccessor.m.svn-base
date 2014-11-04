//
//  BrandDataAccessor.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/3/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "BrandDataAccessor.h"
#import "AppDelegate.h"

@interface BrandDataAccessor ()

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation BrandDataAccessor

+ (instancetype)sharedInstance
{
    static BrandDataAccessor *accessor;
    if (accessor == nil) {
        accessor = [[BrandDataAccessor alloc] init];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        accessor.managedObjectContext = delegate.managedObjectContext;
    }
    return accessor;
}

- (NSArray *)getHotBrandIcons
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"HotBrand"];
    [request setFetchBatchSize:6];
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

- (NSArray *)getAllBrands
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AllBrand"];
    [request setFetchBatchSize:20];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [request setSortDescriptors:@[sorter]];
    
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        return  items;
    }
    else {
        NSLog(@"fetch all brands error");
        return nil;
    }

}

// This method will be called on a secondary thread. Forward to the main thread for safe handling of UIKit objects.
- (void)updateMainContext:(NSNotification *)saveNotification
{
    if ([NSThread isMainThread]) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:BrandDataDidChangedNotification object:self];
    }
    else {
        [self performSelectorOnMainThread:@selector(updateMainContext:) withObject:saveNotification waitUntilDone:NO];
    }
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        BOOL hasChange = [managedObjectContext hasChanges];
        if (hasChange) {
            BOOL saved = [managedObjectContext save:&error];
            if (!saved || error != nil) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error in brand data accessor %@, %@", error.description, [error userInfo]);
            }
        }
    }
}

- (void)reset
{
    //[self saveContext];
    [self.managedObjectContext reset];
}

- (void)releaseManagedOject:(NSManagedObject *)managedObject
{
    [self.managedObjectContext refreshObject:managedObject mergeChanges:NO];
}

@end
