//
//  AddressInfoView.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-29.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressView.h"
#import "DeliverInfoView.h"




@protocol AddressInfoViewDelegate <NSObject>

- (void)getTheAddressInfo:(id)info;

@end

@interface AddressInfoView : UIView<AddressViewDelegate, DeliverInfoViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame addressArray:(NSArray *)addressArray delegate:(id<AddressInfoViewDelegate>)delegate express:(BOOL)express;

@end
