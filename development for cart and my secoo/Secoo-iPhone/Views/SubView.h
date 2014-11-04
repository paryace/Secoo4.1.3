//
//  SubView.h
//  Secoo
//
//  Created by WuYikai on 14-8-22.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubViewDelegate <NSObject>
- (void)hasSelectWithFilterDict:(NSDictionary *)filterDict;
@end

@interface SubView : UIView

@property (nonatomic, weak) id<SubViewDelegate> delegate;

@property (nonatomic, strong) UITableView     *leftTableView;
@property (nonatomic, strong) UITableView     *rightTableView;

@property (nonatomic, strong) NSArray         *dataArray;

@property(nonatomic, strong) NSMutableDictionary *filterDict;
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SubViewDelegate>)delegate dataSource:(NSArray *)dataArray;
@end

