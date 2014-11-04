//
//  ServiceInfoView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-22.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ServiceInfoView.h"

#define _IMG_WIDTH_                     17
#define _H_INSERT_                      11

@implementation ServiceInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame returnsOrNot:(BOOL)re cod:(BOOL)cod
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _IMG_WIDTH_, _IMG_WIDTH_)];
        img1.image = _IMAGE_WITH_NAME(@"19_9zheng");
        [self addSubview:img1];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(_IMG_WIDTH_+_H_INSERT_, 0, _IMG_WIDTH_, _IMG_WIDTH_)];
        img2.image = _IMAGE_WITH_NAME(@"19_9mai");
        [self addSubview:img2];

        UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake((_IMG_WIDTH_+_H_INSERT_)*2, 0, _IMG_WIDTH_, _IMG_WIDTH_)];
        img3.image = _IMAGE_WITH_NAME(@"19_9jian");
        [self addSubview:img3];
        
        UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake((_IMG_WIDTH_+_H_INSERT_)*3, 0, _IMG_WIDTH_, _IMG_WIDTH_)];
        img4.image = _IMAGE_WITH_NAME(@"19_9bao");
        [self addSubview:img4];

        if (cod) {
            UIImageView *img5 = [[UIImageView alloc] initWithFrame:CGRectMake((_IMG_WIDTH_+_H_INSERT_)*4, 0, _IMG_WIDTH_, _IMG_WIDTH_)];
            img5.image = _IMAGE_WITH_NAME(@"19_9fu");
            [self addSubview:img5];
        }
        
        if (re) {
            UIImageView *img6 = [[UIImageView alloc] initWithFrame:CGRectMake((_IMG_WIDTH_+_H_INSERT_)*(cod?5.0:4.0), 0, _IMG_WIDTH_, _IMG_WIDTH_)];
            img6.image = _IMAGE_WITH_NAME(@"19_9--7");
            [self addSubview:img6];
        }
        
        int i = (re && cod) ? 6 : ((!re && !cod) ? 4 : 5);
        frame.size.height = _IMG_WIDTH_;
        frame.size.width = _IMG_WIDTH_ * i + _H_INSERT_ * (i - 1);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
