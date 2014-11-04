//
//  ActionView.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-10-15.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionViewDelegate <NSObject>

- (void)didClickActionButtonWithIndex:(int)index;

@end

@interface ActionView : UIView
- (instancetype)initWithTitleArray:(NSArray *)titleArray delegate:(id<ActionViewDelegate>)delegate;
- (void)show;
@end
