//
//  ProductServiceView.m
//  AttributeString
//
//  Created by WuYikai on 14-9-17.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ProductServiceView.h"

@implementation ProductServiceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        float roat = SCREEN_WIDTH / 320.0;
        float w = 60.0;
        float iw = 17.0;
        float leftInsert = 20.0*roat;
        float upInsert = 10.0*roat;
        float middleInsert = (SCREEN_WIDTH - 270.0 - leftInsert*2) / 2.0;
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(leftInsert, upInsert, iw, iw)];
        imageView1.image = [UIImage imageNamed:@"19_9zheng"];
        [self addSubview:imageView1];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame), upInsert, w, iw)];
        label1.backgroundColor = [UIColor clearColor];
        label1.text = @"正品保障";
        label1.font = [UIFont systemFontOfSize:12];
        label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(leftInsert+90+middleInsert, upInsert, iw, iw)];
        imageView2.image = [UIImage imageNamed:@"19_9bao"];
        [self addSubview:imageView2];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView2.frame), upInsert, w, iw)];
        label2.backgroundColor = [UIColor clearColor];
        label2.text = @"维修保养";
        label2.font = [UIFont systemFontOfSize:12];
        label2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label2];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(leftInsert+middleInsert*2.0+180.0, upInsert, iw, iw)];
        imageView3.image = [UIImage imageNamed:@"19_9--7"];
        [self addSubview:imageView3];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView3.frame), upInsert, w, iw)];
        label3.backgroundColor = [UIColor clearColor];
        label3.text = @"七天退换";
        label3.font = [UIFont systemFontOfSize:12];
        label3.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label3];
        
        UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(leftInsert, upInsert+iw+8, iw, iw)];
        imageView4.image = [UIImage imageNamed:@"19_9jian"];
        [self addSubview:imageView4];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView4.frame), upInsert+iw+8, w, iw)];
        label4.backgroundColor = [UIColor clearColor];
        label4.text = @"权威鉴定";
        label4.font = [UIFont systemFontOfSize:12];
        label4.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label4];
        
        UIImageView *imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(leftInsert+90+middleInsert, upInsert+iw+8, iw, iw)];
        imageView5.image = [UIImage imageNamed:@"19_9fu"];
        [self addSubview:imageView5];
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView5.frame), upInsert+iw+8, w, iw)];
        label5.backgroundColor = [UIColor clearColor];
        label5.text = @"货到付款";
        label5.font = [UIFont systemFontOfSize:12];
        label5.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label5];
        
        UIImageView *imageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(leftInsert+middleInsert*2.0+180.0, upInsert+iw+8, iw, iw)];
        imageView6.image = [UIImage imageNamed:@"19_9mai"];
        [self addSubview:imageView6];
        
        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView6.frame), upInsert+iw+8, w, iw)];
        label6.backgroundColor = [UIColor clearColor];
        label6.text = @"支持寄卖";
        label6.font = [UIFont systemFontOfSize:12];
        label6.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label6];
        
        self.frame = CGRectMake(0, frame.origin.y, SCREEN_WIDTH, CGRectGetMaxY(label6.frame)+upInsert);
    }
    return self;
}




@end
