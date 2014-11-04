//
//  CartWapView.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-1.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "CartWapView.h"
#import "UIImageView+WebCache.h"


#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define _H_INSERT_HEIGHT_                       20
#define _V_INSERT_HEIGHT_                       15
#define _IMG_HEIGHT_                            40
#define _TEXT_HEIGHT_                           40
#define _TEXT_WIDTH_                            80
#define _BUTTON_HEIGHT_                         20
#define _SURE_BUTTON_HEIGHT                     30
#define _S_LABEL_TAG_                           8000
#define _C_IMG_VIEW_TAG_                        9000

@interface CartWapView ()
{
    BOOL _isNothing;//既没有尺寸 也没有颜色
}

@property (nonatomic, weak  ) UIView    *backgroundView;
@property (nonatomic, weak  ) UILabel   *colorLabel;
@property (nonatomic, weak  ) UILabel   *sizeLabel;

@property (nonatomic, strong) NSArray   *colorArray;
@property (nonatomic, strong) NSArray   *sizeArray;

@property (nonatomic, copy  ) NSString *productID;//对应尺寸的pid
@property (nonatomic, copy  ) NSString  *imgURL;//选择的对应颜色的商品图片

@end

@implementation CartWapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithSizeArray:(NSArray *)sizeArray colorArray:(NSArray *)colorArray andDelegate:(id<CartWapViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        if (colorArray || sizeArray) {
            [self _creatSubViewsWithSizeImageArray:sizeArray colorImageArray:colorArray];
            _isNothing = NO;
        } else {
            _isNothing = YES;
        }
        
        self.colorArray = colorArray;
        self.sizeArray = sizeArray;
    }
    return self;
}

- (void)showInView
{
    if (_isNothing) {
        return;
    }
    [[[[UIApplication sharedApplication] delegate] window].rootViewController.view addSubview:self];
}

- (void)_creatSubViewsWithSizeImageArray:(NSArray *)sizeArray colorImageArray:(NSArray *)colorArray
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [backgroundView addGestureRecognizer:tap];
    self.backgroundView = backgroundView;
    [self addSubview:backgroundView];
    
    
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(10, _V_INSERT_HEIGHT_, 50, _BUTTON_HEIGHT_);
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton setTitleColor:MAIN_YELLOW_COLOR forState:UIControlStateNormal];
    collectButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    [collectButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [collectButton addTarget:self action:@selector(didClickCollectButton) forControlEvents:UIControlEventTouchUpInside];
    [[self backgroundView] addSubview:collectButton];
    
    UIButton *cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cartButton.frame = CGRectMake(210, _V_INSERT_HEIGHT_-2, 100, _BUTTON_HEIGHT_+4);
    [cartButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cartButton.layer.backgroundColor = [[UIColor clearColor] CGColor];
    cartButton.layer.borderWidth = 0.3f;
    cartButton.layer.cornerRadius = 3;
    cartButton.layer.borderColor = [[UIColor blackColor] CGColor];
    [cartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [cartButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cartButton addTarget:self action:@selector(didClickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:cartButton];
    
    if (colorArray) {
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(collectButton.frame)+_V_INSERT_HEIGHT_, _TEXT_WIDTH_, _TEXT_HEIGHT_)];
        colorLabel.backgroundColor = [UIColor clearColor];
        colorLabel.font = [UIFont systemFontOfSize:13];
        colorLabel.text = @"选择颜色:";
        self.colorLabel = colorLabel;
        [self.backgroundView addSubview:colorLabel];
        
        int i = 0;
        for (NSDictionary *colorDic in colorArray) {
            if (i < 4) {//最多四个
                NSString *imgURL = [[colorDic objectForKey:@"imgUrl"] firstObject];
                imgURL = [NSString stringWithFormat:@"http://pic.secoo.com/product/80/80/%@", imgURL];
                UIImageView *colorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colorLabel.frame)+5+(_IMG_HEIGHT_+5)*i++, colorLabel.frame.origin.y, _IMG_HEIGHT_, _IMG_HEIGHT_)];
                if (colorArray.count > 1) {
                    colorImageView.userInteractionEnabled = YES;
                    //实例化一个手势
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureMethod:)];
                    [colorImageView addGestureRecognizer:tapGesture];
                    if (1 == i) {
                        colorImageView.layer.borderColor = [[UIColor redColor] CGColor];
                        colorImageView.layer.borderWidth = 1;
                    }
                } else {
                    colorImageView.layer.borderColor = [UIColor redColor].CGColor;
                    colorImageView.layer.borderWidth = 1;
                    self.imgURL = imgURL;
                }
                colorImageView.tag = _C_IMG_VIEW_TAG_ + i;
                [colorImageView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:nil];
                [self.backgroundView addSubview:colorImageView];
            }
        }
    }
    
    if (sizeArray) {
        UILabel *sizeLabel = [[UILabel alloc] init];
        if (colorArray) {
            sizeLabel.frame = CGRectMake(10, CGRectGetMaxY(self.colorLabel.frame)+_V_INSERT_HEIGHT_, _TEXT_WIDTH_, _TEXT_HEIGHT_);
        } else {
            sizeLabel.frame = CGRectMake(10, CGRectGetMaxY(collectButton.frame)+_V_INSERT_HEIGHT_, _TEXT_WIDTH_, _TEXT_HEIGHT_);
        }
        sizeLabel.backgroundColor = [UIColor clearColor];
        sizeLabel.font = [UIFont systemFontOfSize:13];
        sizeLabel.text = @"选择尺码:";
        self.sizeLabel = sizeLabel;
        [self.backgroundView addSubview:sizeLabel];
        
        int i = 0;
        for (NSDictionary *sizeDic in sizeArray) {
            if (i < 4) {//最多四个
                NSString *size = [sizeDic objectForKey:@"specvalue"];
                UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sizeLabel.frame)+5+(_IMG_HEIGHT_+5)*i++, sizeLabel.frame.origin.y, _IMG_HEIGHT_, _IMG_HEIGHT_)];
                if (sizeArray.count > 1) {
                    sLabel.userInteractionEnabled = YES;
                    //实例化一个手势
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureMethod:)];
                    [sLabel addGestureRecognizer:tapGesture];
                    
                    if (1 == i) {
                        sLabel.layer.borderColor = [[UIColor redColor] CGColor];
                        sLabel.layer.borderWidth = 1;
                    }
                } else {
                    sLabel.layer.borderColor = [[UIColor redColor] CGColor];
                    sLabel.layer.borderWidth = 1;
                    self.productID = [sizeDic objectForKey:@"productid"];
                }
                sLabel.textAlignment = NSTextAlignmentCenter;
                sLabel.text = size;
                sLabel.tag = _S_LABEL_TAG_ + i;
                [self.backgroundView addSubview:sLabel];
            }
        }
    }
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (sizeArray) {
        sureButton.frame = CGRectMake(20, CGRectGetMaxY(self.sizeLabel.frame)+_V_INSERT_HEIGHT_, 280, _SURE_BUTTON_HEIGHT);
    } else if (colorArray) {
        sureButton.frame = CGRectMake(20, CGRectGetMaxY(self.colorLabel.frame)+_V_INSERT_HEIGHT_, 280, _SURE_BUTTON_HEIGHT);
    }
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.layer.backgroundColor = [MAIN_YELLOW_COLOR CGColor];
    sureButton.layer.cornerRadius = 3;
    [sureButton addTarget:self action:@selector(didClickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:sureButton];
    
    //计算backgroundView的高度
    CGRect rect = self.backgroundView.frame;
    rect.size.height = _V_INSERT_HEIGHT_*2 + _SURE_BUTTON_HEIGHT + _BUTTON_HEIGHT_ + 10;
    if (colorArray) {
        rect.size.height += _TEXT_HEIGHT_ + _V_INSERT_HEIGHT_;
    }
    if (sizeArray) {
        rect.size.height += _TEXT_HEIGHT_ + _V_INSERT_HEIGHT_;
    }
    self.backgroundView.frame = rect;
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = self.backgroundView.frame;
        rect.origin.y = SCREEN_HEIGHT - self.backgroundView.bounds.size.height;
        self.backgroundView.frame = rect;
    }];
}


- (void)tappedCancel
{
    //点击背景视图
    [UIView animateWithDuration:.3 animations:^{
        [self.backgroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)tapGestureMethod:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    
    UIView *view11 = [self.backgroundView viewWithTag:8001];
    UIView *view12 = [self.backgroundView viewWithTag:8002];
    UIView *view13 = [self.backgroundView viewWithTag:8003];
    UIView *view14 = [self.backgroundView viewWithTag:8004];
    UIView *view21 = [self.backgroundView viewWithTag:9001];
    UIView *view22 = [self.backgroundView viewWithTag:9002];
    UIView *view23 = [self.backgroundView viewWithTag:9003];
    UIView *view24 = [self.backgroundView viewWithTag:9004];
    
    switch (view.tag) {
        case 8001:
            view12.layer.borderColor = [UIColor clearColor].CGColor;
            view13.layer.borderColor = [UIColor clearColor].CGColor;
            view14.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case 8002:
            view11.layer.borderColor = [UIColor clearColor].CGColor;
            view13.layer.borderColor = [UIColor clearColor].CGColor;
            view14.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case 8003:
            view12.layer.borderColor = [UIColor clearColor].CGColor;
            view11.layer.borderColor = [UIColor clearColor].CGColor;
            view14.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case 8004:
            view12.layer.borderColor = [UIColor clearColor].CGColor;
            view13.layer.borderColor = [UIColor clearColor].CGColor;
            view11.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        
        case 9001:
            view22.layer.borderColor = [UIColor clearColor].CGColor;
            view23.layer.borderColor = [UIColor clearColor].CGColor;
            view24.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case 9002:
            view21.layer.borderColor = [UIColor clearColor].CGColor;
            view23.layer.borderColor = [UIColor clearColor].CGColor;
            view24.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case 9003:
            view22.layer.borderColor = [UIColor clearColor].CGColor;
            view21.layer.borderColor = [UIColor clearColor].CGColor;
            view24.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case 9004:
            view22.layer.borderColor = [UIColor clearColor].CGColor;
            view23.layer.borderColor = [UIColor clearColor].CGColor;
            view21.layer.borderColor = [UIColor clearColor].CGColor;
            break;
            
        default:
            break;
    }
    
    if (view.layer.borderColor == [UIColor redColor].CGColor) {
        view.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        view.layer.borderColor = [UIColor redColor].CGColor;
        view.layer.borderWidth = 1;
        if ([view isKindOfClass:[UIImageView class]]) {
            int index = view.tag - 9001;
            NSString *imgUrl = [[[self.colorArray objectAtIndex:index] objectForKey:@"imgUrl"] firstObject];
            self.imgURL = [NSString stringWithFormat:@"http://pic.secoo.com/product/80/80/%@",imgUrl];
        } else if ([view isKindOfClass:[UILabel class]]) {
            int index = view.tag - 8001;
            self.productID = [[self.sizeArray objectAtIndex:index] objectForKey:@"productid"];
        }
    }
}

- (void)didClickSureButton
{
    [self tappedCancel];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishSelectProductWithImageURL:productID:)]) {
        [self.delegate didFinishSelectProductWithImageURL:self.imgURL productID:self.productID];
    }
}

- (void)didClickCollectButton
{
    [self tappedCancel];
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectTheProduct)]) {
        [self.delegate collectTheProduct];
    }
}

@end
