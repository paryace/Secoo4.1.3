//
//  ActiveView.m
//  MySecoo
//
//  Created by Paney on 14-6-25.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ActiveView.h"

#define ACTIVE_IMAGEVIEW_FRAME CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height - 68.2)


@implementation ActiveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        NSString *activeImageName = nil;
        CGSize size_screen = [[UIScreen mainScreen] bounds].size;
        CGFloat scale_screen = [UIScreen mainScreen].scale;
        if (size_screen.width*scale_screen == 320.0) {
            activeImageName = @"Default";
        } else if(size_screen.width*scale_screen == 640.0) {
            if (size_screen.height*scale_screen == 960.0) {
                activeImageName = @"Default@2x";
            } else {
                activeImageName = @"Default-568h@2x";
            }
        }
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:self.bounds];
        [background setImage:[UIImage imageNamed:activeImageName]];
        [self addSubview:background];
        
        self.imageView = [[UIImageView alloc] initWithFrame:ACTIVE_IMAGEVIEW_FRAME];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    return self;
}



@end
