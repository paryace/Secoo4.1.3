//
//  SubViewCell.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-8-25.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "SubViewCell.h"

@interface SubViewCell ()
{
    UILabel *_lineLabel;
}
@end

@implementation SubViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.backgroundColor = [UIColor clearColor];
        _lineLabel.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:_lineLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
