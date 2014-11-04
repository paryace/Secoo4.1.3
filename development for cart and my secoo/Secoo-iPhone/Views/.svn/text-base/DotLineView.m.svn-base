//
//  DotLineView.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/26/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "DotLineView.h"
#import <QuartzCore/QuartzCore.h>

@interface DotLineView ()

@property(nonatomic, strong) UIBezierPath *path;
@end

@implementation DotLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDotPath];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDotPath
{
    _path = [UIBezierPath bezierPath];
    [_path setLineWidth:_lineWidth];
    _path.lineCapStyle = kCGLineCapRound;
    _lineWidth = 1;
    _segmentLength = 5;
    _gapWidth = 2;
    _strokColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGContextSetStrokeColorWithColor(context, [_strokColor CGColor]);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextBeginPath(context);
    
    // get frame size
    CGFloat y = (self.frame.size.height) / 2.0;
    CGFloat startingPoint = 0;
    CGFloat totalWidth = self.frame.size.width;
    while (startingPoint < totalWidth) {
        CGContextMoveToPoint(context, startingPoint, y);
        if (startingPoint + _segmentLength < totalWidth) {
            CGContextAddLineToPoint(context, startingPoint + _segmentLength, y);
        }
        else{
            CGContextAddLineToPoint(context, totalWidth, y);
        }
        CGContextDrawPath(context, kCGPathStroke);
        startingPoint += (_gapWidth + _segmentLength);
    }
}

@end
