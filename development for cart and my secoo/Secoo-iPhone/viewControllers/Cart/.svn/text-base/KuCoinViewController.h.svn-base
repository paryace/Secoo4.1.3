//
//  KuCoinViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/28/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UsingKuCoinType,
    RefillKuCoinType,
} KuCoinType;

@protocol KuCoinOperationDelegate <NSObject>

@optional
- (void)didUsingKuCoin:(NSInteger)number password:(NSString*)password verificationNumber:(NSString*)verificationNumber;

@end

@interface KuCoinViewController : UIViewController

@property(nonatomic, weak) id<KuCoinOperationDelegate> delegate;
@property(nonatomic, assign) KuCoinType type;

@property(nonatomic, strong) NSArray *cartItems;
@end
