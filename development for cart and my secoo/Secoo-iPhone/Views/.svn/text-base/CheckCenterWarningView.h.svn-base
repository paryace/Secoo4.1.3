//
//  CheckCenterWarnView.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckCenterWarningView;

@protocol CheckCenterWarnDelegate <NSObject>

@optional
- (void)didCancel:(CheckCenterWarningView *)view;
- (void)didWantToSubmit:(CheckCenterWarningView *)view;

@end

@interface CheckCenterWarningView : UIView<CheckCenterWarnDelegate>

@property(assign, nonatomic) BOOL allSoldOut;
@property(weak, nonatomic) id<CheckCenterWarnDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andSoleOutProduct:(NSArray *)array allSoldOut:(BOOL)allSoldOut;
@end
