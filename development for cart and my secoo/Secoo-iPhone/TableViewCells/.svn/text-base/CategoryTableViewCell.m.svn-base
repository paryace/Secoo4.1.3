//
//  CategoryTableViewCell.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.customImageView = [[UIImageView alloc] init];
        self.customTextLabel = [[UILabel alloc] init];
        
        _customImageView.backgroundColor = [UIColor clearColor];
        _customTextLabel.backgroundColor = [UIColor clearColor];
//        _customTextLabel.textColor = MAIN_YELLOW_COLOR;
        
        [self.contentView addSubview:_customImageView];
        [self.contentView addSubview:_customTextLabel];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5)];
        lineLabel.backgroundColor = [UIColor grayColor];
        //[self.contentView addSubview:lineLabel];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat cellHeight = self.frame.size.height;
    CGFloat cellWidth = self.frame.size.width;
    self.customImageView.frame = CGRectMake(10, 10, cellHeight-20, cellHeight-20);
    self.customTextLabel.frame = CGRectMake(50, 15, cellWidth-50-30, cellHeight-30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
