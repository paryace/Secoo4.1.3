//
//  HotBrandCollectionViewCell.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/3/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "HotBrandCollectionViewCell.h"

@implementation HotBrandCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat width = (self.bounds.size.width - 8);
        CGFloat height = width / self.bounds.size.width * self.bounds.size.height;
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, (self.bounds.size.height - height) / 2.0, width, height)];
        [self addSubview:image];
        _brandImageView = image;
        image.backgroundColor = [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
