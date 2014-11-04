//
//  LGTableViewCell.h
//  CoreDataWrapper
//
//  Created by Tan Lu on 8/15/14.
//  Copyright (c) 2014 Tan Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SwipeDirectionNone,
    SwipeDirectionLeft,
    SwipeDirectionRight,
    SwipeDirectionBoth,
} SwipeDirection;

@class LGTableViewCell;

@protocol LGTableViewCellDelegate <NSObject>

@optional
- (void)pressCell:(LGTableViewCell *)cell atLeftButtonAtIndex:(NSInteger)index;
- (void)pressCell:(LGTableViewCell *)cell atRightButtonAtIndex:(NSInteger)index;
- (void)pressEditButtonAtCell:(LGTableViewCell *)cell;

@end

@interface LGTableViewCell : UITableViewCell
@property(nonatomic, weak) UIView *middleView;

@property (weak, nonatomic) id<LGTableViewCellDelegate>delegate;
@property(nonatomic, weak) UILabel *nameLabel;
@property(nonatomic, weak) UILabel *phoneLabel;
@property(nonatomic, weak) UILabel *addressLabel;

@end