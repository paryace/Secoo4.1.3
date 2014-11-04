//
//  DotLineView.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/26/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DotLineView : UIView

@property(nonatomic, assign) CGFloat gapWidth;
@property(nonatomic, assign) CGFloat segmentLength;
@property(nonatomic, strong) UIColor *strokColor;
@property(nonatomic, assign) CGFloat lineWidth;
@end
