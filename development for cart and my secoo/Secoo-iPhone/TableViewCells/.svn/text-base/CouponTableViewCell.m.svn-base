//
//  CouponTableViewCell.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/26/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, self.contentView.frame.size.width, self.contentView.frame.size.height-2)];
    backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroungImageView = backgroundImageView;
    [self.contentView addSubview:backgroundImageView];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 50, 53)];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont systemFontOfSize:45];
    valueLabel.textColor = [UIColor whiteColor];
    self.valueLabel = valueLabel;
    [self.contentView addSubview:valueLabel];
    
    UILabel *currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(valueLabel.frame)+5, CGRectGetMinY(valueLabel.frame)+5, 30, 25)];
    currencyLabel.backgroundColor = [UIColor clearColor];
    currencyLabel.font = [UIFont systemFontOfSize:15];
    currencyLabel.textColor = [UIColor whiteColor];
    currencyLabel.text = @"元";
    self.currencyLabel = currencyLabel;
    [self.contentView addSubview:currencyLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(valueLabel.frame)+5, CGRectGetMaxY(currencyLabel.frame)+3, SCREEN_WIDTH, 21)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel = dateLabel;
    [self.contentView addSubview:dateLabel];
    
    UILabel *usageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-174, 20, 164, 19)];
    usageLabel.backgroundColor = [UIColor clearColor];
    usageLabel.font = [UIFont systemFontOfSize:12];
    usageLabel.textAlignment = NSTextAlignmentRight;
    usageLabel.textColor = [UIColor whiteColor];
    self.usageLabel = usageLabel;
    [self.contentView addSubview:usageLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.valueLabel.frame;
    CGSize size = [Utils getSizeOfString:self.valueLabel.text ofFont:[UIFont systemFontOfSize:45] withMaxWidth:200];
    frame.size.width = size.width;
    self.valueLabel.frame = frame;
    
    CGRect frame1 = self.currencyLabel.frame;
    frame1.origin.x = CGRectGetMaxX(self.valueLabel.frame) + 5;
    self.currencyLabel.frame = frame1;
    
    CGRect frame2 = self.dateLabel.frame;
    frame2.origin.x = CGRectGetMaxX(self.valueLabel.frame) + 5;
    self.dateLabel.frame = frame2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
