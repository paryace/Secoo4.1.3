//
//  CouponView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-28.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "CouponView.h"

@interface CouponView ()

@property(nonatomic, weak) id<CouponViewDelegate> delegate;
@property(nonatomic, strong) NSDictionary *couponInfo;

@property(nonatomic, weak) UILabel *priceLabel;
@property(nonatomic, weak) UILabel *pastDateLabel;

@end

@implementation CouponView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame couponInfo:(NSDictionary *)couponInfo delegate:(id<CouponViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.couponInfo = couponInfo;
        if (delegate) {
            self.delegate = delegate;
        }
        
        int ticketMoney = [[couponInfo objectForKey:@"ticketMoney"] intValue];
        NSString *minOrderAmountStr = [NSString stringWithFormat:@"%@", [couponInfo objectForKey:@"minOrderAmount"]];
        long long useEndDateValue = [[couponInfo objectForKey:@"useEndDate"] longLongValue];
        
        NSDate *useEndDate = [NSDate dateWithTimeIntervalSince1970:useEndDateValue/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *useEndDateStr = [formatter stringFromDate:useEndDate];
        
        float width = frame.size.width / 9.0 * 4.0;
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, width, frame.size.height / 12.0 * 7.0)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor blackColor];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"¥"];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attribute.length)];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", ticketMoney]];
        [text addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:NSMakeRange(0, text.length)];
        [attribute appendAttributedString:text];
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attribute.length)];
        priceLabel.attributedText = attribute;
        CGRect rect = priceLabel.frame;
        rect.size.width = attribute.size.width;
        priceLabel.frame = rect;
        self.priceLabel = priceLabel;
        [self addSubview:priceLabel];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame), 0, frame.size.width-CGRectGetMaxX(priceLabel.frame), CGRectGetHeight(priceLabel.frame))];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.numberOfLines = 0;
        attribute = [[NSMutableAttributedString alloc] initWithString:@"优惠券\n"];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attribute.length)];
        text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"满%@元可用", minOrderAmountStr]];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, text.length)];
        [attribute appendAttributedString:text];
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attribute.length)];
        descriptionLabel.attributedText = attribute;
        [self addSubview:descriptionLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(2, CGRectGetMaxY(priceLabel.frame), frame.size.width - 4, 0.5)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        UILabel *datedLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lineView.frame), frame.size.width - 10, frame.size.height - CGRectGetMaxY(lineView.frame))];
        datedLabel.backgroundColor = [UIColor clearColor];
        datedLabel.font = [UIFont systemFontOfSize:11];
        datedLabel.textColor = [UIColor whiteColor];
        datedLabel.text = [NSString stringWithFormat:@"过期日期: %@", useEndDateStr];
        [self addSubview:datedLabel];
        
//        self.backgroundColor = [self colorWithPrice:ticketMoney];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = _IMAGE_WITH_NAME([self backgroundImageNameWithPrice:ticketMoney]);
        [self addSubview:imageView];
        [self sendSubviewToBack:imageView];
        

        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:gesture];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOneCouponViewWithInfo:)]) {
        [self.delegate didSelectOneCouponViewWithInfo:self.couponInfo];
    }
}

- (UIColor *)colorWithPrice:(int)price
{
    if (price < 100) {
        return [UIColor colorWithRed:73/255.0 green:159/255.0 blue:69/255.0 alpha:1];
    } else if (price < 200) {
        return [UIColor colorWithRed:41/255.0 green:165/255.0 blue:254/255.0 alpha:1];
    } else if (price < 500) {
        return [UIColor colorWithRed:98/255.0 green:110/255.0 blue:240/255.0 alpha:1];
    } else if (price < 1000) {
        return [UIColor colorWithRed:254/255.0 green:193/255.0 blue:38/255.0 alpha:1];
    }
    return [UIColor colorWithRed:253/255.0 green:116/255.0 blue:33/255.0 alpha:1];
}

- (NSString *)backgroundImageNameWithPrice:(int)price
{
    if (price < 100) {
        return @"Coupon--100";
    } else if (price < 300) {
        return @"Coupon--200";
    } else if (price < 500) {
        return @"Coupon--500";
    } else if (price < 1000) {
        return @"Coupon--1000";
    }
    return @"Coupon--2000";
}

@end
