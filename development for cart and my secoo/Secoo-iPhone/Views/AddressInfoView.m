//
//  AddressInfoView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-29.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "AddressInfoView.h"

@interface AddressInfoView ()
@property(nonatomic, weak) id<AddressInfoViewDelegate> delegate;
@end

@implementation AddressInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame addressArray:(NSArray *)addressArray delegate:(id<AddressInfoViewDelegate>)delegate express:(BOOL)express
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        UIView *lastView = nil;
        for (int i = 0; i < [addressArray count]; i++) {
            float h = 0;
            if (lastView) {
                h = CGRectGetMaxY(lastView.frame) + 10;
            }
            if (express) {
                AddressEntity *dic = [addressArray objectAtIndex:i];
                NSString *name = dic.consigneeName;
                NSString *phoneNumber = dic.mobileNum;
                NSString *address = [NSString stringWithFormat:@"%@/%@", dic.provinceCityDistrict, dic.address];
                DeliverInfoView *deliverInfoView = [[DeliverInfoView alloc] initWithFrame:CGRectMake(0, h, frame.size.width, 100) name:name phone:phoneNumber address:address groupId:@"AddressCheckButton" info:dic delegate:self];
                [self addSubview:deliverInfoView];
                lastView = deliverInfoView;
            } else {
                NSDictionary *dic = [addressArray objectAtIndex:i];
                NSString *name = [dic objectForKey:@"name"];
                NSString *phoneNumber = [dic objectForKey:@"tel"];
                NSString *address = [NSString stringWithFormat:@"%@", [dic objectForKey:@"address"]];
                DeliverInfoView *deliverInfoView = [[DeliverInfoView alloc] initWithFrame:CGRectMake(0, h, frame.size.width, 100) name:name phone:phoneNumber address:address groupId:@"AddressCheckButton" info:dic delegate:self];
                [self addSubview:deliverInfoView];
                lastView = deliverInfoView;
            }
        }
        
        if (lastView) {
            frame.size.height = CGRectGetMaxY(lastView.frame);
            self.frame = frame;
        } else {
            self.frame = CGRectZero;
        }
    }
    return self;
}

- (void)didSelectOneAddressWithInfo:(id)info
{
    NSLog(@"%s", __FUNCTION__);
    if (self.delegate && [self.delegate respondsToSelector:@selector(getTheAddressInfo:)]) {
        [self.delegate getTheAddressInfo:info];
    }
}

- (void)didSelectOneAddressWithInfo:(id)info deliverInfoView:(DeliverInfoView *)deliverInfoView
{
    NSLog(@"%s", __FUNCTION__);
    if (self.delegate && [self.delegate respondsToSelector:@selector(getTheAddressInfo:)]) {
        [self.delegate getTheAddressInfo:info];
    }
}

@end
