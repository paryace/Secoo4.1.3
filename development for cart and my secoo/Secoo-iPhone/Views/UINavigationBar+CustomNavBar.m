//
//  UINavigationBar+CustomNavBar.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "UINavigationBar+CustomNavBar.h"

@implementation UINavigationBar (CustomNavBar)

- (void)customNavBar
{
    for (id obj in [self subviews]) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)obj;
            imageView.hidden = YES;
            break;
        }
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 64)];
    imageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageView];
    [self sendSubviewToBack:imageView];

    
    //金线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5f)];
    lineView.backgroundColor = MAIN_YELLOW_COLOR;
    lineView.tag = LINE_VIEW_TAG;
    [self addSubview:lineView];
    [self bringSubviewToFront:lineView];
    
    if (_IOS_7_LATER_) {
        self.tintColor = MAIN_YELLOW_COLOR;
    }

}

@end

