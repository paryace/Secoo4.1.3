//
//  AddressURLSession.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/16/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "AddressURLSession.h"
#import "AddressDataAccessor.h"
#import "UserInfoManager.h"
#import "AddressEntity.h"

@interface AddressURLSession ()

@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation AddressURLSession

- (void)dealloc
{
    if ([[AddressDataAccessor sharedInstance] respondsToSelector:@selector(updateMainContext:)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:[AddressDataAccessor sharedInstance] name:NSManagedObjectContextDidSaveNotification object:self.managedObjectContext];
    }
}

- (void)addAddress:(NSString *)phoneNumber name:(NSString *)name districtName:(NSString *)districtName detailAddress:(NSString *)detailAddress completion:(void(^)(NSInteger recode, NSString *message))completion
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?vo.remoteStatus=0&urlfilter=shipping/myshipping.jsp&client=iphone&method=secoo.addCosnigneeInfo.post&vo.upkey=%@&vo.consigneeName=%@&vo.provinceCityDistrict=%@&vo.address=%@&vo.mobileNum=%@", upKey, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [districtName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [detailAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], phoneNumber];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setHTTPMethod:@"POST"];
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionWithRequest:request withData:nil completion:^(NSData *data, NSError *error) {
        if (error == nil && data) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                    NSDictionary *dict = [jsonDict objectForKey:@"userShippingDto"];
                    [self saveAddress:dict];
                }
                else if([[jsonDict objectForKey:@"recode"] integerValue] == 1008){
                    
                }
                if (completion) {
                    completion([[jsonDict objectForKey:@"recode"] integerValue], [jsonDict objectForKey:@"errMsg"]);
                }
            }
            else{
                NSLog(@"parsing error when getting addresses response");
            }
        }
        else{
            NSLog(@"add address error");
        }
    }];
}

- (void)deleteAddress:(int64_t)addressId
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=shipping/myshipping.jsp&v=1.0&client=iphone&method=secoo.deleteCosnigneeInfo.post&vo.upkey=%@&vo.id=%lld", upKey, addressId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonResponse];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                    [self.managedObjectContext performBlock:^{
                        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
                        [request setFetchBatchSize:20];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"addressId==%lld", addressId];
                        [request setPredicate:predicate];
                        NSError *error;
                        NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
                        if (error == nil) {
                            for (int i = 0; i < [items count]; ++i) {
                                [self.managedObjectContext deleteObject:[items objectAtIndex:i]];
                            }
                            BOOL saved = [self.managedObjectContext save:&error];
                            if (error || !saved) {
                                NSLog(@"deleting addresses error");
                            }
                        }
                    }];
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAddressError" object:nil userInfo:@{@"errMsg": [jsonDict objectForKey:@"errMsg"]}];
                    });
                }
            }
            else{
                NSLog(@"parsing address deletion error: %@", jsonError.description);
            }
        }
        else{
            NSLog(@"delete address error: %@", error.description);
        }
    }];
}

- (void)upDateAddressForId:(int64_t)addressId name:(NSString *)name province:(NSString *)province address:(NSString *)address mobile:(NSString *)mobileNumber
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=shipping/myshipping.jsp&v=1.0&client=iphone&method=secoo.updateCosnigneeInfo.post&vo.remoteStatus=0&vo.upkey=%@&vo.consigneeName=%@&vo.provinceCityDistrict=%@&vo.address=%@&vo.mobileNum=%@&vo.id=%lld", upKey, name, province, address, mobileNumber, addressId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionWithRequest:request withData:nil completion:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonResponse];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                    [self.managedObjectContext performBlock:^{
                        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
                        [request setFetchBatchSize:20];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"addressId==%lld", addressId];
                        [request setPredicate:predicate];
                        NSError *error;
                        NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
                        if (error == nil && [items count] > 0) {
                            AddressEntity *entity = [items objectAtIndex:0];
                            entity.consigneeName = name;
                            entity.provinceCityDistrict = province;
                            entity.address = address;
                            entity.mobileNum = mobileNumber;
                            BOOL saved = [self.managedObjectContext save:&error];
                            if (error || !saved) {
                                NSLog(@"deleting addresses error");
                            }
                            else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAddressSuccess" object:nil userInfo:nil];
                                });
                            }
                        }
                    }];
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAddressError" object:nil userInfo:@{@"errMsg": [jsonDict objectForKey:@"errMsg"]}];
                    });
                }
            }
            else{
                NSLog(@"parsing address deletion error: %@", jsonError.description);
            }
        }
        else{
            NSLog(@"update address error:%@", error.description);
        }
    }];
}

- (void)setDefaultAddress:(int64_t)addressId
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=shipping/myshipping.jsp&v=1.0&client=iphone&method=secoo.settingDefultAddress.post&vo.upkey=%@&vo.id=%lld", upKey, addressId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonResponse];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                    [self.managedObjectContext performBlock:^{
                        //change the original default address
                        NSError *error;
                        NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
                        [req setFetchBatchSize:20];
                        NSPredicate *pre = [NSPredicate predicateWithFormat:@"defaultAddress == YES"];
                        [req setPredicate:pre];
                        NSArray *defaultAddress = [self.managedObjectContext executeFetchRequest:req error:&error];
                        for (AddressEntity *add in defaultAddress) {
                            add.defaultAddress = NO;
                        }

                        
                        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
                        [request setFetchBatchSize:20];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"addressId==%lld", addressId];
                        [request setPredicate:predicate];
                        NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
                        if (error == nil && [items count] > 0) {
                            AddressEntity *entity = [items objectAtIndex:0];
                            entity.defaultAddress = YES;
                            BOOL saved = [self.managedObjectContext save:nil];
                            if (!saved) {
                                NSLog(@"deleting addresses error");
                            }

                        }
                    }];
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAddressError" object:nil userInfo:@{@"errMsg": [jsonDict objectForKey:@"errMsg"]}];
                    });
                }
            }
            else{
                NSLog(@"parsing address deletion error: %@", jsonError.description);
            }
        }
    }];
}

- (void)upDateAddress
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=shipping/myshipping.jsp&v=1.0&client=iphone&method=secoo.consignee.get&fields=consigneeName,telphone,email,provinceCityDistrict,mobileNum,defaultAddress,address,postcode&vo.upkey=%@", upKey];
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] completion:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                    NSArray *array = [jsonDict objectForKey:@"consigneeInfoList"];
                    [self parseAddressArray:array];
                }
                else if([[jsonDict objectForKey:@"recode"] integerValue] == 1007){
                    
                }
            }
            else{
                NSLog(@"parsing error when getting addresses response");
            }

        }
        else{
            NSLog(@"get addresses error");
        }
    }];
}

- (void)saveAddress:(NSDictionary *)dict
{
    [self.managedObjectContext performBlock:^{
        AddressEntity *address = [NSEntityDescription insertNewObjectForEntityForName:@"AddressEntity" inManagedObjectContext:self.managedObjectContext];
        BOOL isDefault = ([[dict objectForKey:@"defaultAddress"] integerValue] == 1);
        address.defaultAddress = isDefault;
        address.mobileNum = [dict objectForKey:@"mobile"];
        address.provinceCityDistrict = [NSString stringWithFormat:@"%@/%@/%@", [dict objectForKey:@"province"], [dict objectForKey:@"city"], [dict objectForKey:@"area"]];
        address.addressId = [[dict objectForKey:@"id"] longValue];
        NSString *str = [NSString stringWithFormat:@"%@", [dict objectForKey:@"userId"]];
        address.userId = str;
        address.address = [dict objectForKey:@"address"];
        
        id consigneeName = [dict objectForKey:@"receiver"];
        if ([consigneeName isKindOfClass:[NSString class]]) {
            address.consigneeName = consigneeName;
        }
        
        NSError *saveError;
        BOOL saved = [self.managedObjectContext save:&saveError];
        if (saveError || !saved) {
            NSLog(@"saving addresses error");
        }
    }];
}

- (void)parseAddressArray:(NSArray *)addessArray
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AddressEntity"];
    [request setFetchBatchSize:20];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    [request setSortDescriptors:@[sorter]];
    
    [self.managedObjectContext performBlock:^{
        NSError *error;
        NSArray *items = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (error == nil) {
            int index = 0;
            int totalEntries = 0;
            BOOL hasChange = NO;
            for (NSDictionary *dict in addessArray) {
                totalEntries ++;
                if (index < [items count]) {
                    AddressEntity *address = [items objectAtIndex:index];
                    if (address.order != index) {
                        address.order = index;
                        hasChange = YES;
                    }
                    BOOL isDefault = ([[dict objectForKey:@"defaultAddress"] integerValue] == 1);
                    if (address.defaultAddress != isDefault) {
                        address.defaultAddress = isDefault;
                        hasChange = YES;
                    }
                    if (![address.mobileNum isEqualToString:[dict objectForKey:@"mobileNum"]]) {
                        address.mobileNum = [dict objectForKey:@"mobileNum"];
                        hasChange = YES;
                    }
                    if (![address.provinceCityDistrict isEqualToString:[dict objectForKey:@"provinceCityDistrict"]]) {
                        address.provinceCityDistrict = [dict objectForKey:@"provinceCityDistrict"];
                        hasChange = YES;
                    }
                    if (address.addressId != [[dict objectForKey:@"id"] longValue]) {
                        address.addressId = [[dict objectForKey:@"id"] longValue];
                        hasChange = YES;
                    }
                    NSString *userId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"userId"]];
                    if (![address.userId isEqualToString:userId]) {
                        address.userId = userId;
                        hasChange = YES;
                    }
                    if ([[dict objectForKey:@"postcode"] isKindOfClass:[NSString class]]) {
                        if (![address.postcode isEqualToString:[dict objectForKey:@"postcode"]]) {
                            address.postcode = [dict objectForKey:@"postcode"];
                            hasChange = YES;
                        }
                    }
                    if ([[dict objectForKey:@"email"] isKindOfClass:[NSString class]]) {
                        if (![address.email isEqualToString:[dict objectForKey:@"email"]]) {
                            address.email = [dict objectForKey:@"email"];
                            hasChange = YES;
                        }
                    }
                    if ([[dict objectForKey:@"telphone"] isKindOfClass:[NSString class]]) {
                        if (![address.telephone isEqualToString:[dict objectForKey:@"telphone"]]) {
                            address.telephone = [dict objectForKey:@"telphone"];
                            hasChange = YES;
                        }
                    }
                    if (![address.consigneeName isEqualToString:[dict objectForKey:@"consigneeName"]]) {
                        address.consigneeName = [dict objectForKey:@"consigneeName"];
                        hasChange = YES;
                    }
                    if (![address.address isEqualToString:[dict objectForKey:@"address"]]) {
                        address.address = [dict objectForKey:@"address"];
                        hasChange = YES;
                    }
                }
                else{
                    if (!hasChange) {
                        hasChange = YES;
                    }
                    AddressEntity *address = [NSEntityDescription insertNewObjectForEntityForName:@"AddressEntity" inManagedObjectContext:self.managedObjectContext];
                    address.order = index;
                    BOOL isDefault = ([[dict objectForKey:@"defaultAddress"] integerValue] == 1);
                    address.defaultAddress = isDefault;
                    address.mobileNum = [dict objectForKey:@"mobileNum"];
                    address.provinceCityDistrict = [dict objectForKey:@"provinceCityDistrict"];
                    address.addressId = [[dict objectForKey:@"id"] longValue];
                    address.userId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"userId"]];
                    address.address = [dict objectForKey:@"address"];
                    id postcode = [dict objectForKey:@"postcode"];
                    if ([postcode isKindOfClass:[NSString class]]) {
                        address.postcode = postcode;
                    }
                    
                    id email = [dict objectForKey:@"email"];
                    if ([email isKindOfClass:[NSString class]]) {
                        address.email = email;
                    }
                    id telephone = [dict objectForKey:@"telphone"];
                    if ([telephone isKindOfClass:[NSString class]]) {
                        address.postcode = telephone;
                    }
                    id consigneeName = [dict objectForKey:@"consigneeName"];
                    if ([consigneeName isKindOfClass:[NSString class]]) {
                        address.consigneeName = consigneeName;
                    }
                    
                    [self.managedObjectContext insertObject:address];
                }
                index ++;
            }
            
            //if there are more items in coredata, we need to delete some
            for (int i = totalEntries; i < [items count]; ++i) {
                AddressEntity *address = [items objectAtIndex:i];
                [self.managedObjectContext deleteObject:address];
                if (!hasChange) {
                    hasChange = YES;
                }
            }
            
            //if have change, update core data
            if (hasChange) {
                NSError *saveError;
                BOOL saved = [self.managedObjectContext save:&saveError];
                if (saveError || !saved) {
                    NSLog(@"saving addresses error");
                }
            }
        }
        else{
            NSLog(@"fetch all address error");
        }
    }];
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
        if ([[AddressDataAccessor sharedInstance] respondsToSelector:@selector(updateMainContext:)]) {
            [[NSNotificationCenter defaultCenter] addObserver:[AddressDataAccessor sharedInstance] selector:@selector(updateMainContext:) name:NSManagedObjectContextDidSaveNotification object:_managedObjectContext];
        }
    }
    return _managedObjectContext;
}

@end
