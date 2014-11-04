//
//  UITabBarController+SelectAnimating.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-7.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "UITabBarController+SelectAnimating.h"

@implementation UITabBarController (SelectAnimating)


//选中tabBar的动画
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated fromIndex:(NSUInteger)fromIndex
{
    CATransition *animation =[CATransition animation];
    [animation setDuration:0.3f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromRight];
    [self.view.layer addAnimation:animation forKey:@"pushView"];
    
    [self setSelectedIndex:selectedIndex];
}

//返回到主界面的动画
- (void)popAnimation
{
    [self setSelectedIndex:0];
    CATransition *animation =[CATransition animation];
    [animation setDuration:0.3f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:kCATransitionFromLeft];
    [self.view.layer addAnimation:animation forKey:@"popView"];
}


@end
