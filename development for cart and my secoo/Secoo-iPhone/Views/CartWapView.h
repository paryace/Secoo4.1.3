//
//  CartWapView.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-1.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartWapViewDelegate <NSObject>

- (void)didFinishSelectProductWithImageURL:(NSString *)imageURL productID:(NSString *)productID;
- (void)collectTheProduct;

@end

@interface CartWapView : UIView

@property(nonatomic, weak) id<CartWapViewDelegate> delegate;

- (instancetype)initWithSizeArray:(NSArray *)sizeArray colorArray:(NSArray *)colorArray andDelegate:(id<CartWapViewDelegate>)delegate;
- (void)showInView;

@end
