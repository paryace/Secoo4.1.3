//
//  DeliverInfoView.h
//  QRadioButtonDemo
//
//  Created by WuYikai on 14/10/21.
//  Copyright (c) 2014年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"
@class DeliverInfoView;
@protocol DeliverInfoViewDelegate <NSObject>

- (void)didSelectOneAddressWithInfo:(id)info deliverInfoView:(DeliverInfoView *)deliverInfoView;

@end

@interface DeliverInfoView : UIView<CheckButtonDelegate>
@property(nonatomic, weak) CheckButton *checkButton;

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name phone:(NSString *)phone address:(NSString *)address groupId:(NSString *)groupId info:(id)info delegate:(id<DeliverInfoViewDelegate>)delegate;

@end
