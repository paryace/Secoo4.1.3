//
//  AddressView.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-29.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckButton.h"
#import "AddressEntity.h"

@protocol AddressViewDelegate <NSObject>

- (void)didSelectOneAddressWithInfo:(AddressEntity *)info;

@end

@interface AddressView : UIView<CheckButtonDelegate>

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AddressViewDelegate>)delegate addressInfo:(AddressEntity *)addressInfo check:(BOOL)check;

@end
