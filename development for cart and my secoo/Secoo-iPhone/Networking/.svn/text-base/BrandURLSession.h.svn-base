//
//  BrandURLSession.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/3/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "LGURLSession.h"

@protocol BrandURLSessionDelegate <NSObject>

@optional
- (void)didFinishedLoadingPage:(NSInteger)pageNumber;
- (void)didFinishedLoadingAllBrand;

@end

@interface BrandURLSession : LGURLSession

@property(nonatomic, weak) id<BrandURLSessionDelegate> delegate;
@property(nonatomic, assign) BOOL isHotSession;
@end
