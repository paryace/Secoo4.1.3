//
//  CategoryDetailURLSession.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "LGURLSession.h"

@protocol DetailProductsDelegate <NSObject>

- (void)getProducts:(NSArray *)products filterList:(NSArray *)filterList maxPage:(int)maxPage currPage:(int)currPage;

@end

@interface CategoryDetailURLSession : LGURLSession

@property(nonatomic, weak) UIViewController<DetailProductsDelegate> *delegate;
@end
