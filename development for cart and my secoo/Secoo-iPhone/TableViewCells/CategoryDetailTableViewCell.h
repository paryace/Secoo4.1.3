//
//  CategoryDetailTableViewCell.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface CategoryDetailTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *customImageView;
@property(nonatomic, weak) IBOutlet UILabel *customTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *customPriceLabel;
@property(nonatomic, weak) IBOutlet UILabel *customLevelLabel;
@property(nonatomic, weak) IBOutlet UILabel *backgroungLabel;

@end
