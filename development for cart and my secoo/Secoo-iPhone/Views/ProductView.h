//
//  ProductView.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-25.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductView : UIView

@property(nonatomic, weak) UIImageView *imageView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *priceLabel;
@property(nonatomic, weak) UILabel *numberLabel;
@property(nonatomic, weak) UILabel *colorLabel;
@property(nonatomic, weak) UILabel *sizeLabel;
@property(nonatomic, weak) UILabel *emptyLabel;//默认隐藏

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)imgURL title:(NSString *)title price:(float)price number:(int)number color:(NSString *)color size:(NSString *)size empty:(int)empty areaType:(int)areaType;
@end
