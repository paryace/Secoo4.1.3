//
//  ProductRepertoryStateView.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-10-10.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductRepertoryStateViewDelegate <NSObject>



@end

@interface ProductRepertoryStateView : UIView

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)descriptionStr actionButtonTitle:(NSString *)buttonTitle productArray:(NSArray *)productArray delegate:(id<ProductRepertoryStateViewDelegate>)delegate;
@end
