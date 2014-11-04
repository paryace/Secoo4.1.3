//
//  ProductColorAndSizeView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-17.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ProductColorAndSizeView.h"
#import "ImageDownloaderManager.h"

#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define _IMG_HEIGHT_                            50.0
#define _LABEL_WIDTH_                           50.0
#define _LABEL_HEIGHT_                          30.0
#define _SELECT_COLOR_                          MAIN_YELLOW_COLOR.CGColor
#define _DEFAUT_COLOR_                          [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor


@interface ProductColorAndSizeView ()


@end

@implementation ProductColorAndSizeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame colorArray:(NSArray *)colorArray delegate:(id<ProductColorAndSizeViewDelegate>)delegate selectIndex:(int)index
{
    self = [super initWithFrame:frame];
    if (self) {
        if (colorArray) {
            self.delegat = delegate;
            self.colorArray = colorArray;
            int colorNum = colorArray.count;//总个数
            float width = self.frame.size.width;
            int maxNum = floorf(width / (_IMG_HEIGHT_+5));//列数
            int maxLineNum = ceilf((float)colorNum/(float)maxNum);//行数
            //改变view的高度
            frame.size.height = maxLineNum * _IMG_HEIGHT_ + (maxLineNum - 1)*5;
            self.frame = frame;
            
            int flag = 0;
            for (int i = 0; i < maxLineNum; i++) {
                for (int j = 0; j < maxNum; j++) {
                    ++flag;
                    if (flag > colorNum) {
                        break;
                    }
                    NSDictionary *dic = [colorArray objectAtIndex:flag-1];
                    NSString *imageUrlString = [[dic objectForKey:@"imgUrl"] firstObject];
                    if (![imageUrlString hasPrefix:@"http://"]) {
                        imageUrlString = [NSString stringWithFormat:@"http://pic.secoo.com/product/80/80/%@", imageUrlString];
                    }
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_IMG_HEIGHT_+5)*j, (_IMG_HEIGHT_+5)*i, _IMG_HEIGHT_, _IMG_HEIGHT_)];
                    if (index == flag-1) {
                        imageView.layer.borderColor = _SELECT_COLOR_;
                    } else {
                        imageView.layer.borderColor = _DEFAUT_COLOR_;
                    }
                    imageView.layer.borderWidth = 1;
                    imageView.tag = _IMG_TAG_ + flag;
                    imageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                    [imageView addGestureRecognizer:gesture];
                    [[ImageDownloaderManager sharedInstance] addImageDowningTask:imageUrlString cached:NO completion:^(NSString *url, UIImage *image, NSError *error) {
                        if (!error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                imageView.image = image;
                            });
                        }
                    }];
                    
                    [self addSubview:imageView];
                }
            }
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame sizeArray:(NSArray *)sizeArray delegate:(id<ProductColorAndSizeViewDelegate>)delegate selectIndex:(int)index
{
    self = [super initWithFrame:frame];
    if (self) {
        if (sizeArray) {
            self.delegat = delegate;
            self.sizeArray = sizeArray;
            int sizeNum = sizeArray.count;
            float width = self.frame.size.width;
            int maxNum = floorf(width / (_LABEL_WIDTH_+5));//列数
            int maxLineNum = ceilf((float)sizeNum/(float)maxNum);//行数
            //改变view的高度
            frame.size.height = maxLineNum * _LABEL_HEIGHT_ + (maxLineNum - 1)*5;
            self.frame = frame;
            
            int flag = 0;
            for (int i = 0; i < maxLineNum; i++) {
                for (int j = 0; j < maxNum; j++) {
                    ++flag;
                    if (flag > sizeNum) {
                        break;
                    }
                    NSDictionary *dic = [sizeArray objectAtIndex:flag-1];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((_LABEL_WIDTH_+5)*j, (_LABEL_HEIGHT_+5)*i, _LABEL_WIDTH_, _LABEL_HEIGHT_)];
                    label.backgroundColor = [UIColor whiteColor];
                    label.layer.borderWidth = 1;
                    if (index == flag-1) {
                        label.layer.borderColor = _SELECT_COLOR_;
                    } else {
                        label.layer.borderColor = _DEFAUT_COLOR_;
                    }
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:12];
                    label.tag = _LABEL_TAG_ + flag;
                    label.userInteractionEnabled = YES;
                    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                    [label addGestureRecognizer:gesture];
                    label.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"specvalue"]];
                    [self addSubview:label];
                }
            }
        }
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    NSArray *array = [[view superview] subviews];
    for (UIView *subView in array) {
        if (subView.tag == view.tag) {
            //被点击
            
            if ([subView isKindOfClass:[UIImageView class]]) {
                int index = subView.tag - (NSInteger)_IMG_TAG_ - 1;
                NSDictionary *dic = [self.colorArray objectAtIndex:index];
                NSString *imgUrl = [[dic objectForKey:@"imgUrl"] firstObject];
                if (![imgUrl hasPrefix:@"http://"]) {
                    imgUrl = [NSString stringWithFormat:@"http://pic.secoo.com/product/80/80/%@", imgUrl];
                }
                
                if (subView.layer.borderColor == _SELECT_COLOR_) {
                    subView.layer.borderColor = _DEFAUT_COLOR_;
                    
                    if (self.delegat && [self.delegat respondsToSelector:@selector(cancleSelectColor)]) {
                        [self.delegat cancleSelectColor];
                    }
                } else {
                    subView.layer.borderColor = _SELECT_COLOR_;
                    
                    if (self.delegat && [self.delegat respondsToSelector:@selector(upDateSizeViewWithProductId: imageUrl: selectColor:)]) {
                        [self.delegat upDateSizeViewWithProductId:[NSString stringWithFormat:@"%@", [dic objectForKey:@"productid"]] imageUrl:imgUrl selectColor:index];
                    }
                }
            } else if ([subView isKindOfClass:[UILabel class]]) {
                int index = subView.tag - (NSInteger)_LABEL_TAG_ - 1;
                NSDictionary *dic = [self.sizeArray objectAtIndex:index];
                NSString *pid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productid"]];
                
                if (subView.layer.borderColor == _SELECT_COLOR_) {
                    subView.layer.borderColor = _DEFAUT_COLOR_;
                    
                    if (self.delegat && [self.delegat respondsToSelector:@selector(cancleSelectSize)]) {
                        [self.delegat cancleSelectSize];
                    }
                } else {
                    subView.layer.borderColor = _SELECT_COLOR_;
                    
                    if (self.delegat && [self.delegat respondsToSelector:@selector(selectProductSizeWithProductID:selectSize:)]) {
                        [self.delegat selectProductSizeWithProductID:pid selectSize:index];
                    }
                    
                }

            }
        } else {
            subView.layer.borderColor = _DEFAUT_COLOR_;
        }
    }
}

@end
