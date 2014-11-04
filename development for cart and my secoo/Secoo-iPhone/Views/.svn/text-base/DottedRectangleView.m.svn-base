//
//  DottedRectangleView.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/28/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "DottedRectangleView.h"

@interface DottedRectangleView()

@property(nonatomic, strong) UIBezierPath *path;

@property(nonatomic, assign) CGFloat gapWidth;
@property(nonatomic, assign) CGFloat segmentLength;
@property(nonatomic, strong) UIColor *strokColor;
@property(nonatomic, assign) CGFloat lineWidth;
@property(nonatomic, assign) CGFloat cornorRadius;
@end

@implementation DottedRectangleView

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

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth segmentLength:(float)segmentLength gapWidth:(float)gapWidth cornorRadius:(float)cornorRadius stokColor:(UIColor *)stokColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = lineWidth;
        _segmentLength = segmentLength;
        _gapWidth = gapWidth;
        _cornorRadius = cornorRadius;
        self.strokColor = stokColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDotPath
{
    _lineWidth = 0.5;
    _segmentLength = 1;
    _gapWidth = 3;
    _cornorRadius = 5;
    _strokColor = [UIColor lightGrayColor];
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
    
    int n = 2;//(self.frame.size.width * 2 + self.frame.size.height * 2) / (_segmentLength + _gapWidth);
    CGFloat lengths[n];
    for (int i = 0; i < n; ++i) {
        if (i % 2 == 0) {
            lengths[i] = _segmentLength;
        }
        else{
            lengths[i] = _gapWidth;
        }
    }
    CGContextSetLineDash(context, 0, lengths, n);
    CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake(_lineWidth / 2.0, _lineWidth / 2.0, self.frame.size.width - _lineWidth, self.frame.size.height - _lineWidth), _cornorRadius, _cornorRadius, NULL);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
