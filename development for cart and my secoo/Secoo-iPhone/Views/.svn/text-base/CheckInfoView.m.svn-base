//
//  CheckInfoView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-30.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "CheckInfoView.h"

@implementation CheckInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame checkButton:(CheckButton *)checkButton decriptionStr:(NSString *)descriptionStr detailStr:(NSString *)detailStr
{
    self = [super initWithFrame:frame];
    if (self) {
        checkButton.frame = CGRectMake(0, 10, 200, 30);
        [self addSubview:checkButton];
        
        UIView *lastView = checkButton;
        
        if (descriptionStr && ![descriptionStr isEqualToString:@""]) {
            UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMinY(checkButton.frame), frame.size.width-100, checkButton.frame.size.height)];
            sub.backgroundColor = [UIColor clearColor];
            sub.textAlignment = NSTextAlignmentRight;
            sub.numberOfLines = 0;
            sub.font = [UIFont systemFontOfSize:13];
            sub.textColor = [UIColor lightGrayColor];
            sub.text = descriptionStr;
            [self addSubview:sub];
        }
        
        if (detailStr && ![detailStr isEqualToString:@""]) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = 10;
            style.firstLineHeadIndent = 10;
            style.lineSpacing = 5;
            
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:detailStr];
            [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
            [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attribute.length)];
            [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attribute.length)];
            
            CGSize size;
            if (_IOS_7_LATER_) {
                size = [attribute.mutableString boundingRectWithSize:CGSizeMake(frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSParagraphStyleAttributeName:style, NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            } else {
                size = [attribute boundingRectWithSize:CGSizeMake(frame.size.width, 40) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(checkButton.frame), frame.size.width-10, size.height)];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.attributedText = attribute;
            [self addSubview:label];
            lastView = label;
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
        [self addSubview:lineView];
        
        self.backgroundColor = [UIColor clearColor];
        frame.size.height = CGRectGetMaxY(lastView.frame);
        self.frame = frame;
    }
    return self;
}
@end
