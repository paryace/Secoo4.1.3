//
//  DetailViewController.h
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "BasicViewController.h"
#import <MessageUI/MessageUI.h>
#import "WXApi.h"
#import "LXActivity.h"


@protocol sendMsgToWeChatViewDelegate <NSObject>
- (void)changeScene:(NSInteger)scene;
- (void)sendLinkContent;
@end


@interface DetailViewController : BasicViewController<MFMessageComposeViewControllerDelegate, LXActivityDelegate, UIScrollViewDelegate>

@property(nonatomic, assign) id<sendMsgToWeChatViewDelegate> delegate;

//加载 rightBar
- (void)addRightBarButtonItemWithObject:(DetailViewController *)detailVC;

//网页上的分享
- (void)shareMsg;
@end
