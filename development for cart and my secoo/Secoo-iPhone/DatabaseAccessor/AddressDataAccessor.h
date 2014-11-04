//
//  AddressDataAccessor.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/16/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressEntity.h"

@interface AddressDataAccessor : NSObject


+ (AddressDataAccessor *)sharedInstance;

- (NSArray *)getAllAddresse;
- (void)updateMainContext:(NSNotification *)saveNotification;

- (AddressEntity *)getAddress:(int64_t)addressId;
- (AddressEntity *)getDefaulAddress;
@end
