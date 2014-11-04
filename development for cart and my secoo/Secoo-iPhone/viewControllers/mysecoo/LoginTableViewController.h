//
//  LoginTableViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/15/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate <NSObject>

@optional
- (void)didLogin;
- (void)didCancelLogin;

@end

@interface LoginTableViewController : UITableViewController

@property(nonatomic, weak) id<LoginDelegate> delegate;
@end
