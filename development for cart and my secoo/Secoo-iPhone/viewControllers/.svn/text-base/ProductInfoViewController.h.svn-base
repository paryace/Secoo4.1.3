//
//  ProductInfoViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/17/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ProductURLSession.h"
#import "LoginTableViewController.h"

@interface ProductInfoViewController : UIViewController<ProductInfoDelegate, MFMessageComposeViewControllerDelegate, LXActivityDelegate, LoginDelegate>

@property (nonatomic, copy) NSString *productID;

@property(nonatomic, assign) id<sendMsgToWeChatViewDelegate> delegate;

@end



@interface ProductInfoViewController (InteractionWithJS)

//interface for JS to add to favorite
- (void)showLogInViewControllerWithData:(id)data withDelegate:(id)delegate;
@end