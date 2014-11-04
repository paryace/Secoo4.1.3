//
//  SubTableViewCell.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SubTableViewStateRank,
    SubTableViewStateBrand,
    SubTableViewStateClassificaton,
    SubTableViewStateFilter,
} SubTableViewState;

@interface SubTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel *indexLabel;
@property(nonatomic, strong) UILabel *contentLabel;

//调整label的位置
- (void)layoutSubviewsWithSubTableViewState:(SubTableViewState)subTableViewState;
@end
