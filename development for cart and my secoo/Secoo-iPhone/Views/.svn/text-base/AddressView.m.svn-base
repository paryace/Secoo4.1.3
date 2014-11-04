//
//  AddressView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-29.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "AddressView.h"
#import "UserInfoManager.h"

@interface AddressView ()
@property(nonatomic, weak) id<AddressViewDelegate> delegate;
@property(nonatomic, strong) AddressEntity *addressInfo;
@end

@implementation AddressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AddressViewDelegate>)delegate addressInfo:(AddressEntity *)addressInfo check:(BOOL)check
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        self.addressInfo = addressInfo;
        
        NSString *name = addressInfo.consigneeName;
        NSString *phoneNumber = addressInfo.mobileNum;
        NSString *address = [NSString stringWithFormat:@"%@/%@", addressInfo.provinceCityDistrict, addressInfo.address];
        
        if (check) {
            CheckButton *checkButton = [[CheckButton alloc] initWithDelegate:self groupId:@"AddressCheckButton"];
            checkButton.frame = CGRectMake(5, 10, 50, 50);
            [checkButton setTitle:nil forState:UIControlStateNormal];
            checkButton.backgroundColor = [UIColor clearColor];
            [self addSubview:checkButton];
            
            self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
            self.layer.borderColor = [[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1] CGColor];
            self.layer.borderWidth = 0.5;
            self.layer.cornerRadius = 3;
            
            NSString *shippingID = [UserInfoManager getLastTimeAddressID];
            if ([shippingID isEqualToString:[NSString stringWithFormat:@"%lld", addressInfo.addressId]]) {
                checkButton.checked = YES;
            }
        }

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(check?30:5, 10, 40, 30)];
        nameLabel.textColor = [UIColor lightGrayColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.text = @"姓名:";
        [self addSubview:nameLabel];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(check?30:5, CGRectGetMaxY(nameLabel.frame), 40, 17)];
        addressLabel.textColor = [UIColor lightGrayColor];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.font = [UIFont systemFontOfSize:14];
        addressLabel.text = @"地址:";
        [self addSubview:addressLabel];
        
        
        UILabel *nameInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame), 70, 30)];
        nameInfoLabel.backgroundColor = [UIColor clearColor];
        nameInfoLabel.font = [UIFont systemFontOfSize:14];
        nameInfoLabel.text = name;
        [self addSubview:nameInfoLabel];
        
        UILabel *phoneInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameInfoLabel.frame), CGRectGetMinY(nameLabel.frame), frame.size.width - CGRectGetMaxX(nameInfoLabel.frame), 30)];
        phoneInfoLabel.backgroundColor = [UIColor clearColor];
        phoneInfoLabel.font = [UIFont systemFontOfSize:14];
        phoneInfoLabel.text = phoneNumber;
        [self addSubview:phoneInfoLabel];
        
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:address];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
        
        UILabel *addressInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressLabel.frame), CGRectGetMinY(addressLabel.frame), frame.size.width - CGRectGetMaxX(addressLabel.frame), 30)];
        addressInfoLabel.numberOfLines = 0;
        addressInfoLabel.backgroundColor = [UIColor clearColor];
        addressInfoLabel.attributedText = text;
        [addressInfoLabel sizeToFit];
        [self addSubview:addressInfoLabel];
        
        frame.size.height = CGRectGetMaxY(addressInfoLabel.frame);
        self.frame = frame;
    }
    return self;
}


- (void)didSelectedRadioButton:(CheckButton *)radio groupId:(NSString *)groupId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOneAddressWithInfo:)]) {
        [self.delegate didSelectOneAddressWithInfo:self.addressInfo];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
