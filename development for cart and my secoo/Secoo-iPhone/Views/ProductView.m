//
//  ProductView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-25.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ProductView.h"
#import "DotLineView.h"
#import "ImageDownloaderManager.h"

@implementation ProductView

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)imgURL title:(NSString *)title price:(float)price number:(int)number color:(NSString *)color size:(NSString *)size empty:(int)empty areaType:(int)areaType
{
    self = [super initWithFrame:frame];
    if (self) {
        //TODO frame适配
        
        UIImageView *emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-55, 0, 55, 55)];
        emptyImageView.backgroundColor = [UIColor clearColor];
        emptyImageView.image = _IMAGE_WITH_NAME(@"empty");
        emptyImageView.hidden = YES;
        [self addSubview:emptyImageView];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor;
        [self addSubview:imageView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 10, frame.size.width-68, 35)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        UILabel *priceLabel  = [[UILabel alloc] initWithFrame:CGRectMake(68, 45, 0, 25)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont systemFontOfSize:14];
        priceLabel.textColor = [UIColor blackColor];
        if (price && price > 0) {
            priceLabel.text = [self moneyTypeWithAreaType:areaType price:price];//[NSString stringWithFormat:@"¥ %.2f", price];
        } else {
            priceLabel.text = @"";
        }
        CGSize textSize = [Utils getSizeOfString:priceLabel.text ofFont:[UIFont systemFontOfSize:14] withMaxWidth:titleLabel.frame.size.width];
        CGRect rect = priceLabel.frame;
        rect.size.width = textSize.width;
        priceLabel.frame = rect;
        [self addSubview:priceLabel];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame), 45, 0, 25)];
        numberLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        numberLabel.font = [UIFont systemFontOfSize:14];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.backgroundColor = [UIColor clearColor];
        if (number && number >= 0) {
            numberLabel.text = [NSString stringWithFormat:@"x%d", number];
        } else {
            numberLabel.text = @"";
        }
        textSize = [Utils getSizeOfString:numberLabel.text ofFont:[UIFont systemFontOfSize:14] withMaxWidth:titleLabel.frame.size.width];
        rect.size.width = textSize.width;
        rect.origin.x = CGRectGetMaxX(priceLabel.frame) + 2;
        numberLabel.frame = rect;
        [self addSubview:numberLabel];
        
        UILabel *emptyLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame), 45, 0, 25)];
        emptyLabel.font = [UIFont systemFontOfSize:14];
        emptyLabel.textColor = [UIColor redColor];
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.backgroundColor = [UIColor colorWithRed:251/255.0 green:210/255.0 blue:209/255.0 alpha:1];
        if (2 == empty) {
            //售罄
            emptyImageView.hidden = NO;
            emptyLabel.text = @"";
            rect.size.width = 0;
            rect.origin.x = CGRectGetMaxX(numberLabel.frame);
        } else if (1 == empty) {
            //库存不足
            emptyLabel.text = @"库存不足";
            rect.size.width = 60;
            rect.origin.x = CGRectGetMaxX(numberLabel.frame) + 2;
        } else if (0 == empty) {
            //库存正常
            emptyLabel.text = @"";
            rect.size.width = 0;
            rect.origin.x = CGRectGetMaxX(numberLabel.frame);
        }
        emptyLabel.frame = rect;
        [self addSubview:emptyLabel];
        
        UILabel *colorLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(emptyLabel.frame), 45, 0, 25)];
        colorLabel.font = [UIFont systemFontOfSize:14];
        colorLabel.textColor = [UIColor lightGrayColor];
        colorLabel.textAlignment = NSTextAlignmentCenter;
        colorLabel.backgroundColor = [UIColor clearColor];
        if (color) {
            colorLabel.text = color;
        } else {
            colorLabel.text = @"";
        }
        textSize = [Utils getSizeOfString:colorLabel.text ofFont:[UIFont systemFontOfSize:14] withMaxWidth:titleLabel.frame.size.width];
        rect.size.width = textSize.width;
        rect.origin.x = CGRectGetMaxX(emptyLabel.frame) + 2;
        colorLabel.frame = rect;
        [self addSubview:colorLabel];
        
        UILabel *sizeLabel   = [[UILabel alloc] initWithFrame:CGRectMake(243, 45, 0, 25)];
        sizeLabel.textColor = [UIColor lightGrayColor];
        sizeLabel.font = [UIFont systemFontOfSize:14];
        sizeLabel.textAlignment = NSTextAlignmentCenter;
        sizeLabel.backgroundColor = [UIColor clearColor];
        if (size) {
            sizeLabel.text = size;
        } else {
            sizeLabel.text = @"";
        }
        textSize = [Utils getSizeOfString:sizeLabel.text ofFont:[UIFont systemFontOfSize:14] withMaxWidth:titleLabel.frame.size.width];
        rect.size.width = textSize.width;
        rect.origin.x = CGRectGetMaxX(colorLabel.frame) + 2;
        sizeLabel.frame = rect;
        [self addSubview:sizeLabel];

        self.imageView   = imageView;
        self.titleLabel  = titleLabel;
        self.priceLabel  = priceLabel;
        self.numberLabel = numberLabel;
        self.colorLabel  = colorLabel;
        self.sizeLabel   = sizeLabel;
        self.emptyLabel  = emptyLabel;
        
        frame.size.height = 70;
        self.frame = frame;
        if (imgURL) {
            [[ImageDownloaderManager sharedInstance] addImageDowningTask:imgURL cached:YES completion:^(NSString *url, UIImage *image, NSError *error) {
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = image;
                    });
                }
            }];
        }
    }
    return self;
}

#pragma mark - 返回币种
- (NSString *)moneyTypeWithAreaType:(int)areaType price:(float)price
{
    if (0 == areaType) {
        return [NSString stringWithFormat:@"¥ %.2f", price];
    } else if (1 == areaType) {
        return [NSString stringWithFormat:@"HK$ %.2f 港币", price];
    } else if (2 == areaType) {
        return [NSString stringWithFormat:@"$ %.2f 美元", price];
    } else if (3 == areaType) {
        return [NSString stringWithFormat:@"¥ %.2f 日元", price];
    } else if (4 == areaType) {
        return [NSString stringWithFormat:@"€ %.2f 欧元", price];
    } else if (5 == areaType) {
        return [NSString stringWithFormat:@"ƒ %.2f 法郎", price];
    }
    return [NSString stringWithFormat:@"%.2f", price];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

@end
