//
//  AddressURLSession.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/16/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "LGURLSession.h"

@interface AddressURLSession : NSObject

- (void)upDateAddress;
- (void)addAddress:(NSString *)phoneNumber name:(NSString *)name districtName:(NSString *)districtName detailAddress:(NSString *)detailAddress completion:(void(^)(NSInteger recode, NSString *message))completion;
- (void)deleteAddress:(int64_t)addressId;
- (void)upDateAddressForId:(int64_t)addressId name:(NSString *)name province:(NSString *)province address:(NSString *)address mobile:(NSString *)mobileNumber;
- (void)setDefaultAddress:(int64_t)addressId;

@end
