//
//  AddAddressViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/28/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AddressOperationNone,
    AddressOperationAdd,
    AddressOperationUpdate,
} AddressOperation;

@interface AddAddressViewController : UIViewController

@property(assign, nonatomic) AddressOperation opration;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *province;
@property(strong, nonatomic) NSString *address;
@property(strong, nonatomic) NSString *mobileNumber;
@property(assign, nonatomic)  int64_t addressId;

@end
