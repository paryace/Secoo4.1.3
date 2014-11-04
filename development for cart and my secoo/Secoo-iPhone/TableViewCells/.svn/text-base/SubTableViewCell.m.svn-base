//
//  SubTableViewCell.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "SubTableViewCell.h"

@interface SubTableViewCell ()
{
    SubTableViewState _subTableViewState;
    UILabel *_lineLabel;
}

@end

@implementation SubTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _subTableViewState = -1;
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_indexLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 240, 40)];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_contentLabel];
        
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.bounds.size.height-1, self.bounds.size.width-20, 1)];
        _lineLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        [self.contentView addSubview:_lineLabel];
    }
    return self;
}

- (void)layoutSubviewsWithSubTableViewState:(SubTableViewState)subTableViewState
{
    if (subTableViewState != _subTableViewState) {
        switch (subTableViewState) {
            case SubTableViewStateRank:
                _contentLabel.frame = CGRectMake(15, 10, 270, 40);
                _indexLabel.frame = CGRectZero;
                break;
            case SubTableViewStateBrand:
                _indexLabel.frame = CGRectMake(15, 5, 20, 20);
                _contentLabel.frame = CGRectMake(45, 10, 240, 40);
                break;
            case SubTableViewStateClassificaton:
                _contentLabel.frame = CGRectMake(15, 10, 270, 40);
                _indexLabel.frame = CGRectZero;
                break;
            case SubTableViewStateFilter:
                _contentLabel.frame = CGRectMake(15, 10, 270, 40);
                _indexLabel.frame = CGRectZero;
                break;
            default:
                break;
        }
        _subTableViewState = subTableViewState;
    }
}

@end
