//
//  RegistrationTableViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/15/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegistrationDelegate <NSObject>

@optional
- (void)didRegister;
- (void)cancelRegistration;

@end

@interface RegistrationTableViewController : UITableViewController

@property(nonatomic, weak) id<RegistrationDelegate> delegate;

@end
