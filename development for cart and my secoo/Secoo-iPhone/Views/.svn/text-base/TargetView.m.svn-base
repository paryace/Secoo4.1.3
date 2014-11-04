//
//  TargetView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-25.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "TargetView.h"

@interface TargetView ()

@property(nonatomic, assign) SEL action;
@property(nonatomic, weak) id target;

@end

@implementation TargetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float width = frame.size.width;
        float height = frame.size.height;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/3.0, height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.size.width, 0, width/2.0, height)];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_descriptionLabel];
        
        self.targetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _targetButton.frame = CGRectMake(CGRectGetMaxX(_descriptionLabel.frame), 0, width/6.0, height);
        _targetButton.backgroundColor = [UIColor clearColor];
        [self addSubview:_targetButton];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"%s", __FUNCTION__);
    
    float offset = 5;
    
    float width = self.frame.size.width - offset;
    float height = self.frame.size.height;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, width*0.3, height)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.size.width, 0, width*0.6, height)];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
    _descriptionLabel.textAlignment = NSTextAlignmentRight;
    _descriptionLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_descriptionLabel];
    
    self.targetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _targetButton.frame = CGRectMake(CGRectGetMaxX(_descriptionLabel.frame), 0, width*0.1, height);
    _targetButton.backgroundColor = [UIColor clearColor];
    _targetButton.userInteractionEnabled = NO;
    [self addSubview:_targetButton];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-_targetButton.frame.size.width-113, 0, 20, 13)];
    CGPoint center = _iconImageView.center;
    center.y = self.center.y;
    _iconImageView.center = center;
    _iconImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_iconImageView];
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.target action:self.action];
    [self addGestureRecognizer:tapGesture];
}

@end
