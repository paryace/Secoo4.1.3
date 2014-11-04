//
//  CartTableViewCell.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/23/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CartTableViewCell.h"

@implementation CartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        /*
        self.editing = UITableViewCellEditingStyleDelete;
        CGFloat offsetX = 10, offsetY = 5;
        CGSize size = CGSizeMake(self.bounds.size.width, 100);
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, size.width - 2 * offsetX, size.height - 2 * offsetY)];
        backView.tag = 9999;
        backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        backView.layer.borderWidth = 1;
        backView.layer.cornerRadius = 5;
        [self.contentView addSubview:backView];
        
        CGFloat width = CGRectGetHeight(backView.frame) - 10;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, width, width)];
        [backView addSubview:imageView];
        self.image = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMinY(imageView.frame), CGRectGetWidth(backView.frame) - 28 - CGRectGetMaxX(imageView.frame), 60)];
        [backView addSubview:label];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel = label;
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) + 5, CGRectGetWidth(label.frame), 20)];
        [backView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        */
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    self.image.layer.borderColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor;
    self.image.layer.borderWidth = 0.5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    /*if (_priceLabel.text) {
        CGSize size = [Utils getSizeOfString:_priceLabel.text ofFont:_priceLabel.font withMaxWidth:250];
        CGRect frame = self.priceLabel.frame;
        frame.size.width = size.width;
        self.priceLabel.frame = frame;
    }
    if (_colorLabel.text) {
        CGSize size = [Utils getSizeOfString:_colorLabel.text ofFont:_colorLabel.font withMaxWidth:100];
        CGRect frame = _colorLabel.frame;
        frame.size.width = size.width;
        frame.origin.x = CGRectGetMaxX(_priceLabel.frame) + 10;
        _colorLabel.frame = frame;
    }
    if (_sizeLabel.text) {
        CGSize size = [Utils getSizeOfString:_sizeLabel.text ofFont:_sizeLabel.font withMaxWidth:100];
        CGRect frame = _sizeLabel.frame;
        frame.size.width = size.width;
        frame.origin.x = CGRectGetMaxX(_colorLabel.frame) + 10;
        _sizeLabel.frame = frame;
    }*/
    CGRect rect = self.titleLabel.frame;
    rect.size.width = self.contentView.frame.size.width - rect.origin.x - 20;
    self.titleLabel.frame = rect;
    
    rect.size = CGSizeMake(55, 55);
    rect.origin.x = self.contentView.frame.size.width - 65;
    rect.origin.y = -20;
    self.emptyImageView.frame = rect;
    
    NSString *str = self.priceLabel.attributedText.string;
    CGSize size = [Utils getSizeOfString:str ofFont:[UIFont systemFontOfSize:12] withMaxWidth:self.titleLabel.frame.size.width];
    CGRect frame = self.priceLabel.frame;
    frame.size.width = size.width;
    self.priceLabel.frame = frame;

    size = [Utils getSizeOfString:self.quantityLabel.text ofFont:[UIFont systemFontOfSize:12] withMaxWidth:self.titleLabel.frame.size.width];
    frame.origin.x = CGRectGetMaxX(self.priceLabel.frame) + 2;
    frame.size.width = size.width;
    self.quantityLabel.frame = frame;
    
    frame.origin.x = CGRectGetMaxX(self.quantityLabel.frame) + 2;
    if (self.emptyLabel.text && ![self.emptyLabel.text isEqualToString:@""]) {
        frame.size.width = 50;
    } else {
        frame.size.width = 0;
    }
    self.emptyLabel.frame = frame;

    size = [Utils getSizeOfString:self.colorLabel.text ofFont:[UIFont systemFontOfSize:12] withMaxWidth:self.titleLabel.frame.size.width];
    frame.size.width = size.width;
    frame.origin.x = CGRectGetMaxX(self.emptyLabel.frame) + 2;
    self.colorLabel.frame = frame;
    
    size = [Utils getSizeOfString:self.sizeLabel.text ofFont:[UIFont systemFontOfSize:12] withMaxWidth:self.titleLabel.frame.size.width];
    frame.size.width = size.width;
    frame.origin.x = CGRectGetMaxX(self.colorLabel.frame) + 2;
    self.sizeLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --
#pragma mark --setter and getter---
/*
- (UILabel *)colorLabel
{
    if (_colorLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 10, CGRectGetMinY(_priceLabel.frame), 50, CGRectGetHeight(_priceLabel.frame))];
        _colorLabel = label;
        UIView *view = [self.contentView viewWithTag:9999];
        [view addSubview:label];
    }
    [self setNeedsLayout];
    return _colorLabel;
}

- (UILabel *)sizeLabel
{
    if (_sizeLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_colorLabel.frame) + 10, CGRectGetMinY(_colorLabel.frame), 30, CGRectGetHeight(_colorLabel.frame))];
        _sizeLabel = label;
        UIView *view = [self.contentView viewWithTag:9999];
        [view addSubview:label];
    }
    [self setNeedsLayout];
    return _sizeLabel;
}
*/
@end
