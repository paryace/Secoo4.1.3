//
//  BottomImageView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-8-29.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "BottomImageView.h"

#define _PERWIDTH_        77.5
#define _UP_HEIGHT_       15.25
#define _LEFT_WIDTH_      26
#define _TITLE_X_         10
#define _TITLE_Y_         47.75
#define _TITLE_WIDTH_     57.5
#define _TITLE_HEIGHT_    20
#define _BOTTOM_IMG_WIDTH 25.5

@implementation BottomImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        CGFloat width = frame.size.width/4.0;
//        CGFloat height = frame.size.height;
        
        UIImageView *firIV = [[UIImageView alloc] initWithFrame:CGRectMake(_LEFT_WIDTH_, _UP_HEIGHT_, _BOTTOM_IMG_WIDTH, _BOTTOM_IMG_WIDTH)];
        //firIV.image = [UIImage imageNamed:@"detail_tag_real"];
        firIV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detail_tag_real" ofType:@"png"]];
        [self addSubview:firIV];
        
        UILabel *firLab = [[UILabel alloc] initWithFrame:CGRectMake(_TITLE_X_, _TITLE_Y_, _TITLE_WIDTH_, _TITLE_HEIGHT_)];
        firLab.backgroundColor = [UIColor clearColor];
        firLab.font = [UIFont systemFontOfSize:10];
        firLab.textAlignment = NSTextAlignmentCenter;
        firLab.text = @"正品保证";
        [self addSubview:firLab];
        
        UIImageView *secIV = [[UIImageView alloc] initWithFrame:CGRectMake(_LEFT_WIDTH_+_PERWIDTH_, _UP_HEIGHT_, _BOTTOM_IMG_WIDTH, _BOTTOM_IMG_WIDTH)];
        secIV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detail_tag_seven" ofType:@"png"]];         [self addSubview:secIV];
        
        UILabel *secLab = [[UILabel alloc] initWithFrame:CGRectMake(_TITLE_X_+_PERWIDTH_, _TITLE_Y_, _TITLE_WIDTH_, _TITLE_HEIGHT_)];
        secLab.backgroundColor = [UIColor clearColor];
        secLab.font = [UIFont systemFontOfSize:10];
        secLab.textAlignment = NSTextAlignmentCenter;
        secLab.text = @"七天退换";
        [self addSubview:secLab];
        
        UIImageView *tirIV = [[UIImageView alloc] initWithFrame:CGRectMake(_LEFT_WIDTH_+_PERWIDTH_*2, _UP_HEIGHT_, _BOTTOM_IMG_WIDTH, _BOTTOM_IMG_WIDTH)];
        tirIV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detail_tag_keep" ofType:@"png"]];
        [self addSubview:tirIV];
        
        UILabel *tirLab = [[UILabel alloc] initWithFrame:CGRectMake(_TITLE_X_+_PERWIDTH_*2, _TITLE_Y_, _TITLE_WIDTH_, _TITLE_HEIGHT_)];
        tirLab.backgroundColor = [UIColor clearColor];
        tirLab.font = [UIFont systemFontOfSize:10];
        tirLab.textAlignment = NSTextAlignmentCenter;
        tirLab.text = @"维修保养";
        [self addSubview:tirLab];
        
        UIImageView *fouIV = [[UIImageView alloc] initWithFrame:CGRectMake(_LEFT_WIDTH_+_PERWIDTH_*3, _UP_HEIGHT_, _BOTTOM_IMG_WIDTH, _BOTTOM_IMG_WIDTH)];
        fouIV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detail_tag_determine" ofType:@"png"]];
        [self addSubview:fouIV];
        
        UILabel *fouLab = [[UILabel alloc] initWithFrame:CGRectMake(_TITLE_X_+_PERWIDTH_*3, _TITLE_Y_, _TITLE_WIDTH_, _TITLE_HEIGHT_)];
        fouLab.backgroundColor = [UIColor clearColor];
        fouLab.font = [UIFont systemFontOfSize:10];
        fouLab.textAlignment = NSTextAlignmentCenter;
        fouLab.text = @"权威鉴定";
        [self addSubview:fouLab];
        
        for (int i = 0; i < 3; i++) {
            UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(_PERWIDTH_*(i+1), 0, 0.5, frame.size.height)];
            line1.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
            [self addSubview:line1];
        }
        
    }
    return self;
}

@end
