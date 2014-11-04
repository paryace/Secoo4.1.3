//
//  CategoryDataAccessor.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CategoryDataAccessor.h"
#import <CoreData/CoreData.h>
#import "CategoryEntity.h"
#import "CategoryChild.h"

@interface CategoryDataAccessor ()

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation CategoryDataAccessor

- (void)dealloc
{
    if (_observerViewController) {
        [[NSNotificationCenter defaultCenter] removeObserver:_observerViewController name:NSManagedObjectContextDidSaveNotification object:self.managedObjectContext];
    }
    //NSLog(@"dealloc category accessor");
}

- (void)updateCategory:(NSArray *)names icons:(NSArray *)icons ids:(NSArray *)ids imageURL:(NSArray *)urls categoryIds:(NSArray *)categoryIds sortKey:(NSArray *)sortKeys children:(NSArray *)children
{
    if (_observerViewController) {
        [[NSNotificationCenter defaultCenter] addObserver:_observerViewController
                                                 selector:@selector(updateMainContext:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.managedObjectContext];
    }
    int idCount = [ids count];
    int urlCount = [urls count];
    int categoryIdCount = [categoryIds count];
    int sortKeyCount = [sortKeys count];
    int childrenCount = [children count];
    
    int MinCount = [names count] < [icons count]? [names count]: [icons count];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CategoryEntityName];
    [self.managedObjectContext performBlock:^{
        NSError *error;
        NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"error occurred during fetch operation:%@ debug:%@", error.description, error.debugDescription);
        }
        else{
            for (NSManagedObject *object in items) {
                [self.managedObjectContext deleteObject:object];
            }
            
            for (int i = 0; i < MinCount; ++i) {
                CategoryEntity *object = [NSEntityDescription insertNewObjectForEntityForName:CategoryEntityName inManagedObjectContext:self.managedObjectContext];
                [object setValue:[names objectAtIndex:i] forKey:@"name"];
                if (idCount > i) {
                    [object setValue:[ids objectAtIndex:i] forKey:@"id"];
                }
                
                if (urlCount > i) {
                    [object setValue:[urls objectAtIndex:i] forKey:@"imageUrl"];
                }
                if (categoryIdCount > i) {
                    [object setValue:[categoryIds objectAtIndex:i] forKey:@"categoryId"];
                }
                if (sortKeyCount > i) {
                    [object setValue:[sortKeys objectAtIndex:i] forKey:@"sortkey"];
                }

                if (childrenCount > i) {
                    NSArray * arr = [children objectAtIndex:i];
                    NSMutableArray *childrenObjects = [NSMutableArray arrayWithCapacity:[arr count]];
                    for (int i = 0; i < [arr count]; ++i) {
                        CategoryChild *childObject = [NSEntityDescription insertNewObjectForEntityForName:CategoryChildName inManagedObjectContext:self.managedObjectContext];
                        [childObject setValue:[[arr objectAtIndex:i] objectForKey:@"name"] forKey:@"name"];
                        NSNumber *number = [NSNumber numberWithInt:[[[arr objectAtIndex:i] objectForKey:@"id"] integerValue]];
                        [childObject setValue:number forKey:@"id"];
                        [childObject setValue:[[arr objectAtIndex:i] objectForKey:@"categoryId"] forKey:@"categoryId"];
                        [childObject setValue:object forKey:@"father"];
                        [childrenObjects addObject:childObject];
                    }
                    NSSet *childrenSet = [NSSet setWithArray:childrenObjects];
                    [object setValue:childrenSet forKey:@"child"];
                }
                [object setValue:UIImageJPEGRepresentation((UIImage *)[icons objectAtIndex:i], 1.0) forKey:@"icon"];
                [self.managedObjectContext insertObject:object];
            }
            
            [self.managedObjectContext save:&error];
            if (error) {
                 NSLog(@"error occurred during saving operation:%@ debug:%@", error.description, error.debugDescription);
            }
        }
    }];
}

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
    }
    return _managedObjectContext;
}

@end
