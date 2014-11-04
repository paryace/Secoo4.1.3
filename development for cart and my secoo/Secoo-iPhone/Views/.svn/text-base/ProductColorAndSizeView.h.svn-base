//
//  ProductColorAndSizeView.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-17.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductColorAndSizeViewDelegate <NSObject>
- (void)upDateSizeViewWithProductId:(NSString *)productID imageUrl:(NSString *)imgUrl selectColor:(int)index;
- (void)cancleSelectColor;
- (void)selectProductSizeWithProductID:(NSString *)pid selectSize:(int)index;
- (void)cancleSelectSize;
@end

@interface ProductColorAndSizeView : UIView

@property(nonatomic, strong) NSArray *colorArray;
@property(nonatomic, strong) NSArray *sizeArray;
@property(nonatomic, weak) id<ProductColorAndSizeViewDelegate> delegat;

- (instancetype)initWithFrame:(CGRect)frame sizeArray:(NSArray *)sizeArray delegate:(id<ProductColorAndSizeViewDelegate>)delegate selectIndex:(int)index;
- (instancetype)initWithFrame:(CGRect)frame colorArray:(NSArray *)colorArray delegate:(id<ProductColorAndSizeViewDelegate>)delegate selectIndex:(int)index;

@end
