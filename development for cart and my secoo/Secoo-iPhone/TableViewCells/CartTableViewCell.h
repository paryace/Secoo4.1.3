//
//  CartTableViewCell.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/23/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIView *backView;
@property(nonatomic, weak) IBOutlet UIImageView *image;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *priceLabel;
@property(nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property(nonatomic, weak) IBOutlet UILabel *colorLabel;
@property(nonatomic, weak) IBOutlet UILabel *sizeLabel;
@property(nonatomic, weak) IBOutlet UILabel *emptyLabel;//默认隐藏
@property(nonatomic, weak) IBOutlet UIImageView *emptyImageView;//默认隐藏
@end
