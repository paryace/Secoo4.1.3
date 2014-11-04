//
//  OrderListTableViewCell.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-10-11.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "Utils.h"

@interface OrderListTableViewCell ()
{
    CGFloat _indent;
    BOOL    _isSpreading;
}

@property (weak, nonatomic) ProductSubView *lastProductView;
@property (weak, nonatomic) UIButton *othersButton;
@property (weak, nonatomic) UIView *lastView;
@property (weak, nonatomic) UIView *backView;
@end

@implementation OrderListTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:238.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //NSLog(@"height :%f", frame.size.height);
}

- (void)setUpBackView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 10)];
    [self.contentView addSubview:view];
    self.backView = view;
    view.backgroundColor = [UIColor whiteColor];
    
    // Initialization code
    _indent = 10;
//    if (_IS_IPHONE6_) {
//        _indent = 20;
//    }
    CGSize size = [Utils getSizeOfString:@"订单编号" ofFont:[UIFont systemFontOfSize:16] withMaxWidth:SCREEN_WIDTH - 2 * _indent];
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indent, 10, SCREEN_WIDTH - 2 * _indent, size.height + 1)];
    [self.backView addSubview:orderLabel];
    orderLabel.backgroundColor = [UIColor whiteColor];
    orderLabel.textColor = [UIColor colorWithRed:67.0 / 255.0 green:67.0 / 255.0 blue:67.0 / 255.0 alpha:1.0];
    orderLabel.font = [UIFont systemFontOfSize:16];
    _OrderNumberLabel = orderLabel;
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - _indent - size.width - 10 , 5, size.width + 10, size.height + 1)];
    statusLabel.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:statusLabel];
    statusLabel.font = [UIFont systemFontOfSize:16];
    statusLabel.textColor = [UIColor colorWithRed:25.0 / 255.0 green:158.0 / 255.0 blue:25.0 / 255.0 alpha:1.0];
    _statusLabel = statusLabel;
    _statusLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat height = CGRectGetMaxY(orderLabel.frame) + 10;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_indent, height, SCREEN_WIDTH - _indent, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:198.0 / 255.0 alpha:1.0];
    [self.backView addSubview:lineView];
    
    self.lastView = lineView;
    
    height = size.height + 1;
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indent, CGRectGetHeight(self.backView.frame) - height - 10, SCREEN_WIDTH - 2 * _indent, height)];
    [self.backView addSubview:numberLabel];
    numberLabel.font = [UIFont systemFontOfSize:16];
    numberLabel.textColor = [UIColor colorWithRed:67.0 / 255.0 green:67.0 / 255.0 blue:67.0 / 255.0 alpha:1.0];
    _numberLabel = numberLabel;
    
    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(150 - _indent, CGRectGetMaxY(self.backView.frame) - height - 10, SCREEN_WIDTH - 150, height)];
    [self.backView addSubview:totalPrice];
    totalPrice.font = [UIFont systemFontOfSize:13];
    totalPrice.textColor = [UIColor colorWithRed:67.0 / 255.0 green:67.0 / 255.0 blue:67.0 / 255.0 alpha:1.0];
    _totalPriceLabel = totalPrice;
    totalPrice.textAlignment = NSTextAlignmentRight;
}

- (void)setUpCell
{
    [self.productViewArray removeAllObjects];
    [self.backView removeFromSuperview];
    [self setUpBackView];
    
    int i = 0;
    NSArray *products = [self.dictSource objectForKey:@"products"];
    for (NSDictionary *product in products) {
        ++i;
        if (i == 3) {
            if (!_isSpreading) {
                break;
            }
        }
        [self generateProductView:product];
    }
    if ([products count] > 2) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.othersButton = button;
        NSString *str = [NSString stringWithFormat:@"显示其余%d件", [products count] - 2];
        if (_isSpreading) {
            str = @"收起";
        }
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:11.0 / 255.0 green:66.0 / 255.0 blue:194.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, CGRectGetMaxY(self.lastProductView.frame), SCREEN_WIDTH, 50);
        [self.backView addSubview:button];
        [button addTarget:self action:@selector(displayAllProducts) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_indent, CGRectGetHeight(button.frame) - 0.5, SCREEN_WIDTH - _indent, 0.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:198.0 / 255.0 alpha:1.0];
        [button addSubview:lineView];
    }
    
    [self setNeedsLayout];
}

- (ProductSubView *)generateProductView:(NSDictionary *)product
{
    int areaType = [[self.dictSource objectForKey:@"areaType"] intValue];
    
    NSString *productName = [product objectForKey:@"productName"];//显示商品标题
//    NSString *totalPrice = [NSString stringWithFormat:@"实付款: ¥%.2f", [[product objectForKey:@"productPrice"] doubleValue]];//实付款
    
    NSString *totalPrice = [Utils moneyTypeWithAreaType:areaType price:[[product objectForKey:@"productPrice"] doubleValue]];
    
    NSString *countString = [NSString stringWithFormat:@" x%d", [[product objectForKey:@"productCount"] integerValue]];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:totalPrice];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:countString];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:171.0 / 255.0 alpha:1.0] range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    
    ProductSubView *view = [[ProductSubView alloc] init];
    view.title.text = productName;
    view.priceLabel.attributedText = attribute;
    [self.productViewArray addObject:view];
    CGRect frame = view.frame;
    if ([self.productViewArray count] == 1) {
        frame.origin.y = CGRectGetMaxY(self.lastView.frame);
        view.frame = frame;
        [self.backView addSubview:view];
    }
    else{
        frame.origin.y = CGRectGetMaxY(self.lastProductView.frame);
        view.frame = frame;
        [self.backView addSubview:view];
    }
    view.frame = frame;
    
    self.lastProductView = view;
    view.backgroundColor = [UIColor whiteColor];
    
    //add lineview
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_indent, CGRectGetHeight(view.frame) - 0.5, SCREEN_WIDTH - _indent, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:198.0 / 255.0 alpha:1.0];
    [view addSubview:lineView];
    return view;
}


+ (CGFloat)calculateHeight:(NSDictionary *)dict isSpreading:(BOOL)isSpreading
{
    CGFloat productViewHeight = 92;
    if ([Utils isiPhone6Plus]) {
        productViewHeight = 138;
    }
    NSArray *products = [dict objectForKey:@"products"];
    CGSize size = [Utils getSizeOfString:@"订单编号" ofFont:[UIFont systemFontOfSize:16] withMaxWidth:SCREEN_WIDTH];
    CGFloat height = size.height * 2 + 0.5 + 40 + 10;
    if ([products count] <= 2) {
        height += productViewHeight * [products count];
    }
    else{
        height += productViewHeight * 2 + 50;// has add height of button
        if (isSpreading) {
            height += ([products count] - 2) * productViewHeight;
        }
    }
    return height;
}

- (void)displayAllProducts
{
    NSArray *products = [self.dictSource objectForKey:@"products"];
    CGFloat height = 92;
    if ([Utils isiPhone6Plus]) {
        height = 138;
    }
    if (!_isSpreading) {
        CGRect frame = self.backView.frame;
        frame.size.height += ([products count] - 2) * height;
        self.backView.frame = frame;
        frame = self.frame;
        frame.size.height += ([products count] - 2) * height;
        self.frame = frame;
        for (int i = 2; i < [products count]; ++i) {
            NSDictionary *product = [products objectAtIndex:i];
            [self generateProductView:product];
        }
        self.othersButton.frame = CGRectMake(0, CGRectGetMaxY(self.lastProductView.frame), SCREEN_WIDTH, 50);
        [self.othersButton setTitle:@"收起" forState:UIControlStateNormal];
        frame = self.numberLabel.frame;
        frame.origin.y += ([products count] - 2) * height;
        self.numberLabel.frame = frame;
        
        frame = self.totalPriceLabel.frame;
        frame.origin.y += ([products count] - 2) * height;
        self.totalPriceLabel.frame = frame;
    }
    else{
        CGRect frame = self.backView.frame;
        frame.size.height -= ([products count] - 2) * height;
        self.backView.frame = frame;
        frame = self.frame;
        frame.size.height -= ([products count] - 2) * height;
        self.frame = frame;
        for (int i = 2; i < [self.productViewArray count]; ++i) {
            UIView *view = [self.productViewArray objectAtIndex:i];
            [view removeFromSuperview];
        }
        NSInteger count = [self.productViewArray count] - 2;
        for (int i = 0; i < count ; ++i) {
            [self.productViewArray removeLastObject];
        }
        self.lastProductView = [self.productViewArray lastObject];
        self.othersButton.frame = CGRectMake(0, CGRectGetMaxY(self.lastProductView.frame), SCREEN_WIDTH, 50);
        [self.othersButton setTitle:[NSString stringWithFormat:@"显示其余%d件", [products count] - 2] forState:UIControlStateNormal];
        
        frame = self.numberLabel.frame;
        frame.origin.y -= ([products count] - 2) * height;
        self.numberLabel.frame = frame;
        
        frame = self.totalPriceLabel.frame;
        frame.origin.y -= ([products count] - 2) * height;
        self.totalPriceLabel.frame = frame;
    }
    _isSpreading = !_isSpreading;
    if (_delegate && [_delegate respondsToSelector:@selector(orderTableCell:didSpread:)]) {
        [_delegate orderTableCell:self didSpread:_isSpreading];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

#pragma mark --
#pragma mark -- setter and getter --

- (NSMutableArray *)productViewArray
{
    if (_productViewArray == nil) {
        _productViewArray = [[NSMutableArray alloc] init];
    }
    return _productViewArray;
}

- (void)setDictSource:(NSDictionary *)dictSource
{
    if (_dictSource != dictSource) {
        _dictSource = dictSource;
        CGRect frame = self.frame;
        frame.size.height = [OrderListTableViewCell calculateHeight:dictSource isSpreading:_isSpreading];
        self.frame = frame;
        [self setUpCell];
    }
}

@end



//////////////////////
@implementation ProductSubView

- (instancetype)init
{
    CGFloat indent = 10;
    CGFloat imageWidth = 60;
    CGFloat height = 92;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    if ([Utils isiPhone6Plus]) {
        imageWidth = 90;
        height = 138;
        frame.size.height = height;
        indent = 10;
    }
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(indent, (height - imageWidth) / 2.0, imageWidth, imageWidth)];
        [self addSubview:imageView];
        _productImageView = imageView;
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [UIColor grayColor].CGColor;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMinY(imageView.frame), SCREEN_WIDTH - 2 * indent - 10 - imageWidth, 25)];
        [self addSubview:titleLabel];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        _title = titleLabel;
        _title.textColor = [UIColor colorWithRed:68.0 / 255.0 green:68.0 / 255.0 blue:68.0 / 255.0 alpha:1.0];
        
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize size = [Utils getSizeOfString:@"卢" ofFont:font withMaxWidth:200];
        CGFloat height = size.height + 1;
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMaxY(imageView.frame) - height, CGRectGetWidth(titleLabel.frame), height)];
        [self addSubview:priceLabel];
        priceLabel.font = font;
        _priceLabel = priceLabel;
    }
    return self;
}

@end
