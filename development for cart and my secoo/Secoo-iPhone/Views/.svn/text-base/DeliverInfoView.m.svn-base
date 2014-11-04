//
//  DeliverInfoView.m
//  QRadioButtonDemo
//
//  Created by WuYikai on 14/10/21.
//  Copyright (c) 2014年 ivan. All rights reserved.
//

#import "DeliverInfoView.h"
#import "DottedRectangleView.h"

@interface DeliverInfoView ()

@property(nonatomic, strong) id addressInfo;
@property(nonatomic, weak) id<DeliverInfoViewDelegate> delegate;

@end

@implementation DeliverInfoView

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name phone:(NSString *)phone address:(NSString *)address groupId:(NSString *)groupId info:(id)info delegate:(id<DeliverInfoViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.addressInfo = info;
        self.delegate = delegate;
        
        UIView *lastView = nil;
        if (name && ![name isEqualToString:@""]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-30, 18)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
            label.text = name;
            [self addSubview:label];
            lastView = label;
        }
        
        if (phone && ![phone isEqualToString:@""]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, lastView?(CGRectGetMaxY(lastView.frame)):5, frame.size.width-30, 18)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
            label.text = phone;
            [self addSubview:label];
            lastView = label;
        }
        
        if (address && ![address isEqualToString:@""]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, lastView?CGRectGetMaxY(lastView.frame):5, frame.size.width-30, 18)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
            label.numberOfLines = 0;
            label.text = address;
            [label sizeToFit];
            [self addSubview:label];
            lastView = label;
        }
        
        if (lastView) {
            frame.size.height = CGRectGetMaxY(lastView.frame) + 5;
            self.frame = frame;
        }
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        self.layer.cornerRadius = 3;
        
        CheckButton *button = [[CheckButton alloc] initWithDelegate:self groupId:groupId];
        button.frame = CGRectMake(self.frame.size.width - 25, self.frame.size.height/3.0, 20, 20);
        [button setTitle:nil forState:UIControlStateNormal];
        [button setImage:_IMAGE_WITH_NAME(@"unchecked") forState:UIControlStateNormal];
        [button setImage:_IMAGE_WITH_NAME(@"checked") forState:UIControlStateSelected];
        self.checkButton = button;
        [self addSubview:button];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapDeliverInfoView:)];
        [self addGestureRecognizer:gesture];
        
        DottedRectangleView *dottedRectangleView = [[DottedRectangleView alloc] initWithFrame:self.bounds];
        [self addSubview:dottedRectangleView];
        [self sendSubviewToBack:dottedRectangleView];
    }
    return self;
}

- (void)handleTapDeliverInfoView:(UITapGestureRecognizer *)gesture
{
//    [self.checkButton setChecked:YES];
    self.checkButton.checked = !self.checkButton.checked;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOneAddressWithInfo:deliverInfoView:)]) {
        [self.delegate didSelectOneAddressWithInfo:self.addressInfo deliverInfoView:self];
    }
}

- (void)didSelectedRadioButton:(CheckButton *)radio groupId:(NSString *)groupId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOneAddressWithInfo:deliverInfoView:)]) {
        [self.delegate didSelectOneAddressWithInfo:self.addressInfo deliverInfoView:self];
    }
}

- (void)didSetCheckedOfCheckButton:(CheckButton *)checkButton checked:(BOOL)checked
{
    if (checkButton.checked) {
        self.backgroundColor = [UIColor colorWithRed:241/255.0 green:251/255.0 blue:239/255.0 alpha:1];
    } else {
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    }
}

@end
