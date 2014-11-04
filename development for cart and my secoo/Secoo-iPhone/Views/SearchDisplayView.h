//
//  SearchDisplayView.h
//  Secoo-iPhone
//
//  Created by Paney on 14-7-24.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SearchDisplayViewDelegate <NSObject>

- (void)hasSelectOneMsg:(NSString *)msg;

@end

@interface SearchDisplayView : UIView<UITableViewDataSource, UITableViewDelegate>
//接收外部的数据源
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, weak) id<SearchDisplayViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SearchDisplayViewDelegate>)viewController;

- (void)handDataSouceWithArray:(NSArray *)array;
@end
