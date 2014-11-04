//
//  LGTableViewCell.m
//  CoreDataWrapper
//
//  Created by Tan Lu on 8/15/14.
//  Copyright (c) 2014 Tan Lu. All rights reserved.
//

#import "LGTableViewCell.h"

#define LeftButtonBaseTag           100000
#define RightButtonBaseTag          9999999

typedef enum {
    CellStateLeft,
    CellStateCenter,
    CellStateRight,
} CellState;

@interface LGTableViewCell ()<UIGestureRecognizerDelegate>{
    CGPoint firstPoint;
    CGPoint prePoint;
    CellState state;
    CGFloat leftMenuWidth;
    CGFloat rightMenuWidth;
}

@property(nonatomic, weak) UIView *rightMenuView;
@property(nonatomic, weak) UIView *leftMenuView;
@property (assign, nonatomic) SwipeDirection swipeDirection;

@end

@implementation LGTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = self.frame;
        frame.size.height = 80;
        self.frame = frame;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _swipeDirection = SwipeDirectionLeft;
        [self setupCellView];
        state = CellStateCenter;
        leftMenuWidth = [self calculateLeftWidth];
        rightMenuWidth = [self calculateRightWidth];
    }
    return self;
}

#pragma mark - Overriden methods
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setupCellView
{
    CGRect frame = self.frame;
    UIView *left = [[UIView alloc] initWithFrame:frame];
    if (_swipeDirection == SwipeDirectionBoth || _swipeDirection == SwipeDirectionRight) {
        _leftMenuView = left;
        _leftMenuView.backgroundColor = [UIColor whiteColor];
        _leftMenuView.alpha = 0.0;
        [self addLeftButtons];
        [self.contentView addSubview:left];
    }
    
    if (_swipeDirection == SwipeDirectionLeft || _swipeDirection == SwipeDirectionBoth) {
        UIView *right = [[UIView alloc] initWithFrame:frame];
        _rightMenuView = right;
        _rightMenuView.alpha = 0.0;
        _rightMenuView.backgroundColor = [UIColor whiteColor];
        [self addRightButtons];
        [self.contentView addSubview:right];
    }
    
    UIView *midView = [[UIView alloc] initWithFrame:frame];
    _middleView = midView;
    /////wyk
//    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, midView.frame.size.width-200, 20)];
//    phoneLabel.backgroundColor = [UIColor clearColor];
//    phoneLabel.textAlignment = NSTextAlignmentRight;
//    phoneLabel.font = [UIFont systemFontOfSize:14];
//    phoneLabel.textColor = [UIColor lightGrayColor];
//    self.phoneLabel = phoneLabel;
//    [midView addSubview:phoneLabel];
//    
//    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(phoneLabel.frame), midView.frame.size.width-80, self.frame.size.height-CGRectGetMaxY(phoneLabel.frame))];
//    addressLabel.backgroundColor = [UIColor clearColor];
//    addressLabel.font = [UIFont systemFontOfSize:14];
//    addressLabel.textColor = [UIColor lightGrayColor];
//    addressLabel.numberOfLines = 0;
//    self.addressLabel = addressLabel;
//    [midView addSubview:addressLabel];
    
    //wyk
    _middleView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:midView];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_middleView addGestureRecognizer:tap];
    tap.delegate = self;
    pan.delegate = self;
}

- (void)addLeftButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(pressLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 80, self.frame.size.height);
    button.tag = LeftButtonBaseTag;
    [_leftMenuView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor blueColor];
    [button1 addTarget:self action:@selector(pressLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(80, 0, 80, self.frame.size.height);
    button1.tag = LeftButtonBaseTag + 1;
    [_leftMenuView addSubview:button1];
}

- (void)addRightButtons
{
    /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(pressRightButton:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.frame.size.width - 100, 0, 50, self.frame.size.height);
    button.tag = RightButtonBaseTag;
    [_rightMenuView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor greenColor];
    [button1 addTarget:self action:@selector(pressRightButton:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(self.frame.size.width - 50, 0, 50, self.frame.size.height);
    button1.tag = RightButtonBaseTag + 1;
    button1.titleLabel.text = @"Delete";
    [_rightMenuView addSubview:button1];*/
    
    //wyk
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(self.frame.size.width - 100, 0, 50, self.frame.size.height);
    editButton.backgroundColor = [UIColor clearColor];
    [editButton setImage:_IMAGE_WITH_NAME(@"editAddress") forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(handleAddressInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = RightButtonBaseTag;
    [_rightMenuView addSubview:editButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.frame.size.width - 50, 0, 50, self.frame.size.height);
    button.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [button setImage:_IMAGE_WITH_NAME(@"delete") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressRightButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = RightButtonBaseTag + 1;
    [_rightMenuView addSubview:button];
    
    //wyk
}


- (CGFloat)calculateLeftWidth
{
    return 160;
}

- (CGFloat)calculateRightWidth
{
    return 100;//wyk
}

- (void)pressLeftButton:(UIButton *)sender
{
    NSInteger tag = sender.tag - LeftButtonBaseTag;
    if ([_delegate respondsToSelector:@selector(pressCell:atLeftButtonAtIndex:)]) {
        [_delegate pressCell:self atLeftButtonAtIndex:tag];
    }
}

- (void)pressRightButton:(UIButton *)sender
{
    NSInteger tag = sender.tag - RightButtonBaseTag;
    if ([_delegate respondsToSelector:@selector(pressCell:atRightButtonAtIndex:)]) {
        [_delegate pressCell:self atRightButtonAtIndex:tag];
    }
}

- (void)restoreCellState
{
    CGPoint p = _middleView.center;
    _middleView.center = CGPointMake(self.frame.size.width / 2.0, p.y);
    state = CellStateCenter;
    _rightMenuView.alpha = 0.0;
    _leftMenuView.alpha = 0.0;
}

#pragma mark   ------------gesture recognizer handling -------------------
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    if (self.selected == YES) {
        return;
    }
    if (pan.state == UIGestureRecognizerStateBegan) {
        firstPoint = [pan locationInView:self];
        prePoint = firstPoint;
    }
    else if (pan.state == UIGestureRecognizerStateChanged){
        CGPoint p = [pan locationInView:self];
        CGFloat diff = p.x - firstPoint.x;
        CGRect frame = _middleView.frame;
        if (state == CellStateCenter) {
            if (diff > 0) {
                _rightMenuView.alpha = 0.0;
                _leftMenuView.alpha = 1.0;
            }
            else{
                _rightMenuView.alpha = 1.0;
                _leftMenuView.alpha = 0.0;
            }
            
            CGFloat originalX = 0;
            if (diff > leftMenuWidth ) {
                state = CellStateLeft;
                originalX = leftMenuWidth;
            }
            else if(diff < -rightMenuWidth){
                originalX = -rightMenuWidth;
                state = CellStateRight;
            }
            else{
                diff = p.x - prePoint.x;
                originalX = frame.origin.x + diff;
            }
            NSLog(@"%f", originalX);
            if (_swipeDirection == SwipeDirectionBoth) {
                [UIView animateWithDuration:0.1 animations:^{
                    _middleView.frame = CGRectMake(originalX, frame.origin.y, frame.size.width, frame.size.height);
                }];
            }
            else if (_swipeDirection == SwipeDirectionLeft && originalX <= 0){
                [UIView animateWithDuration:0.1 animations:^{
                    _middleView.frame = CGRectMake(originalX, frame.origin.y, frame.size.width, frame.size.height);
                }];
            }
            else if (_swipeDirection == SwipeDirectionRight && originalX >= 0){
                [UIView animateWithDuration:0.1 animations:^{
                    _middleView.frame = CGRectMake(originalX, frame.origin.y, frame.size.width, frame.size.height);
                }];
            }
        }
        else if (state == CellStateLeft) {
            if (diff < 0) {
                diff = p.x - prePoint.x;
                CGFloat originalX = frame.origin.x + diff;
                if (originalX >= 0) {
                    [UIView animateWithDuration:0.1 animations:^{
                        _middleView.frame = CGRectMake(originalX, frame.origin.y, frame.size.width, frame.size.height);
                    }];
                }
                else{
                    [UIView animateWithDuration:0.1 animations:^{
                        _middleView.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
                    }];
                    state = CellStateCenter;
                }
            }
        }
        else if (state == CellStateRight){
            if (diff > 0) {
                diff = p.x - prePoint.x;
                CGFloat originalX = frame.origin.x + diff;
                if (originalX <= 0) {
                    [UIView animateWithDuration:0.1 animations:^{
                        _middleView.frame = CGRectMake(originalX, frame.origin.y, frame.size.width, frame.size.height);
                    }];
                }
                else{
                    [UIView animateWithDuration:0.1 animations:^{
                        _middleView.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
                    }];
                    state = CellStateCenter;
                }
            }
        }
        
        prePoint = p;
    }
    else if (pan.state == UIGestureRecognizerStateEnded){
        CGPoint p = [pan locationInView:self];
        CGRect frame = _middleView.frame;
        CGFloat diff = p.x - firstPoint.x;
        if (state == CellStateCenter) {
            if (diff > 0) {
                _rightMenuView.alpha = 0.0;
                _leftMenuView.alpha = 1.0;
            }
            else{
                _rightMenuView.alpha = 1.0;
                _leftMenuView.alpha = 0.0;
            }
            if (diff > 0) {
                if (_swipeDirection == SwipeDirectionRight || _swipeDirection == SwipeDirectionBoth) {
                    if (diff > leftMenuWidth / 2.0) {
                        [UIView animateWithDuration:0.2 animations:^{
                            _middleView.frame = CGRectMake(leftMenuWidth, frame.origin.y, frame.size.width, frame.size.height);
                        }];
                        state = CellStateLeft;
                    }
                    else{
                        [UIView animateWithDuration:0.2 animations:^{
                            _middleView.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
                        }];
                    }
                }
            }
            else{
                if (_swipeDirection == SwipeDirectionBoth || _swipeDirection == SwipeDirectionLeft) {
                    if (diff < -rightMenuWidth / 2.0) {
                        [UIView animateWithDuration:0.2 animations:^{
                            _middleView.frame = CGRectMake(-rightMenuWidth, frame.origin.y, frame.size.width, frame.size.height);
                        }];
                        state = CellStateRight;
                    }
                    else{
                        [UIView animateWithDuration:0.2 animations:^{
                            _middleView.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
                        }];
                    }
                }
            }
        }
        else if (state == CellStateLeft){
            if (diff < 0) {
                if (diff < -leftMenuWidth / 4.0) {
                    [UIView animateWithDuration:0.2 animations:^{
                        _middleView.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
                    }];
                    state = CellStateCenter;
                }
                else{
                    [UIView animateWithDuration:0.2 animations:^{
                        _middleView.frame = CGRectMake(leftMenuWidth, frame.origin.y, frame.size.width, frame.size.height);
                    }];
                }
            }
        }
        else if (state == CellStateRight){
            if (diff > 0) {
                if (diff > rightMenuWidth / 4.0) {
                    [UIView animateWithDuration:0.2 animations:^{
                        _middleView.frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
                    }];
                    state = CellStateCenter;
                }
                else{
                    [UIView animateWithDuration:0.2 animations:^{
                        _middleView.frame = CGRectMake(-rightMenuWidth, frame.origin.y, frame.size.width, frame.size.height);
                    }];
                }
            }
        }
    }
    else{
        NSLog(@"error");
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if (state != CellStateCenter) {
            [UIView animateWithDuration:0.2 animations:^{
                [self restoreCellState];
            }];
        }
    }
}

#pragma mark * UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        if (state == CellStateCenter) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 点击编辑地址信息
- (void)handleAddressInfoAction:(UIButton *)sender
{
    NSLog(@"%s", __FUNCTION__);
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressEditButtonAtCell:)]) {
        [self.delegate pressEditButtonAtCell:self];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self restoreCellState];
}

- (void)setSwipeDirection:(SwipeDirection)swipeDirection
{
    if (_swipeDirection != swipeDirection) {
        _swipeDirection = swipeDirection;
//        [self.leftMenuView removeFromSuperview];
//        [self.rightMenuView removeFromSuperview];
//        [self.middleView removeFromSuperview];
//        [self setupCellView];
//        state = CellStateCenter;
//        leftMenuWidth = [self calculateLeftWidth];
//        rightMenuWidth = [self calculateRightWidth];
    }
}

@end
