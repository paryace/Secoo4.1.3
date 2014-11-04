//
//  UITabBar+CustomTabBar.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "UITabBar+CustomTabBar.h"

@implementation UITabBar (CustomTabBar)

- (void)customTabBar
{
    for (id obj in [self subviews]) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)obj;
            [imageView removeFromSuperview];
            break;
        }
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    imageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageView];
    [self sendSubviewToBack:imageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    lineView.backgroundColor = MAIN_YELLOW_COLOR;
    [self addSubview:lineView];
    
    [self.layer setMasksToBounds:YES];
}

@end
