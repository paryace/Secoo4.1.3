//
//  ActionView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-10-15.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "ActionView.h"



#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define BACKGROUND_VIEW_WIDTH                   200
#define BACKGROUND_VIEW_HEIGHT                  200


@interface ActionView ()
@property(nonatomic, weak) UIView *backgroundView;
@property(nonatomic, weak) id<ActionViewDelegate> delegate;
@end

@implementation ActionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray delegate:(id<ActionViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        if (delegate) {
            self.delegate = delegate;
        }
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-BACKGROUND_VIEW_WIDTH)*0.5, -BACKGROUND_VIEW_HEIGHT, BACKGROUND_VIEW_WIDTH, BACKGROUND_VIEW_HEIGHT)];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        backgroundView.layer.cornerRadius = 3;
        self.backgroundView = backgroundView;
        [self addSubview:backgroundView];
        
        UIView *lastView = nil;
        for (int i = 0; i < [titleArray count]; ++i) {
            if (i > 2) {
                break;
            }
            
            if (i > 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame)+5, backgroundView.frame.size.width-20, 0.5)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [backgroundView addSubview:lineView];
                lastView = lineView;
            }

            NSString *title = [NSString stringWithFormat:@"%@", [titleArray objectAtIndex:i]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 5+(lastView?CGRectGetMaxY(lastView.frame):0), backgroundView.frame.size.width, 44);
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [backgroundView addSubview:button];
            lastView = button;
        }
        
        CGRect frame = self.backgroundView.frame;
        frame.size.height = CGRectGetMaxY(lastView.frame)+5;
        frame.origin.y = 70;
        [UIView animateWithDuration:.3 animations:^{
            [self.backgroundView setFrame:frame];
        } completion:^(BOOL finished) {
        }];
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

- (void)didClickButton:(UIButton *)sender
{
    [self tappedCancel];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickActionButtonWithIndex:)]) {
        [self.delegate didClickActionButtonWithIndex:sender.tag];
    }
}

- (void)tappedCancel
{
    [UIView animateWithDuration:.3f animations:^{
        [self.backgroundView setFrame:CGRectMake((SCREEN_WIDTH-BACKGROUND_VIEW_WIDTH)*0.5, -BACKGROUND_VIEW_HEIGHT, BACKGROUND_VIEW_WIDTH, BACKGROUND_VIEW_HEIGHT)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
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
