//
//  CategoryDetailTableViewCell.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CategoryDetailTableViewCell.h"

@interface CategoryDetailTableViewCell ()
{
    BOOL _showBig;
}

@end

@implementation CategoryDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
   // self.customImageView.image = nil;
}

@end
