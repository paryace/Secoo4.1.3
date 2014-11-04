//
//  DottedRectangleView.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/28/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DottedRectangleView : UIView
- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth segmentLength:(float)segmentLength gapWidth:(float)gapWidth cornorRadius:(float)cornorRadius stokColor:(UIColor *)stokColor;
@end
