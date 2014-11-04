//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by luTan on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CycleScrollView;

@protocol CycleScrollViewDelegate <NSObject>

- (void)didTapOnCycleScrollView:(CycleScrollView *)view At:(NSInteger)index;

@end

@interface CycleScrollView : UIView

@property (nonatomic, weak) id<CycleScrollViewDelegate>delegate;
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , strong) NSArray *views;

@property (nonatomic , assign) NSInteger currentPageIndex;
/**
 *  初始化
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame;

@end