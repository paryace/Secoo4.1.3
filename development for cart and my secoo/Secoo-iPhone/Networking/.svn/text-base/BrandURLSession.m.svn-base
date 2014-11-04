//
//  BrandURLSession.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/3/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "BrandURLSession.h"
#import "HotBrand.h"
#import "AllBrand.h"
#import "BrandDataAccessor.h"

@interface BrandURLSession ()

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation BrandURLSession

- (void)dealloc
{
    if ([[BrandDataAccessor sharedInstance] respondsToSelector:@selector(updateMainContext:)]){
        [[NSNotificationCenter defaultCenter] removeObserver:[BrandDataAccessor sharedInstance] name:NSManagedObjectContextDidSaveNotification object:self.managedObjectContext];
    }
    //NSLog(@"dealloc brandurl session");
}

- (void)parseJsonData:(NSData *)data url:(NSString *)url error:(NSError *)error
{
    if (error) {
        return;
    }
    NSError *jsonError;
    id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    if (jsonError == nil) {
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = [jsonDict valueForKey:@"rp_result"];
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = [jsonDict objectForKey:@"rp_result"];
                if (_isHotSession) {
                    [self updateHotBrands:dict forURL:url];
                }
                else{
                    [self updateAllBrands:dict];
                }
            }
        }
        
    }
    else{
        NSLog(@"brand connection parsing error %@", jsonError.description);
    }
}

- (void)updateHotBrands:(NSDictionary *)dict forURL:(NSString *)url
{
    NSArray *array = [url componentsSeparatedByString:@"page="];
    NSInteger pageNumber;
    if ([array count] > 1) {
        pageNumber = [[array objectAtIndex:1] integerValue];
    }
    else{
        return;
    }
    NSInteger width = [[dict objectForKey:@"width"] integerValue];
    NSInteger height = [[dict objectForKey:@"height"] integerValue];
    NSArray *brands = [dict objectForKey:@"brands"];
    if ([brands count] > 1) {
        [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:[NSNumber numberWithInt:pageNumber] waitUntilDone:NO];
    }
    else{
        //indicates no more pages;
        [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:[NSNumber numberWithInt:-1] waitUntilDone:NO];
        return;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"HotBrand"];
    [request setFetchBatchSize:30];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [request setSortDescriptors:@[sorter]];
    [request setPropertiesToFetch:@[@"order", @"imageUrl", @"width", @"height", @"brandId", @"cname", @"ename"]];
    [request setFetchOffset:(pageNumber - 1) * 30];
    [request setFetchLimit:30];
    
    [self.managedObjectContext performBlock:^{
        NSError *error;
        NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (error == nil) {
            BOOL hasChange = NO;
            for (int i = 0; i < [brands count]; ++i) {
                NSDictionary *brandInfo = [brands objectAtIndex:i];
                if (i < [items count]) {
                    HotBrand *brand = [items objectAtIndex:i];
                    //NSLog(@"%@ - %@", [brandInfo objectForKey:@"cname"], [brand valueForKey:@"cname"]);
                    if (![[brandInfo objectForKey:@"cname"] isEqualToString:[brand valueForKey:@"cname"]]) {
                        [brand setValue:[brandInfo objectForKey:@"cname"] forKey:@"cname"];
                        hasChange = YES;
                    }
                    
                    if (![[brandInfo objectForKey:@"ename"] isEqualToString:[brand valueForKey:@"ename"]]) {
                        [brand setValue:[brandInfo objectForKey:@"ename"] forKey:@"ename"];
                        hasChange = YES;
                    }
                    
                    if (![brand.imageUrl isEqualToString:[brandInfo objectForKey:@"imageUrl"]]) {
                        brand.imageUrl = [brandInfo objectForKey:@"imageUrl"];
                        brand.icon = nil;
                        hasChange = YES;
                    }
                    
                    
                    NSInteger brandID = [[brandInfo objectForKey:@"brandId"] integerValue];
                    if (brandID != brand.brandId) {
                        [brand setBrandId:brandID];
                        hasChange = YES;
                    }
                    //NSLog(@"id:%d -- %d", brandID, brand.brandId);
                    
                    if (brand.order != (i + (pageNumber - 1) * 30)) {
                         //NSLog(@"order:%d -- %d", i + (pageNumber - 1) * 30, brand.order);
                        brand.order = i + (pageNumber - 1) * 30;
                        hasChange = YES;
                    }
                    if (width != brand.width) {
                        brand.width = width;
                        hasChange = YES;
                    }
                    if (height != brand.height) {
                        brand.height = height;
                        hasChange = YES;
                    }
                    
                }
                else{
                    if (!hasChange) {
                        hasChange = YES;
                    }
                    HotBrand *brand = [NSEntityDescription insertNewObjectForEntityForName:@"HotBrand" inManagedObjectContext:self.managedObjectContext];
                    brand.width = width;
                    brand.height = height;
                    brand.imageUrl = [brandInfo objectForKey:@"imageUrl"];
                    brand.order = i + (pageNumber - 1) * 30;
                    brand.brandId = [[brandInfo objectForKey:@"brandId"] integerValue];
                    brand.cname = [brandInfo objectForKey:@"cname"];
                    brand.ename = [brandInfo objectForKey:@"ename"];
                    [self.managedObjectContext insertObject:brand];
                }
            }
            
            //delete surplus item
            for (int i = [brands count]; i < [items count]; ++i) {
                if (!hasChange) {
                    hasChange = YES;
                }
                HotBrand *brand = [items objectAtIndex:i];
                [self.managedObjectContext deleteObject:brand];
            }
            if (hasChange) {
                NSError *saveError;
                BOOL saved = [self.managedObjectContext save:&saveError];
                if (saveError || !saved) {
                    NSLog(@"save hot brand error");
                }
            }
        }
        else{
            NSLog(@"brandsession fetch error");
        }
    }];
}

- (void)updateAllBrands:(NSDictionary *)respondsedict
{
    NSInteger width = [[respondsedict objectForKey:@"width"] integerValue];
    NSInteger height = [[respondsedict objectForKey:@"height"] integerValue];
    NSArray *brands = [respondsedict objectForKey:@"brands"];
    if ([brands count] == 0) {
        return;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AllBrand"];
    [request setFetchBatchSize:30];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [request setSortDescriptors:@[sorter]];
    [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:[NSNumber numberWithInt:-99] waitUntilDone:NO];
    [self.managedObjectContext performBlock:^{
        NSError *error;
        NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (error == nil) {
            int index = 0;
            int totalEntries = 0;
            BOOL hasChange = NO;
            for (NSDictionary *dict in brands) {
                NSArray *subBrands = [dict objectForKey:@"list"];
                NSString *cap = [dict objectForKey:@"cap"];
                for (NSDictionary *subDict in subBrands) {
                    totalEntries ++;
                    if (index < [items count]) {
                        AllBrand *brand = [items objectAtIndex:index];
                        
                        if (brand.order != index) {
                            brand.order = index;
                            hasChange = YES;
                        }
                        if (brand.width != width) {
                            brand.width = width;
                            hasChange = YES;
                        }
                        if (brand.height != height) {
                            brand.height = height;
                            hasChange = YES;
                        }
                        if (![cap isEqualToString:brand.cap]) {
                            brand.cap = cap;
                            hasChange = YES;
                        }
                        
                        if ([[subDict objectForKey:@"brandId"] longValue] != brand.brandId) {
                            hasChange = YES;
                            brand.brandId = [[subDict objectForKey:@"brandId"] longValue];
                        }
                        if (![[subDict objectForKey:@"cname"] isEqualToString:brand.cname]) {
                            hasChange = YES;
                            brand.cname = [subDict objectForKey:@"cname"];
                        }
                        if (![[subDict objectForKey:@"ename"] isEqualToString:brand.ename]) {
                            hasChange = YES;
                            brand.ename = [subDict objectForKey:@"ename"];
                        }
                        if (![[subDict objectForKey:@"color"] isEqualToString: brand.color]) {
                            hasChange = YES;
                            brand.color = [subDict objectForKey:@"color"];
                        }
                    }
                    else{
                        if (!hasChange) {
                            hasChange = YES;
                        }
                        AllBrand *brand = [NSEntityDescription insertNewObjectForEntityForName:@"AllBrand" inManagedObjectContext:self.managedObjectContext];
                        brand.width = width;
                        brand.height = height;
                        brand.order = index;
                        brand.brandId = [[subDict objectForKey:@"brandId"] longValue];
                        brand.cname = [subDict objectForKey:@"cname"];
                        brand.ename = [subDict objectForKey:@"ename"];
                        brand.cap = cap;
                        brand.color = [subDict objectForKey:@"color"];
                        [self.managedObjectContext insertObject:brand];
                    }
                    index ++;
                }
            }
            
            //if there are more items in coredata, we need to delete some
            for (int i = totalEntries; i < [items count]; ++i) {
                AllBrand *brand = [items objectAtIndex:i];
                [self.managedObjectContext deleteObject:brand];
                if (!hasChange) {
                    hasChange = YES;
                }
            }
            
            //if have change, update core data
            if (hasChange) {
                NSError *saveError;
                BOOL saved = [self.managedObjectContext save:&saveError];
                if (saveError || !saved) {
                    NSLog(@"saving all brand error");
                }
            }
        }
        else{
            NSLog(@"fetch all brands error");
        }
    }];
}

- (void)notifyDelegate:(NSNumber *)number
{
    int num = [number integerValue];
    if (num != -99) {
        if (_delegate && [_delegate respondsToSelector:@selector(didFinishedLoadingPage:)]) {
            [_delegate didFinishedLoadingPage:num];
        }
    }
    else{
        if (_delegate && [_delegate respondsToSelector:@selector(didFinishedLoadingAllBrand)]) {
            [_delegate didFinishedLoadingAllBrand];
        }
    }

}

#pragma mark --
#pragma mark --getter and setter--

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
        if ([[BrandDataAccessor sharedInstance] respondsToSelector:@selector(updateMainContext:)]) {
            [[NSNotificationCenter defaultCenter] addObserver:[BrandDataAccessor sharedInstance] selector:@selector(updateMainContext:) name:NSManagedObjectContextDidSaveNotification object:_managedObjectContext];
        }
    }
    return _managedObjectContext;
}

- (void)setIsHotSession:(BOOL)isHotSession
{
    _isHotSession = isHotSession;
}

@end
