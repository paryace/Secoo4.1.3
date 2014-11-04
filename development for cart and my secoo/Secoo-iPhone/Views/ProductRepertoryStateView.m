//
//  ProductRepertoryStateView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-10-10.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ProductRepertoryStateView.h"
#import "ProductView.h"





#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define BACKGROUND_VIEW_WIDTH                   280
#define BACKGROUND_VIEW_HEIGHT                  280


@interface ProductRepertoryStateView ()

@property(nonatomic, weak) id<ProductRepertoryStateViewDelegate> delegate;
@property(nonatomic, weak) UIView *backgroundView;

@end

@implementation ProductRepertoryStateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title description:(NSString *)descriptionStr actionButtonTitle:(NSString *)buttonTitle productArray:(NSArray *)productArray delegate:(id<ProductRepertoryStateViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
        backgroundView.center = self.center;
        backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = backgroundView;
        [self addSubview:backgroundView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor redColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = title;
        [self.backgroundView addSubview:titleLabel];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), 280, 20)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont systemFontOfSize:14];
        descriptionLabel.text = descriptionStr;
        [self.backgroundView addSubview:descriptionLabel];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(descriptionLabel.frame)+10, 280, 140)];
        [self.backgroundView addSubview:scrollView];
        
    }
    return self;
}

- (void)action:(UIButton *)sender
{
    
}

- (void)tappedCancel
{
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
