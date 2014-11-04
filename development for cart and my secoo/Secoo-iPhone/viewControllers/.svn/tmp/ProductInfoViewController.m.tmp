//
//  ProductInfoViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/17/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "ImageDownloaderManager.h"
#import "CycleScrollViewController.h"
#import "ProductColorAndSizeView.h"
//#import "LogInViewController.h"
#import "UINavigationBar+CustomNavBar.h"
#import "ProductServiceView.h"
#import "ServiceInfoView.h"
#import "MBProgressHUD+Add.h"
#import "CartItem.h"
#import "CartTableViewCell.h"
#import "CartItemAccessor.h"
#import "CartViewController.h"
#import "AddressDataAccessor.h"
#import "CustomerOrderViewController.h"

#define offsetX                            10
#define TitleOffsetX                       10

#define ImageBaseTag                       44444
#define MaintenanceBaseTag                 55555
#define WashingBaseTag                     66666
#define SizeTableBaseTag                   77777
#define TitleLabelBaseTag                  88888
#define BrandStoryBaseTag                  99999
#define _TITLT_LABEL_HEIGHT_               45

#define ScrollImageViewTag                 (ImageBaseTag - 10000)

typedef enum : NSUInteger {
    ProductOriginNone,
    ProductOriginChina,
    ProductOriginAmerica,
    ProductOriginOthers,
} ProductOrigin;

typedef enum : NSUInteger {
    ImageBrowserNone,
    ImageBrowserProductInfo,
    ImageBrowserSizeTable,
    ImageBrowserBrandStory,
    ImageBrowserMaintenance,
} ImageBrowserType;

@interface ProductInfoViewController ()<CycleScrollViewDelegate, UIScrollViewDelegate, UIWebViewDelegate,ProductColorAndSizeViewDelegate>
{
    ProductOrigin _productOrigin;
    ImageBrowserType _imageBrowsType;
    NSInteger _originalOffsetY;
    BOOL _isSpecial;
    NSInteger _rotationNumber;//logoview rotation number
    //
    BOOL _notAailable;//indicates that products sold out
    BOOL _isFavorite;
    
    int _inventoryNumber;
    
    BOOL _washingButtonSpreaded;
    BOOL _maintanenceSpreaded;
    BOOL _brandStorySpreaded;
    BOOL _sizeTableSpreaded;
    BOOL _specificationSpreaded;
    BOOL _productDetailedViewSpreaded;
    
    int  _currentState;
}

@property (strong, nonatomic) NSString *realTimePrice;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIView *toolBar;
@property (strong, nonatomic) NSDictionary *productInfo;
@property (strong, nonatomic) NSMutableArray *mutilMediaArray;
@property (strong, nonatomic) NSArray *showImagesUrls;

/* 选择颜色和尺码 */
@property(nonatomic, strong) NSString *colorImageUrl;
@property(nonatomic, strong) NSString *sizePid;
@property(nonatomic, assign) int selectColorIndex;
@property(nonatomic, assign) int selectSizeIndex;
@property(nonatomic, strong) NSArray *colorArray;
@property(nonatomic, strong) NSArray *sizeArray;

@property(nonatomic, weak) UIView *backgroundView;
@property(nonatomic, weak) UIView *showView;

/*
 data get from network
 */
@property(strong, nonatomic) NSMutableDictionary *images;
@property(strong, nonatomic) NSMutableDictionary *imageViewsForURL;
@property(strong, nonatomic) NSMutableArray *downloadingImages;
@property(strong, nonatomic) NSMutableArray *imageViews;

@property(strong, nonatomic) NSArray *recommendedProducts;

@property(strong, nonatomic) NSMutableArray *brandImageViews;
@property(strong, nonatomic) NSMutableArray *maintanenceViews;
@property(strong, nonatomic) NSMutableArray *sizeTableViews;
@property(weak, nonatomic) CycleScrollViewController *cycleScrollVC;

/*
IntroView properties
 */
@property (weak, nonatomic) UIView *introductionView;
@property (weak, nonatomic) UIImageView *introImageView;
@property (weak, nonatomic) UIImageView *logoImageView;
@property (weak, nonatomic) UIButton *favoriteButton;
@property (weak, nonatomic) UILabel *productNameLabel;

@property (weak, nonatomic) UILabel *specialLabel;

@property (weak, nonatomic) UIView *priceView;//all the label of prices are on this view
@property (weak, nonatomic) UILabel *secooPriceLabel;

@property (weak, nonatomic) UIView *colorAndSizeView;
@property (weak, nonatomic) ProductColorAndSizeView *colorView;
@property (weak, nonatomic) ProductColorAndSizeView *sizeView;
@property (weak, nonatomic) ProductColorAndSizeView *colorView2;
@property (weak, nonatomic) ProductColorAndSizeView *sizeView2;

@property (weak, nonatomic) UIView *detailLabelView;
@property (weak, nonatomic) UILabel *specialProductLabel;
@property (weak, nonatomic) UILabel *noRefundLabel;
@property (weak, nonatomic) ServiceInfoView *serviceInfoView;

/*
 商品详情
 */
@property (weak, nonatomic) UIView *productDetailedInfoView;
@property (weak, nonatomic) UIWebView *productDetailedWebview;
@property (weak, nonatomic) UIButton *productDetailedHeadButton;
@property (weak, nonatomic) UIImageView *productDetailedSpreadImageView;

@property (weak, nonatomic) UIView *specificationView;
@property (weak, nonatomic) UIImageView *specSpreadImageView;

@property (weak, nonatomic) UIView *brandStoryView;
@property (weak, nonatomic) UIButton *brandHeadButton;
@property (weak, nonatomic) UIImageView *brandSpreadImageView;

@property (weak, nonatomic) UIView *maintanenceView;
@property (weak, nonatomic) UIButton *maintanenceButton;
@property (weak, nonatomic) UIImageView *maintanenceSpreadImageView;

@property (weak, nonatomic) UIView *washingTipsView;
@property (weak, nonatomic) UIButton *washingHeadButton;
@property (weak, nonatomic) UIImageView *washingSpreadImageView;

@property (weak, nonatomic) UIView *sizeTableView;
@property (weak, nonatomic) UILabel *sizeTableTitle;
@property (weak, nonatomic) UIView *sizeImageView;
@property (weak, nonatomic) UIView *sizeTableTexView;
@property (weak, nonatomic) UIView *sizeTableParameterView;
@property (weak, nonatomic) UIImageView *sizeTableSpreadImageView;

@property (weak, nonatomic) UIView *recommendationView;
@property (weak, nonatomic) UIScrollView *recommendationScrollView;

@property (weak, nonatomic) ProductServiceView *productServiceView;
@property (nonatomic, weak) UIView *serviceView;

@property (weak, nonatomic) UIButton *scrollToTopButton;

@property (weak, nonatomic) UIActivityIndicatorView *activityIndicatorView;

//显示购物车图标 和 数量
@property(nonatomic, weak) UIButton *cartButton;
@property(nonatomic, weak) UIButton *addToCartButton;
@property(nonatomic, weak) UIButton *buyNowButton;
/*
 iteraction with JS
 */

@property (strong, nonatomic) UIWebView *webView;

/*
 handle gesturerecognizer
 */
- (void)handleTap:(UITapGestureRecognizer *)tap;
- (void)getImageFromURL:(NSString *)imageUrl;
- (void)addProductToFavorite;
- (void)startActivityView;
- (void)addToFavorte:(UIButton *)button;
@end

@implementation ProductInfoViewController (NetWorking)

#pragma mark --
#pragma mark -- download images --

- (void)getImagesOfImageURL:(NSString *)imageUrl forImageView:(UIImageView*)imageView
{
    if ([NSThread isMainThread]) {
        UIImage *image = [self.images objectForKey:imageUrl];
        if (image) {
            if (imageView) {
                imageView.image = image;
                [self.view setNeedsLayout];
            }
        }
        else{
            NSArray *array = [self.imageViewsForURL objectForKey:imageUrl];
            if (array != nil) {
                BOOL hasIt = NO;
                for (UIImageView *view in array) {
                    if (view == imageView) {
                        hasIt = YES;
                        break;
                    }
                }
                if (!hasIt) {
                    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
                    [mArray addObject:imageView];
                    [self.imageViewsForURL setObject:mArray forKey:imageUrl];
                }
            }
            else{
                [self.imageViewsForURL setObject:@[imageView] forKey:imageUrl];
            }
            [self downLoadMainImageWithURL:imageUrl forImageView:imageView];
        }
    }
    else{
        __weak typeof(ProductInfoViewController*) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            typeof(ProductInfoViewController*) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf getImagesOfImageURL:imageUrl forImageView:imageView];
            }
        });
    }
}

- (void)downLoadMainImageWithURL:(NSString *)imageUrl forImageView:(UIImageView *)imageView;
{
    for (NSString *url in self.downloadingImages) {
        if ([url isEqualToString:imageUrl]) {
            return;
        }
    }
    
    [self.downloadingImages addObject:imageUrl];
    __weak typeof(self) weakSelf = self;
    [[ImageDownloaderManager sharedInstance] addImageDowningTask:imageUrl cached:YES completion:^(NSString *url, UIImage *image, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (image && strongSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.images setObject:image forKey:imageUrl];
                [strongSelf.downloadingImages removeObject:imageUrl];
                [strongSelf getImageFromURL:imageUrl];
            });
        }
    }];
}

- (void)downloadTopImage
{
    NSArray *showPictureUrl = self.showImagesUrls;
    if ([showPictureUrl count] > 0) {
        
        NSString *imageUrl = [self convertToRealUrl:[showPictureUrl objectAtIndex:0] ofsize:[self getIMageWidth]];
        [self getImagesOfImageURL:imageUrl forImageView:self.introImageView];
    }
}

- (CGFloat)getIMageWidth
{
   
    //CGFloat nascale = [UIScreen mainScreen].nativeScale;
    CGFloat width = 500;
    //NSString *de = [Utils deviceModelName];
//    if(nascale > 2.5){
//       // width = 700;
//    }
    return width;
}

- (void)getInventoryNumberAndRealTimePrice:(NSString *)productId
{
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/query_soldOut.action?productId=%@", productId];
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(ProductInfoViewController*) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(ProductInfoViewController*) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                    NSInteger number = [[jsonDict objectForKey:@"size"] integerValue];
                    NSString *priceStr = [jsonDict objectForKey:@"refPrice"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (number == 0 || number == -1) {
                            _notAailable = YES;
                            strongSelf.addToCartButton.enabled = NO;
                            strongSelf.addToCartButton.alpha = 0.0;
                            strongSelf.buyNowButton.enabled = NO;
                        }
                        else{
                            _notAailable = NO;
                            strongSelf.addToCartButton.enabled = YES;
                            strongSelf.addToCartButton.alpha = 1.0;
                            strongSelf.buyNowButton.enabled = YES;
                        }
                        _inventoryNumber = number;
                        strongSelf.realTimePrice = priceStr;
                        if (strongSelf.secooPriceLabel) {
                            NSString *refPriceStr;
                            if (_productOrigin == ProductOriginChina) {
                                refPriceStr = [NSString stringWithFormat:@"寺库价：¥%@", priceStr];
                            }
                            else {
                                refPriceStr = [NSString stringWithFormat:@"寺库价：%@人民币", priceStr];
                            }
                            strongSelf.secooPriceLabel.text = refPriceStr;
                        }
                    });
                }
            }
            else{
                NSLog(@"get inventory number error:%@", error.debugDescription);
            }
        }
    }];
}

- (void)getSpecilaProductInfo
{
    int areaType = [[self.productInfo objectForKey:@"areaType"] integerValue];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?client=iphone&method=secoo.cart.get&urlfilter=cart/cart.jsp&vo.productInfo=[{\"productId\":%@,\"quantity\":1,\"type\":0,\"areaType\":%d}]&areaType=%d", self.productID, areaType, areaType];
    NSString *compatibleURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(self) weakSelf = self;
    [session startConnectionToURL:compatibleURL completion:^(NSData *data, NSError *error) {
        if (weakSelf) {
            if (error == nil) {
                NSError *jsonError;
                id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *result = [jsonDict valueForKey:@"rp_result"];
                        if ([result isKindOfClass:[NSDictionary class]]) {
                            int recode = [[result valueForKey:@"recode"] integerValue];
                            if (recode == 0) {
                                NSDictionary *cart = [result valueForKey:@"cart"];
                                if ([[cart objectForKey:@"cartItems"] count] > 0) {
                                    NSDictionary *cartItem = [[cart objectForKey:@"cartItems"] objectAtIndex:0];
                                    BOOL isSpecial = [[cartItem objectForKey:@"isSpecialProductAsTicket"] boolValue];
                                    _isSpecial = isSpecial;
                                    if (isSpecial) {
                                        //是特例品 TODO测试
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.specialLabel.alpha = 1;
                                            weakSelf.specialProductLabel.text = @"该商品为特殊商品 不支持使用优惠券";
                                            CGRect rect1 = weakSelf.specialProductLabel.frame;
                                            rect1.size.height = 20;
                                            weakSelf.specialProductLabel.frame = rect1;
                                            
                                            CGRect rect2 = weakSelf.noRefundLabel.frame;
                                            rect2.origin.y = CGRectGetMaxY(weakSelf.specialProductLabel.frame) + 5;
                                            weakSelf.noRefundLabel.frame = rect2;
                                            
                                            CGRect rect3 = weakSelf.serviceInfoView.frame;
                                            rect3.origin.y = CGRectGetMaxY(weakSelf.noRefundLabel.frame) + ([weakSelf.specialProductLabel.text isEqualToString:@""]?0:15);
                                            weakSelf.serviceInfoView.frame = rect3;
                                            
                                            CGRect frame = weakSelf.detailLabelView.frame;
                                            frame.size.height = CGRectGetMaxY(weakSelf.serviceInfoView.frame) + 15;
                                            weakSelf.detailLabelView.frame = frame;
                                            
                                            frame = weakSelf.introductionView.frame;
                                            frame.size.height = CGRectGetMaxY(weakSelf.detailLabelView.frame);
                                            weakSelf.introductionView.frame = frame;
                                            
                                            weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.view.frame.size.width, frame.size.height);
                                            
                                            [weakSelf.view setNeedsLayout];
                                        });
                                    }
                                }
                            }
                            else{
                                NSString *errorMsg = [result valueForKey:@"errMsg"];
                                if (errorMsg) {
                                    NSLog(@"errMsg: %@", errorMsg);
                                }
                                else{
                                    NSLog(@"there is something wrong with the network when getting detailed products list");
                                }
                            }
                        }
                    }
                }
            }
            else{
                NSLog(@"get special product error");
            }
        }
    }];
}

- (void)buyImmediately
{
    NSInteger areaType = [[self.productInfo objectForKey:@"areaType"] integerValue];
    NSString *productInfo = [NSString stringWithFormat:@"{\"productId\":%@,\"quantity\":%d,\"type\":%d,\"areaType\":%d}",self.productID, 1, 0, areaType];
    productInfo = [[NSString stringWithFormat:@"\"cartItems\":[%@]", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AddressEntity *addressEntity = [[AddressDataAccessor sharedInstance] getDefaulAddress];
    if (addressEntity) {
        productInfo = [productInfo stringByAppendingString:[NSString stringWithFormat:@",\"shippingId\":\"%lld\"", addressEntity.addressId]];
    }
    productInfo = [productInfo stringByAppendingString:@",\"aid\":1"];
    productInfo = [[NSString stringWithFormat:@"{%@}", productInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/cartshowconfirm.action?upkey=%@&cart=%@&areaType=%d", [upKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], productInfo, areaType];
    [self startActivityView];
    __weak typeof(ProductInfoViewController *) weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(ProductInfoViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicatorView stopAnimating];
                [self.activityIndicatorView removeFromSuperview];
            });
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *receiveDic = (NSDictionary *)jsonResponse;
                        NSDictionary *rp_result = [receiveDic objectForKey:@"rp_result"];
                        
                        if (0 == [[rp_result objectForKey:@"recode"] intValue]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //[strongSelf.payButton setTitle:@"去结算" forState:UIControlStateNormal];
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                CustomerOrderViewController *customOrderVC = [storyboard instantiateViewControllerWithIdentifier:@"CustomerOrderViewController"];
                                customOrderVC.hidesBottomBarWhenPushed = YES;
                                customOrderVC.jsonDictionary = rp_result;
                                customOrderVC.productArray = [[rp_result objectForKey:@"cart"] objectForKey:@"cartItems"];
                                customOrderVC.payAndDeliver = [rp_result objectForKey:@"payAndDeliver"];
                                customOrderVC.isBuyNow = YES;
                                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                CartItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"CartItem" inManagedObjectContext:delegate.managedObjectContext];
                                item.quantity = 1;
                                item.availableAmount = 1;
                                item.color = nil;
                                item.size = nil;
                                if (strongSelf.sizeView) {
                                    item.productId = [NSString stringWithFormat:@"%@",strongSelf.sizePid];
                                } else {
                                    item.productId = strongSelf.productID;
                                }
                                customOrderVC.buyNowProductId = item.productId;
                                item.areaType = [[strongSelf.productInfo objectForKey:@"areaType"] intValue];
                                item.inventoryStatus = 0;
                                
                                customOrderVC.cartItems = @[item];
                                customOrderVC.forAvailable = NO;
                                //                                [strongSelf.mbProgressHUD hide:YES];
                                [strongSelf.navigationController pushViewController:customOrderVC animated:YES];
                                
                            });
                        }
                        else if ([[rp_result objectForKey:@"recode"] intValue] == 1060){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD showError:[rp_result objectForKey:@"errMsg"] toView:strongSelf.view];
                            });
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD showError:[rp_result objectForKey:@"errMsg"] toView:strongSelf.view];
                            });
                        }
                    }
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [strongSelf.payButton setTitle:@"再试一下" forState:UIControlStateNormal];
                    //[self setPayNumber];
                    //                    [strongSelf.mbProgressHUD hide:YES];
                    
                    [MBProgressHUD showError:@"亲，出错了，请再试一下" toView:strongSelf.view];
                });
            }
        }
    }];
}

- (void)checkFavorite
{
    if (![UserInfoManager didSignIn]) {
        return;
    }
    NSString *upkey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=favorite/myfavorite.jsp&v=1.0&client=iphone&vo.upkey=%@&method=secoo.user.isFavoritPro&productId=%@", [upkey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.productID];
    __weak typeof(ProductInfoViewController *) weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(ProductInfoViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *dict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[dict objectForKey:@"recode"] integerValue] == 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _isFavorite = YES;
                            
                            [self.favoriteButton setImage:_IMAGE_WITH_NAME(@"collect1") forState:UIControlStateNormal];
                        });
                    }
                }
            }
        }
    }];
}

- (void)removeFromFavorite
{
    if (![UserInfoManager didSignIn]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginTableViewController *logInVC = [storyBoard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logInVC];
        [nav.navigationBar customNavBar];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    NSString *upkey = [UserInfoManager getUserUpKey];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=favorite/myfavorite.jsp&v=1.0&client=iphone&vo.upkey=%@&method=secoo.user.deleteConcernedCommodityByProductId&vo.productId=%@", [upkey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.productID];
    __weak typeof(ProductInfoViewController *) weakSelf = self;
    LGURLSession *session = [[LGURLSession alloc] init];
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        typeof(ProductInfoViewController *) strongSelf = weakSelf;
        if (strongSelf) {
            if (error == nil && data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *dict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[dict objectForKey:@"recode"] integerValue] == 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _isFavorite = NO;
                            [self.favoriteButton setImage:_IMAGE_WITH_NAME(@"collect2") forState:UIControlStateNormal];
                            [MBProgressHUD showSuccess:@"取消成功" toView:weakSelf.view];
                        });
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:[dict objectForKey:@"errMsg"] toView:strongSelf.view];
                        });
                    }
                }
            }
        }
    }];
}

#pragma mark --
#pragma mark -- utilities --

- (NSString *)convertToRealUrl:(NSString *)url ofsize:(NSInteger)width
{
    //http://pic.secoo.com/product/200/200/23/28/10432328.jpg
    if ([url hasPrefix:@"http://"]) {
        return url;
    }
    NSString *realURL = [[NSString alloc] initWithFormat:@"http://pic.secoo.com/product/%d/%d/%@", width, width, url];
    if (width > 700) {
        //http://pic.secoo.com/product/yt/04/39/10480439.jpg
        realURL = [[NSString alloc] initWithFormat:@"http://pic.secoo.com/product/%d/%d/%@", 700, 700, url];
    }
    return realURL;
}

@end

@implementation ProductInfoViewController (introductionView)

- (void)setUpIntroView
{
    CGFloat width = self.view.frame.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 600)];
    view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    self.introductionView = view;
    [self.scrollView addSubview:view];
    
    //add the production image
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    self.introImageView = imageView;
    imageView.userInteractionEnabled = YES;
    [self.introductionView addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.introImageView addGestureRecognizer:tap];
    self.introImageView.tag = ImageBaseTag;
    UIImage *plach_holder_image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"place_holder_500" ofType:@"png"]];
    imageView.image = plach_holder_image;
    [self.imageViews addObject:imageView];
    
//    UILabel *specialLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 10, 60, 18)];
//    specialLabel.font = [UIFont systemFontOfSize:14];
//    specialLabel.textAlignment = NSTextAlignmentCenter;
//    specialLabel.text = @"特殊商品";
//    specialLabel.textColor = [UIColor whiteColor];
//    specialLabel.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
//    self.specialLabel = specialLabel;
//    specialLabel.alpha = 0;
//    [self.introImageView addSubview:specialLabel];
    
    //add logo imageview
    CGFloat xoffset = 20;
    CGFloat logWidth = 68;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xoffset, 10 + CGRectGetMaxY(self.introImageView.frame) - logWidth/2.0, logWidth, logWidth)];
    self.logoImageView = logoImageView;
    logoImageView.backgroundColor = [UIColor whiteColor];
    logoImageView.layer.borderWidth = 1;
    logoImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    logoImageView.layer.cornerRadius = logWidth / 2.0;
    [logoImageView.layer setMasksToBounds:YES];
    [self.introImageView addSubview:logoImageView];
    
    //add favorite button
    CGFloat foffset = 10;
    CGFloat fWidth = 44;
    UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(width - fWidth - foffset, CGRectGetMaxY(self.introImageView.frame)+5, fWidth, fWidth);
    self.favoriteButton = favoriteButton;
    
    favoriteButton.backgroundColor = [UIColor clearColor];
    UIImage *image = _IMAGE_WITH_NAME(@"collect2");
    [favoriteButton setImage:image forState:UIControlStateNormal];
    [favoriteButton addTarget:self action:@selector(addToFavorte:) forControlEvents:UIControlEventTouchUpInside];
    [self.introductionView addSubview:favoriteButton];
}

- (void)addNameLabel
{
    //add name label
    NSString *name = [self.productInfo objectForKey:@"productName"];
    NSString *subTitle = [self.productInfo objectForKey:@"subTitle"];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGFloat maxWidth = CGRectGetWidth(self.introImageView.frame) - 2 * offsetX;
    CGSize size = [Utils getSizeOfString:name ofFont:font withMaxWidth:maxWidth];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:name];
    [attribute addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attribute.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:68/255.0 alpha:1] range:NSMakeRange(0, attribute.length)];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(self.logoImageView.frame)+10, maxWidth, size.height)];
    self.productNameLabel = nameLabel;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (subTitle && ![subTitle isEqualToString:@""]) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", subTitle]];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:222/255.0 green:0 blue:0 alpha:1] range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
        [attribute appendAttributedString:text];
    }
    
    nameLabel.attributedText = attribute;
    [nameLabel sizeToFit];
    [self.introductionView addSubview:nameLabel];
}

- (void)addPriceView
{
    int areaType = [[self.productInfo objectForKey:@"areaType"] intValue];
    NSString *productArea = [self productPlaceWithAreaType:areaType];
    if (0 == areaType) {
        NSString *city = [[self.productInfo objectForKey:@"inventoryInfo"] objectForKey:@"city"];
        if (city && ![city isEqualToString:@""]) {
            productArea = city;
        }
    }
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(self.productNameLabel.frame)+10, CGRectGetWidth(self.introductionView.frame)-offsetX*2, 20)];
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.textColor = [UIColor colorWithWhite:68/255.0 alpha:1];
    areaLabel.font = [UIFont systemFontOfSize:14];
    areaLabel.text = [NSString stringWithFormat:@"商品所在地：%@", productArea];
    [self.introductionView addSubview:areaLabel];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(areaLabel.frame), CGRectGetWidth(self.view.frame), 130)];
    self.priceView = view;
    [self.introductionView addSubview:view];
    
    CGFloat maxWidth = CGRectGetWidth(self.view.frame) - 2 * offsetX;
    UIFont *font = [UIFont systemFontOfSize:16];
    NSString *refPriceStr = [NSString stringWithFormat:@"%@", [self.productInfo objectForKey:@"refPrice"]];
    if (_productOrigin == ProductOriginChina) {
        refPriceStr = [NSString stringWithFormat:@"寺库价：¥%@", refPriceStr];
    } else {
        refPriceStr = [NSString stringWithFormat:@"寺库价：¥%@人民币", refPriceStr];
    }
    CGSize labelSize = [Utils getSizeOfString:refPriceStr ofFont:font withMaxWidth: maxWidth];
    
    UILabel *secooPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 10, labelSize.width, labelSize.height)];
    [self.priceView addSubview:secooPriceLabel];
    secooPriceLabel.textColor = MAIN_YELLOW_COLOR;
    secooPriceLabel.backgroundColor = [UIColor clearColor];
    secooPriceLabel.font = font;
    secooPriceLabel.text = refPriceStr;
    
    //
    float marketPrice = [[self.productInfo objectForKey:@"marketPrice"] floatValue];
    float secooPrice = [[self.productInfo objectForKey:@"secooPrice"] floatValue];
    float refPrice = [[self.productInfo objectForKey:@"refPrice"] floatValue];
    if (marketPrice > 10 && refPrice < marketPrice) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dis" ofType:@"png"]];
        CGSize imageSize = image.size;
        
        float discount = refPrice / marketPrice * 10;
        if (discount >= 0.1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(CGRectGetMaxX(secooPriceLabel.frame) + 5, secooPriceLabel.center.y - imageSize.height / 2, imageSize.width, imageSize.height);
            button.userInteractionEnabled = NO;
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"  %.1f折", discount] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.priceView addSubview:button];
        }
    }
    
    NSString *marketPriceStr = @"";
    if (_productOrigin == ProductOriginChina) {
        if (marketPrice > 0 && refPrice < marketPrice) {
            marketPriceStr = [NSString stringWithFormat:@"市场价：¥ %.0f", marketPrice];
        }
    } else {
        if (secooPrice > 0) {
            marketPriceStr = [NSString stringWithFormat:@"当地价：%@", [Utils intMoneyTypeWithAreaType:areaType price:secooPrice]];
        }
    }
    
    font = [UIFont systemFontOfSize:14];
    labelSize = [Utils getSizeOfString:marketPriceStr ofFont:font withMaxWidth:maxWidth];
    UILabel *marketLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(secooPriceLabel.frame) + 5, CGRectGetWidth(self.view.frame) - 20, labelSize.height)];
    marketLabel.font = font;
    marketLabel.textColor = [UIColor lightGrayColor];
    marketLabel.backgroundColor = [UIColor clearColor];
    if (![marketPriceStr isEqualToString:@""]) {
        marketLabel.text = marketPriceStr;
        if (_productOrigin == ProductOriginChina) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, marketLabel.center.y, labelSize.width + 2 * (marketLabel.frame.origin.x - offsetX), 0.5)];
            lineView.backgroundColor = [UIColor colorWithWhite:171/255.0 alpha:1];
            [self.priceView addSubview:lineView];
        }
    } else {
        marketLabel.text = @"";
        CGRect frame = marketLabel.frame;
        frame.size.height = 0.01;
        marketLabel.frame = frame;
    }
    [self.priceView addSubview:marketLabel];
    
    if (_productOrigin == ProductOriginAmerica) {
        CGRect frame = self.priceView.frame;
        NSString *tariffStr = [NSString stringWithFormat:@"关税：¥ %@ 人民币", [self.productInfo objectForKey:@"additional"]];
        labelSize = [Utils getSizeOfString:tariffStr ofFont:font withMaxWidth:maxWidth];
        UILabel *tariffLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(marketLabel.frame) + ([marketLabel.text isEqualToString:@""]?5:0), CGRectGetWidth(self.view.frame) - 30, labelSize.height)];
        [self.priceView addSubview:tariffLabel];
        tariffLabel.font = font;
        tariffLabel.backgroundColor = [UIColor clearColor];
        tariffLabel.textColor = [UIColor lightGrayColor];
        tariffLabel.text = tariffStr;
        
        NSString *carriageStr = [NSString stringWithFormat:@"运费：¥ %@ 人民币", [self.productInfo objectForKey:@"carriage"]];
        labelSize = [Utils getSizeOfString:carriageStr ofFont:font withMaxWidth:maxWidth];
        UILabel *carriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(tariffLabel.frame) + ([tariffLabel.text isEqualToString:@""]?5:0), CGRectGetWidth(self.view.frame) - 30, labelSize.height)];
        [self.priceView addSubview:carriageLabel];
        carriageLabel.font = font;
        carriageLabel.backgroundColor = [UIColor clearColor];
        carriageLabel.textColor = [UIColor lightGrayColor];
        carriageLabel.text = carriageStr;
        
        frame.size.height = CGRectGetMaxY(carriageLabel.frame) + 15;
        self.priceView.frame = frame;
    }
    else{
        CGRect frame = self.priceView.frame;
        frame.size.height = CGRectGetMaxY(marketLabel.frame) + 15;
        self.priceView.frame = frame;
    }
    
    [self.view setNeedsLayout];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.introImageView.frame), SCREEN_WIDTH, CGRectGetMaxY(self.priceView.frame) - CGRectGetMaxY(self.introImageView.frame))];
    backgroundView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.introductionView addSubview:backgroundView];
    [self.introductionView sendSubviewToBack:backgroundView];
    
}

#pragma mark - 颜色和尺码
- (void)addProductColorAndSizeView
{
    NSDictionary *productSpec = [self.productInfo objectForKey:@"productSpec"];
    if (productSpec) {
        NSArray *sizeArray = [productSpec objectForKey:@"size"];
        NSArray *colorArray = [productSpec objectForKey:@"color"];
        
        self.colorArray = colorArray;
        self.sizeArray = sizeArray;
        
        if (sizeArray || colorArray) {
            UIView *colorAndSizeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceView.frame)+20, CGRectGetWidth(self.view.frame), 100)];
            self.colorAndSizeView = colorAndSizeView;
            colorAndSizeView.backgroundColor = [UIColor whiteColor];
            [self.introductionView addSubview:colorAndSizeView];
            
            UIFont *font = [UIFont systemFontOfSize:14];
            
            UILabel *colorLabel = nil;
            UILabel *sizeLabel = nil;
            
            ProductColorAndSizeView *colorView = nil;
            ProductColorAndSizeView *sizeView = nil;
            
            if (colorArray) {
                colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 10, SCREEN_WIDTH-offsetX, 30)];
                colorLabel.font = font;
                colorLabel.text = [[colorArray firstObject] objectForKey:@"specname"];
                [colorAndSizeView addSubview:colorLabel];
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, colorLabel.frame.size.height-0.5, colorLabel.frame.size.width, 0.5)];
                lineLabel.backgroundColor = [UIColor lightGrayColor];
                [colorLabel addSubview:lineLabel];
                
                colorView = [[ProductColorAndSizeView alloc] initWithFrame:CGRectMake(51, CGRectGetMaxY(colorLabel.frame)+5, SCREEN_WIDTH-51, 30) colorArray:colorArray delegate:self selectIndex:-1];
                self.colorView = colorView;
                [colorAndSizeView addSubview:colorView];
            }
            if (sizeArray) {
                sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, colorArray?(CGRectGetMaxY(colorView.frame)+10):10, SCREEN_WIDTH-offsetX, 30)];
                sizeLabel.font = font;
                sizeLabel.text = [[sizeArray firstObject] objectForKey:@"specname"];
                [colorAndSizeView addSubview:sizeLabel];
                
                //查看尺寸信息
                NSArray *sizeImageUrl = [self.productInfo objectForKey:@"sizeTableUrl"];
                id pa = [self.productInfo objectForKey:@"parameter"];
                id txt = [self.productInfo objectForKey:@"sizeTableTxt"];
                if ([txt count] == 0) {
                    if ([self.productInfo objectForKey:@"sizeTable"]) {
                        sizeImageUrl = @[[NSString stringWithFormat:@"http://iphone.secoo.com/%@", [self.productInfo objectForKey:@"sizeTable"]]];
                    }
                    else{
                        sizeImageUrl = nil;
                    }
                }
                if ([sizeImageUrl count] > 0 || [pa count] > 0|| [txt count] > 0) {
                    UIButton *sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    sizeButton.frame = CGRectMake(colorAndSizeView.frame.size.width-110, 0, 100, CGRectGetHeight(sizeLabel.frame));
                    CGPoint center = sizeButton.center;
                    center.y = sizeLabel.center.y;
                    sizeButton.center = center;
                    sizeButton.backgroundColor = [UIColor clearColor];
                    [sizeButton setTitle:@"查看尺码信息" forState:UIControlStateNormal];
                    [sizeButton setTitleColor:[UIColor colorWithRed:70/255.0 green:104/255.0 blue:178/255.0 alpha:1] forState:UIControlStateNormal];
                    [[sizeButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
                    [sizeButton addTarget:self action:@selector(seeTheSizeInformation:) forControlEvents:UIControlEventTouchUpInside];
                    [colorAndSizeView addSubview:sizeButton];
                }
                
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeLabel.frame.size.height-0.5, sizeLabel.frame.size.width, 0.5)];
                lineLabel.backgroundColor = [UIColor lightGrayColor];
                [sizeLabel addSubview:lineLabel];
                
                sizeView = [[ProductColorAndSizeView alloc] initWithFrame:CGRectMake(51, CGRectGetMaxY(sizeLabel.frame)+5, SCREEN_WIDTH-51, 30) sizeArray:sizeArray delegate:self selectIndex:-1];
                self.sizeView = sizeView;
                [colorAndSizeView addSubview:sizeView];
            }
            
            //frame
            CGRect rect = self.colorAndSizeView.frame;
            if (sizeView) {
                rect.size.height = CGRectGetMaxY(sizeView.frame)+10;
            } else if (colorView) {
                rect.size.height = CGRectGetMaxY(colorView.frame)+10;
            } else {
                self.colorAndSizeView = nil;
            }
            [self.colorAndSizeView setFrame:rect];
            return;
        }
    }
    self.colorAndSizeView = nil;
}

#pragma mark - 查看尺寸详细信息
- (void)seeTheSizeInformation:(UIButton *)sender
{
    if (self.sizeTableView) {
        float y = self.sizeTableView.frame.origin.y;
        CGSize contentSize = self.scrollView.contentSize;
        CGPoint point = self.scrollView.contentOffset;
        float h = contentSize.height - y;
        float screenHeight = self.scrollView.frame.size.height;
        if (screenHeight - h > 0) {
            y -= (screenHeight - h);
        }
        
        point.y = y;
        [UIView animateWithDuration:.3f animations:^{
            self.scrollView.contentOffset = point;
        }];
    }
}

#pragma mark ---
- (void)addDetailLabelView
{
    if (self.colorAndSizeView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colorAndSizeView.frame), CGRectGetWidth(self.view.frame), 100)];
        self.detailLabelView = view;
        [self.introductionView addSubview:view];
    }
    else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceView.frame)+20, CGRectGetWidth(self.view.frame), 100)];
        self.detailLabelView = view;
        [self.introductionView addSubview:view];
    }
    self.detailLabelView.backgroundColor = [UIColor whiteColor];
    CGFloat maxWidth = CGRectGetWidth(self.view.frame) - 2 * offsetX;
    UIFont *font = [UIFont systemFontOfSize:13];
    
    CGFloat labelWidth = CGRectGetWidth(self.view.frame) - 2 * offsetX;
    UILabel *cutoffLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 20, labelWidth, 25)];
    [self.detailLabelView addSubview:cutoffLabel];
    cutoffLabel.font = font;
    if (_productOrigin == ProductOriginChina) {
        cutoffLabel.text = @"手机下单再";

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 60, 25)];
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = MAIN_YELLOW_COLOR;
        label.text = @"减20元";
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = MAIN_YELLOW_COLOR.CGColor;
        [cutoffLabel addSubview:label];
    } else {
        cutoffLabel.text = @"";
        CGRect frame = cutoffLabel.frame;
        frame.size.height = 0.01;
        cutoffLabel.frame = frame;
    }
    
    
    NSString *freeService = [NSString stringWithFormat:@"%@",[self.productInfo objectForKey:@"giftServiceInfo"]];
    CGSize labelSize = [Utils getSizeOfString:freeService ofFont:font withMaxWidth:labelWidth-60];
    
    UILabel *freeServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, ([cutoffLabel.text isEqualToString:@""]?0:10) + CGRectGetMaxY(cutoffLabel.frame), labelWidth, labelSize.height+10)];
    freeServiceLabel.numberOfLines = 0;
    freeServiceLabel.font = font;
    [self.detailLabelView addSubview:freeServiceLabel];
    if (freeService && ![freeService isEqualToString:@""]) {
        freeServiceLabel.text = @"赠送";
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:freeService];
        [text addAttribute:NSForegroundColorAttributeName value:MAIN_YELLOW_COLOR range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 10;
        style.firstLineHeadIndent = 10;
        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
        
        labelSize = [Utils getSizeOfString:text.mutableString ofFont:font withMaxWidth:labelWidth-60];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, labelWidth-40, labelSize.height > 35 ? labelSize.height : 25)];
        label.numberOfLines = 0;
        label.attributedText = text;
        label.layer.borderColor = MAIN_YELLOW_COLOR.CGColor;
        label.layer.borderWidth = 0.5;
        [freeServiceLabel addSubview:label];
        
        CGRect frame = freeServiceLabel.frame;
        frame.size.height = CGRectGetHeight(label.frame);
        freeServiceLabel.frame = frame;
    } else {
        freeServiceLabel.text = @"";
        CGRect frame = freeServiceLabel.frame;
        frame.size.height = 0.01;
        freeServiceLabel.frame = frame;
    }
    
    
    NSString *str = [NSString stringWithFormat:@"%@", [self.productInfo objectForKey:@"productGetTime"]];
    if ([str isEqualToString:@"2"]) {
        str = @"2-4天";
    } else if ([str isEqualToString:@"5"]) {
        str = @"5-7天";
    } else if ([str isEqualToString:@"8"]) {
        str = @"8-17天";
    } else if ([str isEqualToString:@"18"]) {
        str = @"18-32天";
    } else {
        str = @"";
    }
    
    str = @"";
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"下单后会在 "];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attribute.length)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    [text addAttribute:NSForegroundColorAttributeName value:MAIN_YELLOW_COLOR range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    text = [[NSMutableAttributedString alloc] initWithString:@" 内发货"];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, text.length)];
    [attribute appendAttributedString:text];
    
    labelSize = [Utils getSizeOfString:str ofFont:font withMaxWidth:maxWidth];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(freeServiceLabel.frame) + ([freeServiceLabel.text isEqualToString:@""]?0:15), labelWidth, labelSize.height)];
    label.font = [UIFont systemFontOfSize:16];
    if ([str isEqualToString:@""]) {
        label.text = @"";
        CGRect frame = label.frame;
        frame.size.height = 0.01;
        label.frame = frame;
    } else {
        label.attributedText = attribute;
    }
    [self.detailLabelView addSubview:label];
    
    UILabel *freeCarriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(label.frame) + ([label.text isEqualToString:@""]?0:5), labelWidth, 20)];
    freeCarriageLabel.font = font;
    freeCarriageLabel.textColor = [UIColor lightGrayColor];
    [self.detailLabelView addSubview:freeCarriageLabel];
    if (_productOrigin == ProductOriginChina) {
        freeCarriageLabel.text = @"寺库承担运费";
    } else if(_productOrigin == ProductOriginOthers) {
        freeCarriageLabel.text = @"寺库承担关税，运费";
    } else {
        freeCarriageLabel.text = @"";
        CGRect frame = freeCarriageLabel.frame;
        frame.size.height = 0.01;
        freeCarriageLabel.frame = frame;
    }
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(freeCarriageLabel.frame) + ([freeCarriageLabel.text isEqualToString:@""]?0:5), labelWidth, 20)];
    levelLabel.font = font;
    levelLabel.textColor = [UIColor lightGrayColor];
    [self.detailLabelView addSubview:levelLabel];
    NSString *level = [NSString stringWithFormat:@"%@",[self.productInfo valueForKey:@"level"]];
    if ([level isEqualToString:@"N"]) {
        level = nil;
    } else if ([level isEqualToString:@"S"]) {
        level = nil;
    } else if ([level isEqualToString:@"A"]) {
        level = @"有轻微使用痕迹，接近于全新，使用状态良好。";
    } else if ([level isEqualToString:@"AB"]) {
        level = @"有少量使用痕迹，外观有轻微磨损、划痕、变色等情况发生。";
    } else if ([level isEqualToString:@"B"]) {
        level = @"使用痕迹较明显，外观有一定程度的磨损、划痕、变色情况，不影响使用。";
    }
    if (level && ![level isEqualToString:@""]) {
        levelLabel.text = level;
    } else {
        levelLabel.text = @"";
        CGRect frame = levelLabel.frame;
        frame.size.height = 0.01;
        levelLabel.frame = frame;
    }
    
    UILabel *specialProductLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(levelLabel.frame) + ([levelLabel.text isEqualToString:@""]?0:5), labelWidth, 20)];
    self.specialProductLabel = specialProductLabel;
    specialProductLabel.font = font;
    specialProductLabel.textColor = [UIColor lightGrayColor];
    [self.detailLabelView addSubview:specialProductLabel];
    if (_isSpecial) {
        specialProductLabel.text = @"该商品为特殊商品 不支持使用优惠券";
        self.specialLabel.alpha = 1;
    } else {
        specialProductLabel.text = @"";
        CGRect frame = specialProductLabel.frame;
        frame.size.height = 0.01;
        specialProductLabel.frame = frame;
    }
    
    //是否支持退换货
    NSString *exchange = [NSString stringWithFormat:@"%@", [self.productInfo objectForKey:@"isExchange"]];
    BOOL re = [exchange isEqualToString:@"0"] ? NO : YES;
    
    //是否支持货到付款
    int cod = [[self.productInfo objectForKey:@"cod"] intValue];
    BOOL ex = 0 == cod ? NO : YES;
   
    UILabel *noRefundLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(specialProductLabel.frame) + ([specialProductLabel.text isEqualToString:@""]?0:5), labelWidth, 20)];
    self.noRefundLabel = noRefundLabel;
    [self.detailLabelView addSubview:noRefundLabel];
    noRefundLabel.font = [UIFont systemFontOfSize:13];
    noRefundLabel.textColor = [UIColor colorWithWhite:68/255.0 alpha:1];
    if (re) {
        noRefundLabel.text = @"";
        CGRect frame = noRefundLabel.frame;
        frame.size.height = 0.01;
        noRefundLabel.frame = frame;
    } else {
        noRefundLabel.text = @"本商品无质量问题 不支持退换货";
    }
    
    ServiceInfoView *serviceInfoView = [[ServiceInfoView alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(noRefundLabel.frame) + ([noRefundLabel.text isEqualToString:@""]?0:15), labelWidth, 17) returnsOrNot:re cod:ex];
    self.serviceInfoView = serviceInfoView;
    [self.detailLabelView addSubview:serviceInfoView];
    
    CGRect frame = self.detailLabelView.frame;
    frame.size.height = CGRectGetMaxY(serviceInfoView.frame) + 15;
    self.detailLabelView.frame = frame;
    
    frame = self.introductionView.frame;
    frame.size.height = CGRectGetMaxY(self.detailLabelView.frame);
    self.introductionView.frame = frame;
    [self.view setNeedsLayout];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, frame.size.height);
}

#pragma mark --
- (NSString *)productPlaceWithAreaType:(int)areaType
{
    if (0 == areaType) {
        return @"大陆";
    } else if (1 == areaType) {
        return @"香港";
    } else if (2 == areaType) {
        return @"美国";
    } else if (3 == areaType) {
        return @"日本";
    } else if (4 == areaType) {
        return @"欧洲";
    } else if (5 == areaType) {
        return @"法国";
    }
    return @"";
}

#pragma mark --callbacks--

@end

#pragma mark --
#pragma mark -- 商品详情 --
@implementation ProductInfoViewController (ProductDetailedInformation)

- (void)setUpProductDetailedInformationView
{
    if ([[self.productInfo objectForKey:@"detailDesc"] count] == 0) {
        return;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.introductionView.frame) + 10, CGRectGetWidth(self.view.frame), 100)];
    [self.scrollView addSubview:view];
    self.productDetailedInfoView = view;
    self.productDetailedInfoView.backgroundColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [Utils getSizeOfString:@"商品详情" ofFont:font withMaxWidth:100];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(TitleOffsetX, 16, 100, size.height + 1)];
    label.font = font;
    label.text = @"商品详情";
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 16 + 12 + CGRectGetHeight(label.frame));
    [view addSubview:headButton];
    [headButton addSubview:label];
    headButton.backgroundColor = [UIColor whiteColor];
    [headButton addTarget:self action:@selector(detailedProductInfoHeadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.productDetailedHeadButton = headButton;
    
    UIImage *spreadImage = [UIImage imageNamed:@"spread2.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:spreadImage];
    imageView.frame = CGRectMake(self.view.frame.size.width - spreadImage.size.width - 15, (headButton.frame.size.height - spreadImage.size.height) / 2.0, spreadImage.size.width, spreadImage.size.height);
    [headButton addSubview:imageView];
    self.productDetailedSpreadImageView = imageView;
    
    CGRect frame = self.productDetailedInfoView.frame;
    frame.size.height = CGRectGetHeight(self.productDetailedHeadButton.frame);
    self.productDetailedInfoView.frame = frame;
    
    [self detailedProductInfoHeadButtonClicked:headButton];
}

- (void)detailedProductInfoHeadButtonClicked:(UIButton *)button
{
    UIView *lastView;
    if (_productDetailedViewSpreaded) {
        _productDetailedViewSpreaded = NO;
        [self.mutilMediaArray removeAllObjects];
        self.productDetailedSpreadImageView.image = [UIImage imageNamed:@"spread2.png"];
        NSArray *multiMediaDict = [self.productInfo objectForKey:@"detailDesc"];
        for (int i = 0; i < ([multiMediaDict count] + [self.showImagesUrls count]); ++i) {
            UIView *view = [self.productDetailedInfoView viewWithTag:ImageBaseTag + i + 1];
            [view removeFromSuperview];
        }
        
        UIView *lineView = [self.productDetailedInfoView viewWithTag:100];
        [lineView removeFromSuperview];
        lastView = self.productDetailedHeadButton;
    }
    else{
        _productDetailedViewSpreaded = YES;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(self.productDetailedHeadButton.frame), CGRectGetWidth(self.view.frame) - offsetX, 0.5)];
        lineView.tag = 100;
        lineView.backgroundColor = [UIColor colorWithWhite:171/255.0 alpha:1];
        [self.productDetailedInfoView addSubview:lineView];
        
        
        self.productDetailedSpreadImageView.image = [UIImage imageNamed:@"spread.png"];
        NSArray *multiMediaDict = [self.productInfo objectForKey:@"detailDesc"];
        lastView = self.productDetailedHeadButton;
        NSInteger imageCount = 1;
        NSInteger webConut = 0;
        UIImage *defaultImage = [UIImage imageNamed:@"loading.png"];
        for (NSDictionary *dict in multiMediaDict) {
            if ([[dict objectForKey:@"type"] integerValue] == 0) {
                NSString *htmlString = [dict objectForKey:@"content"];
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(lastView.frame) + 5, self.view.frame.size.width - 2 * offsetX, 1)];
                //webView.backgroundColor = [UIColor redColor];
                webView.delegate = self;
                webView.opaque = NO;
                webView.backgroundColor = [UIColor clearColor];
                webView.scrollView.bounces = NO;
                webView.userInteractionEnabled = NO;
                webView.tag = ImageBaseTag + webConut + [self.showImagesUrls count];
                [self.mutilMediaArray addObject:[NSNumber numberWithInteger:ImageBaseTag + webConut + [self.showImagesUrls count]]];
                webConut ++;
                [self.productDetailedInfoView addSubview:webView];
                //webView.scalesPageToFit = YES;
                [webView loadHTMLString:htmlString baseURL:nil];
                lastView = webView;
            }
            else if ([[dict objectForKey:@"type"] integerValue] == 1){
                NSString *urlString = [dict objectForKey:@"url"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(lastView.frame) + 5, 400, CGRectGetWidth(self.view.frame) - 2 * offsetX)];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                [imageView addGestureRecognizer:tap];
                imageView.image = defaultImage;
                [self.imageViews addObject:imageView];
                [self.productDetailedInfoView addSubview:imageView];
                imageView.tag = ImageBaseTag + imageCount;
                [self.mutilMediaArray addObject:[NSNumber numberWithInteger:ImageBaseTag + imageCount]];
                imageCount ++;
                [self getImagesOfImageURL:[self convertToRealUrl:urlString ofsize:[self getIMageWidth]] forImageView:imageView];
                lastView = imageView;
            }
        }
    }
    
    CGRect frame = self.productDetailedInfoView.frame;
    frame.size.height = CGRectGetHeight(lastView.frame);
    self.productDetailedInfoView.frame = frame;
    [self.view setNeedsLayout];
}

#pragma mark --
#pragma mark -- UIWebDelegate --
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.tag > ImageBaseTag) {
        NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
        NSString *width = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth;"];
        CGRect frame = webView.frame;
        frame.size.height = [height floatValue] / [width floatValue]  * self.view.frame.size.width;
        webView.frame = frame;
//        if (frame.size.height < 10) {
//            [webView removeFromSuperview];
//        }
        [self.view setNeedsLayout];
    }
}

@end

#pragma mark --
#pragma mark -- 商品信息页 --
@implementation ProductInfoViewController (ProductSpecification)

#pragma mark - 加灰色线
- (void)addLineLabelWithView:(UIView *)view upOrDown:(int)upOrDown
{
    // 0 加在上面 1 加在下面
    float h = upOrDown == 0 ? 0 : (view.frame.size.height-0.5);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, h, view.frame.size.width, 0.5)];
    label.backgroundColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
    label.tag = (upOrDown == 0) ? 0 : TitleLabelBaseTag;
    [view addSubview:label];
}


- (void)addProductSpecifications
{
    NSArray *extraProperties = [self.productInfo objectForKey:@"productExtraPpropertys"];
    if ([extraProperties count] == 0) {
        return;
    }
    UIView *lastView = self.productDetailedInfoView;
    if (lastView == nil) {
        lastView = self.introductionView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame) + 10, self.view.frame.size.width, 100)];
    view.backgroundColor = [UIColor whiteColor];
    self.specificationView = view;
    [self.scrollView addSubview:view];
    
    
    CGFloat maxWidth = CGRectGetWidth(self.view.frame) - offsetX;
    UIFont *font = [UIFont systemFontOfSize:18];
    NSString *str = @"商品信息";
    CGSize labelSize = [Utils getSizeOfString:str ofFont:font withMaxWidth:maxWidth];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(TitleOffsetX, 0, maxWidth, _TITLT_LABEL_HEIGHT_)];
    title.text = str;
    [self.specificationView addSubview:title];
    
    [self addLineLabelWithView:title upOrDown:1];
    
    //设置缩进
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 68;
    style.firstLineHeadIndent = 0;
    
    //propertyName, propertyValue
    CGFloat offsetY = 5;
    CGFloat originalY = CGRectGetMaxY(title.frame) + 20;
    font = [UIFont systemFontOfSize:14];
    labelSize = [Utils getSizeOfString:@"我" ofFont:font withMaxWidth:maxWidth];
    NSInteger counter = 0;
    for (NSDictionary *dict in extraProperties) {
        NSString *name = [NSString stringWithFormat:@"%@:",[dict valueForKey:@"propertyName"]];
//        if ([name length] == 2) {
//            name = [NSString stringWithFormat:@"%@%@", @"          ", name];
//        }
//        else if ([name length] == 3){
//            name = [NSString stringWithFormat:@"%@%@", @"       ", name];
//        }
        
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:name];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attribute.length)];
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, attribute.length)];
        
        if ([dict valueForKey:@"propertyValue"] && ![@"" isEqualToString:[dict valueForKey:@"propertyValue"]]) {
            NSString *value = [NSString stringWithFormat:@"  %@", [dict valueForKey:@"propertyValue"]];
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:value];
            [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, content.length)];
            [attribute appendAttributedString:content];
            [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attribute.length)];
            
            NSString *result = [NSString stringWithFormat:@"%@:  %@", name, value];
            CGSize size = [Utils getSizeOfString:result ofFont:[UIFont systemFontOfSize:14] withMaxWidth:maxWidth];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, originalY, maxWidth, size.height)];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.attributedText = attribute;
            
            [self.specificationView addSubview:label];
            originalY = CGRectGetMaxY(label.frame) + offsetY;
            counter ++;
            if (counter == 5) {
                label.tag = 9999;
                break;
            }
        }
    }
    
    CGRect frame = self.specificationView.frame;
    frame.size.height = originalY - offsetY + 10;
    self.specificationView.frame = frame;
    
    //add button
    if ([extraProperties count] > 5) {
        UIButton *spreadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        spreadButton.frame = CGRectMake(0, title.center.y - 22, self.view.frame.size.width, 44);
        [self.specificationView addSubview:spreadButton];
        [spreadButton setBackgroundColor:[UIColor clearColor]];
        //[spreadButton setImage:_IMAGE_WITH_NAME(@"spread2") forState:UIControlStateNormal];
        [spreadButton addTarget:self action:@selector(showAllInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *spreadImage = [UIImage imageNamed:@"spread2.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:spreadImage];
        imageView.frame = CGRectMake(self.view.frame.size.width - spreadImage.size.width - 15, (spreadButton.frame.size.height - spreadImage.size.height) / 2.0, spreadImage.size.width, spreadImage.size.height);
        [spreadButton addSubview:imageView];
        self.specSpreadImageView = imageView;
    }
}

- (void)showAllInfo:(UIButton *)button
{
    if (!_specificationSpreaded) {
        _specificationSpreaded = YES;
        self.specSpreadImageView.image = [UIImage imageNamed:@"spread.png"];
        //设置缩进
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 68;
        style.firstLineHeadIndent = 0;
        
        UILabel *lastLabel = (UILabel *)[self.specificationView viewWithTag:9999];
        CGFloat offsetY = 5;
        CGFloat originalY = CGRectGetMaxY(lastLabel.frame) + offsetY;
        CGFloat maxWidth = CGRectGetWidth(self.view.frame) - 2 * offsetX;
        UIFont *font = [UIFont systemFontOfSize:14];
        
        NSArray *extraProperties = [self.productInfo objectForKey:@"productExtraPpropertys"];
        for (int i = 5; i < [extraProperties count]; ++i) {
            NSDictionary *dict = [extraProperties objectAtIndex:i];
            NSString *name = [NSString stringWithFormat:@"%@:",[dict valueForKey:@"propertyName"]];
//            if ([name length] == 2) {
//                name = [NSString stringWithFormat:@"%@%@", @"          ", name];
//            }
//            else if ([name length] == 3){
//                name = [NSString stringWithFormat:@"%@%@", @"       ", name];
//            }
            
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:name];
            [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, attribute.length)];
            
            if ([dict valueForKey:@"propertyValue"] && ![@"" isEqualToString:[dict valueForKey:@"propertyValue"]]) {
                NSString *value = [NSString stringWithFormat:@"  %@", [dict valueForKey:@"propertyValue"]];
                NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:value];
                [attribute appendAttributedString:content];
                [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attribute.length)];
                
                NSString *result = [NSString stringWithFormat:@"%@:  %@", name, value];
                CGSize size = [Utils getSizeOfString:result ofFont:[UIFont systemFontOfSize:14] withMaxWidth:maxWidth];

                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, originalY, maxWidth, size.height)];
                label.backgroundColor = [UIColor clearColor];
                label.numberOfLines = 0;
                label.font = font;
                label.attributedText = attribute;
                label.tag = 9999 + i - 4;
                [self.specificationView addSubview:label];
                originalY = CGRectGetMaxY(label.frame) + offsetY;
            }
        }
        
        CGRect frame = self.specificationView.frame;
        frame.size.height = originalY - offsetY + 10;
        self.specificationView.frame = frame;
    }
    else{
        _specificationSpreaded = NO;
        self.specSpreadImageView.image = [UIImage imageNamed:@"spread2.png"];
        NSArray *extraProperties = [self.productInfo objectForKey:@"productExtraPpropertys"];
        for (int i = 5; i < [extraProperties count]; ++i) {
            UIView *view = [self.specificationView viewWithTag:9999 + i - 4];
            [view removeFromSuperview];
        }
        UIView *view = [self.specificationView viewWithTag:9999];
        CGRect frame = self.specificationView.frame;
        frame.size.height = CGRectGetMaxY(view.frame) + 10;
        self.specificationView.frame = frame;
    }
    [self.view setNeedsLayout];
}

@end


#pragma mark --
#pragma mark -- sizeTable --
@implementation ProductInfoViewController (sizeTable)

- (void)setSizeTableView
{
    NSArray *sizeImageUrl = [self.productInfo objectForKey:@"sizeTableUrl"]; //sizeTable
    id pa = [self.productInfo objectForKey:@"parameter"];
    id txt = [self.productInfo objectForKey:@"sizeTableTxt"];
    if ([txt count] == 0) {
        if ([self.productInfo objectForKey:@"sizeTable"]) {
            sizeImageUrl = @[[NSString stringWithFormat:@"http://iphone.secoo.com/%@", [self.productInfo objectForKey:@"sizeTable"]]];
        }
        else{
            sizeImageUrl = nil;
        }
    }
    if ([sizeImageUrl count] > 0 || [pa count] > 0|| [txt count] > 0) {
        if (self.specificationView) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.specificationView.frame) + 10, CGRectGetWidth(self.view.frame), 500)];
            self.sizeTableView = view;
            [self.scrollView addSubview:view];
        }
        else if(self.productDetailedInfoView){
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.productDetailedInfoView.frame) + 10, CGRectGetWidth(self.view.frame), 500)];
            self.sizeTableView = view;
            [self.scrollView addSubview:view];
        }
        else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.introductionView.frame) + 10, CGRectGetWidth(self.view.frame), 500)];
            self.sizeTableView = view;
            [self.scrollView addSubview:view];
        }
        self.sizeTableView.backgroundColor = [UIColor whiteColor];
        
        CGFloat maxWidth = CGRectGetWidth(self.view.frame) - offsetX;
        NSString *str = @"尺码信息";
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(TitleOffsetX, 0, maxWidth, _TITLT_LABEL_HEIGHT_)];
        title.text = str;
        self.sizeTableTitle = title;
        [self.sizeTableView addSubview:title];
        
        CGRect frame = self.sizeTableView.frame;
        frame.size.height = CGRectGetMaxY(title.frame);
        self.sizeTableView.frame = frame;
        
        UIButton *spreadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        spreadButton.frame = CGRectMake(0, title.center.y - 22, self.view.frame.size.width, 44);
        [self.sizeTableView addSubview:spreadButton];
        [spreadButton setBackgroundColor:[UIColor clearColor]];
        [spreadButton addTarget:self action:@selector(showSizeTableImages:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *spreadImage = [UIImage imageNamed:@"spread2.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:spreadImage];
        imageView.frame = CGRectMake(self.view.frame.size.width - spreadImage.size.width - 15, (spreadButton.frame.size.height - spreadImage.size.height) / 2.0, spreadImage.size.width, spreadImage.size.height);
        [spreadButton addSubview:imageView];
        self.sizeTableSpreadImageView = imageView;
        
        [self showSizeTableImages:spreadButton];
    }
}

- (void)showSizeTableImages:(UIButton *)button
{
    NSArray *sizeImageUrl = [self.productInfo objectForKey:@"sizeTableUrl"];
    id pa = [self.productInfo objectForKey:@"parameter"];
    id txt = [self.productInfo objectForKey:@"sizeTableTxt"];
    if ([txt count] == 0) {
        if ([self.productInfo objectForKey:@"sizeTable"]) {
            sizeImageUrl = @[[NSString stringWithFormat:@"http://iphone.secoo.com/%@", [self.productInfo objectForKey:@"sizeTable"]]];
        }
        else{
            sizeImageUrl = nil;
        }
    }
    if (sizeImageUrl || pa || txt) {
        UIView *lastImageView;
        if (!_sizeTableSpreaded) {
            _sizeTableSpreaded = YES;
            self.sizeTableSpreadImageView.image = [UIImage imageNamed:@"spread.png"];
            [self addLineLabelWithView:self.sizeTableTitle upOrDown:1];
            CGFloat gap = 5;
            CGFloat origianlY = CGRectGetMaxY(self.sizeTableTitle.frame) + gap;
            CGFloat maxWidth = CGRectGetWidth(self.view.frame) - 2 * offsetX;
            UIImage *defaultImage = [UIImage imageNamed:@"loading.png"];
            
            for (int i = 0; i < [sizeImageUrl count]; ++i) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, origianlY, maxWidth, 400)];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                [imageView addGestureRecognizer:tap];
                imageView.image = defaultImage;
                [self.sizeTableViews addObject:imageView];
                [self.sizeTableView addSubview:imageView];
                imageView.tag = SizeTableBaseTag + i;
                origianlY = CGRectGetMaxY(imageView.frame) + gap;
                [self getImagesOfImageURL:[self convertToRealUrl:[sizeImageUrl objectAtIndex:i] ofsize:[self getIMageWidth]] forImageView:imageView];
                lastImageView = imageView;
            }
            [self generateSizeValueTable];
            [self generateParameterView];
            if (self.sizeTableParameterView) {
                lastImageView = self.sizeTableParameterView;
            }
            else if (self.sizeTableTexView){
                lastImageView = self.sizeTableTexView;
            }
        }
        else{
            _sizeTableSpreaded = NO;
            self.sizeTableSpreadImageView.image = [UIImage imageNamed:@"spread2.png"];
            [[self.sizeTableTitle viewWithTag:TitleLabelBaseTag] removeFromSuperview];
            
            NSArray *sizeImageUrl = [self.productInfo objectForKey:@"sizeTableUrl"];
            id txt = [self.productInfo objectForKey:@"sizeTableTxt"];
            if ([txt count] == 0) {
                if ([self.productInfo objectForKey:@"sizeTable"]) {
                    sizeImageUrl = @[[NSString stringWithFormat:@"http://iphone.secoo.com/%@", [self.productInfo objectForKey:@"sizeTable"]]];
                }
                else{
                    sizeImageUrl = nil;
                }
            }
            for (int i = 0; i < [sizeImageUrl count]; ++i) {
                UIView *view = [self.sizeTableView viewWithTag:SizeTableBaseTag + i];
                [view removeFromSuperview];
            }
            
            [self.sizeTableTexView removeFromSuperview];
            [self.sizeTableParameterView removeFromSuperview];
            lastImageView = self.sizeTableTitle;
        }
        
        if (lastImageView) {
            CGRect frame = self.sizeTableView.frame;
            frame.size.height = CGRectGetMaxY(lastImageView.frame);
            self.sizeTableView.frame = frame;
        }
        [self.view setNeedsLayout];
    }
}

- (void)generateParameterView
{
    NSArray *parameters = [self.productInfo objectForKey:@"parameter"];
    if ([parameters count] == 0) {
        return;
    }
    UIView *lastSizeView;
    if (self.sizeTableTexView) {
        lastSizeView = self.sizeTableTexView;
    }
    else if ([self.sizeTableViews lastObject]) {
        lastSizeView = [self.sizeTableViews lastObject];
    }
    else{
        lastSizeView = self.sizeTableTitle;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastSizeView.frame) + 5, CGRectGetWidth(self.view.frame), 100)];
    view.backgroundColor = [UIColor colorWithWhite:248 / 255.0 alpha:1.0];
    [self.sizeTableView addSubview:view];
    self.sizeTableParameterView = view;
    
    CGFloat startY = 20;
    UIView *lastView;
    for (int i = 0; i < [parameters count]; ++i) {
        NSDictionary *dict = [parameters objectAtIndex:i];
        UIView *subParaView = [self generateIndexView:[dict objectForKey:@"title"] selectedIndex:[[dict objectForKey:@"select"] integerValue] indexsTitles:[dict objectForKey:@"value"]];
        CGRect frame = subParaView.frame;
        frame.origin.y = startY;
        subParaView.frame = frame;
        [self.sizeTableParameterView addSubview:subParaView];
        lastView = subParaView;
        startY += CGRectGetHeight(frame) + 1;
    }
    
    if (lastView) {
        CGRect frame = self.sizeTableParameterView.frame;
        frame.size.height = CGRectGetMaxY(lastView.frame) + 20;
        self.sizeTableParameterView.frame = frame;
    }
}

- (UIView *)generateIndexView:(NSString *)title selectedIndex:(NSInteger)selectedIndex indexsTitles:(NSArray *)indexTitles
{
    CGFloat height = 32;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 50, 26)];
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    [view addSubview:titleLabel];
    titleLabel.font = titleFont;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    CGFloat rectangleWidth = (CGRectGetWidth(self.view.frame) - CGRectGetMaxX(titleLabel.frame) - 10 - 20);
    CGFloat rectangleHeight = 5;
    UIView *rectangleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, titleLabel.center.y - rectangleHeight / 2.0, rectangleWidth, rectangleHeight)];
    rectangleView.layer.borderWidth = 0.5;
    rectangleView.layer.borderColor = [UIColor colorWithRed:220.0 / 255.0 green:220.0 / 255.0 blue:222.0 / 255.0 alpha:1.0].CGColor;
    [view addSubview:rectangleView];
    
    CGFloat width = CGRectGetWidth(rectangleView.frame) / [indexTitles count];
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(selectedIndex * width, 0, width, CGRectGetHeight(rectangleView.frame))];
    [rectangleView addSubview:selectedView];
    selectedView.backgroundColor = [UIColor colorWithRed:197/255.0 green:173/255.0 blue:135/255.0 alpha:1];
    
    //add all the lower label
    UIFont *indexFont = [UIFont systemFontOfSize:12];
    CGSize size = [Utils getSizeOfString:@"卢" ofFont:indexFont withMaxWidth:50];
    for (int i = 0; i < [indexTitles count]; ++i) {
        CGFloat startX = CGRectGetMinX(rectangleView.frame) + i * width;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(rectangleView.frame) + 5, width, size.height + 1)];
        label.font = indexFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:68/255.0 alpha:1];
        [view addSubview:label];
        if ([indexTitles count] > i) {
            label.text = [indexTitles objectAtIndex:i];
        }
    }
    
    return view;
}

- (void)generateSizeValueTable
{
    NSArray *columns = [self.productInfo objectForKey:@"sizeTableTxt"];
    if ([columns count] == 0) {
        return;
    }
    CGFloat titleWidth = (self.view.frame.size.width - 2 * offsetX) / 8.0;
    CGFloat width = ((self.view.frame.size.width - 2 * offsetX) - titleWidth) /([columns count] - 1);
    
    UIView *lastSizeView;
    if ([self.sizeTableViews lastObject]) {
        lastSizeView = [self.sizeTableViews lastObject];
    }
    else{
        lastSizeView = self.sizeTableTitle;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(offsetX, CGRectGetMaxY(lastSizeView.frame) + 5, CGRectGetWidth(self.view.frame) - 2 * offsetX, 60)];
    view.backgroundColor = [UIColor whiteColor];
    [self.sizeTableView addSubview:view];
    self.sizeTableTexView = view;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame) , 40)];
    [self.sizeTableTexView addSubview:label];
    label.textColor = [UIColor colorWithWhite:75/255.0 alpha:1];
    label.text = @"尺码对照表";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    NSInteger rows = 0;
    if ([columns count] > 0) {
        rows = [[[columns objectAtIndex:0] objectForKey:@"value"] count];
    }
    
    UIView *lastView;
    CGFloat originY = CGRectGetMaxY(label.frame) + 5;
    for (int i = 0; i <= rows; ++i) {
        CGFloat height = 20;
        UIColor *color;
        if (i == 0) {
            height = 15;
            color = [UIColor colorWithWhite:171 / 255.0 alpha:1.0];
        }
        else{
            if (i % 2 != 0) {
                color = [UIColor whiteColor];
            }
            else{
                color = [UIColor colorWithWhite:248 / 255.0 alpha:1.0];
            }
        }
        UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth(view.frame), height)];
        rowView.backgroundColor = color;
        [self.sizeTableTexView addSubview:rowView];
        lastView = rowView;
        originY += CGRectGetHeight(rowView.frame);
        
        //add borderline
        UIColor *lineColor = [UIColor colorWithWhite:248 / 255.0 alpha:1.0];
        UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, CGRectGetHeight(rowView.frame))];
        [rowView addSubview:leftLineView];
        leftLineView.backgroundColor = lineColor;
        
        UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(rowView.frame) - 0.5, 0, 0.5, CGRectGetHeight(rowView.frame))];
        [rowView addSubview:rightLineView];
        rightLineView.backgroundColor = lineColor;
        if (i == rows) {
            UIView* bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(rowView.frame) - 0.5, CGRectGetWidth(rowView.frame), 0.5)];
            [rowView addSubview:bottomLineView];
            bottomLineView.backgroundColor = lineColor;
        }
        
        CGFloat startX = 0;
        for (int j = 0; j < [columns count]; ++j) {
            UILabel *label;
            NSString *text;
            if (j == 0) {
                //第一列的宽度与其他不同
                label = [[UILabel alloc] initWithFrame:CGRectMake(startX, 0, titleWidth, CGRectGetHeight(rowView.frame))];
                startX += titleWidth;
                label.textAlignment = NSTextAlignmentRight;
            }
            else{
                label = [[UILabel alloc] initWithFrame:CGRectMake(startX, 0, width, CGRectGetHeight(rowView.frame))];
                startX += width;
                label.textAlignment = NSTextAlignmentCenter;
            }
            NSDictionary *dict = [columns objectAtIndex:j];
            if (i == 0) {
                text = [dict objectForKey:@"title"];
            }
            else{
                text = [[dict objectForKey:@"value"] objectAtIndex:i - 1];
            }
            
            [rowView addSubview:label];
            label.text = text;
            label.font = [UIFont systemFontOfSize:12];
        }
    }
    
    if (lastView) {
        CGRect frame = self.sizeTableTexView.frame;
        frame.size.height = CGRectGetMaxY(lastView.frame);
        self.sizeTableTexView.frame = frame;
    }
}

@end

#pragma mark --
#pragma mark -- washing tips --
@implementation ProductInfoViewController (WashingTips)

- (void)setUpWashingTipsView
{
    NSArray *washingTips = [self.productInfo objectForKey:@"washingTips"];
    if ([washingTips count] == 0) {
        return;
    }
    UIView *lastView;
    if (self.sizeTableView != nil) {
        lastView = self.sizeTableView;
    }
    else if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView){
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame), CGRectGetWidth(self.view.frame), 100)];
    [self.scrollView addSubview:view];
    self.washingTipsView = view;
    self.washingTipsView.backgroundColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [Utils getSizeOfString:@"洗涤说明" ofFont:font withMaxWidth:100];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(TitleOffsetX, 16, 100, size.height + 1)];
    label.font = font;
    label.text = @"洗涤说明";
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 16 + 12 + CGRectGetHeight(label.frame));
    [view addSubview:headButton];
    [headButton addSubview:label];
    headButton.backgroundColor = [UIColor whiteColor];
    [headButton addTarget:self action:@selector(washingHeadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.washingHeadButton = headButton;
    
    UIImage *spreadImage = [UIImage imageNamed:@"spread2.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:spreadImage];
    imageView.frame = CGRectMake(self.view.frame.size.width - spreadImage.size.width - 15, (headButton.frame.size.height - spreadImage.size.height) / 2.0, spreadImage.size.width, spreadImage.size.height);
    [headButton addSubview:imageView];
    self.washingSpreadImageView = imageView;
    
    CGRect frame = self.washingTipsView.frame;
    frame.size.height = CGRectGetHeight(self.washingHeadButton.frame);
    self.washingTipsView.frame = frame;
}

- (void)washingHeadButtonClicked:(UIButton *)button
{
    NSArray *washingTips = [self.productInfo objectForKey:@"washingTips"];
    if ([washingTips count] == 0) {
        return;
    }
    
    UIView *lastView = nil;
    if (_washingButtonSpreaded) {
        _washingButtonSpreaded = NO;
        self.washingSpreadImageView.image = [UIImage imageNamed:@"spread2.png"];
        for (int i = 0; i < [washingTips count]; ++i) {
            UIView *view = [self.washingTipsView viewWithTag:WashingBaseTag + i];
            [view removeFromSuperview];
        }
        UIView *lineView = [self.washingTipsView viewWithTag:100];
        [lineView removeFromSuperview];
        lastView = self.washingHeadButton;
    }
    else{
        _washingButtonSpreaded = YES;
        self.washingSpreadImageView.image = [UIImage imageNamed:@"spread.png"];
        
        //添加黑线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, CGRectGetHeight(self.washingHeadButton.frame), CGRectGetWidth(self.view.frame) - offsetX, 0.5)];
        [self.washingTipsView addSubview:lineView];
        lineView.tag = 100;
        lineView.backgroundColor = [UIColor colorWithWhite:171/255.0 alpha:1];
        
        UIImage *image = [UIImage imageNamed:@"loading.png"];
        for (int i = 0; i < [washingTips count]; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
            
            if (lastView == nil) {
                imageView.frame = CGRectMake(offsetX, CGRectGetMaxY(self.washingHeadButton.frame), CGRectGetWidth(self.view.frame) - 2 * offsetX, image.size.height);
            }
            else{
                imageView.frame = CGRectMake(offsetX, CGRectGetMaxY(lastView.frame), CGRectGetWidth(self.view.frame) - 2 * offsetX, image.size.height);
            }
            imageView.tag = WashingBaseTag + i;
            [self.washingTipsView addSubview:imageView];
            lastView = imageView;
            NSString *imageUrl = [washingTips objectAtIndex:i];
            [self getImagesOfImageURL:[self convertToRealUrl:imageUrl ofsize:[self getIMageWidth]] forImageView:imageView];
        }
    }
    CGRect frame = self.washingTipsView.frame;
    frame.size.height = CGRectGetMaxY(lastView.frame);
    self.washingTipsView.frame = frame;
    [self.view setNeedsLayout];
}

@end

@implementation ProductInfoViewController (BrandStory)

- (void)setUpBrandStoryView
{
    NSDictionary *brandStoryInfo = [self.productInfo objectForKey:@"brandInfo"];
    NSString *titleStr = [brandStoryInfo objectForKey:@"title"];
    NSString *content = [brandStoryInfo objectForKey:@"content"];
    NSString *image = [brandStoryInfo objectForKey:@"image"];
    if ((titleStr == nil || [titleStr isEqualToString:@""]) && (content == nil || [content isEqualToString:@""]) && (image == nil || [image isEqualToString:@""])) {
        return;
    }
    
    UIView *lastView;
    if (self.maintanenceView) {
        lastView = self.maintanenceView;
    }
    else if (self.washingTipsView){
        lastView = self.washingTipsView;
    }
    else if (self.sizeTableView){
        lastView = self.sizeTableView;
    }
    else if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView){
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame), CGRectGetWidth(self.view.frame), 500)];
    self.brandStoryView = view;
    [self.scrollView addSubview:view];
    self.brandStoryView.backgroundColor = [UIColor whiteColor];
    
    CGFloat maxWidth = CGRectGetWidth(self.view.frame) - offsetX;
    UIFont *font = [UIFont systemFontOfSize:18];
    NSString *str = @"品牌故事";
    CGSize labelSize = [Utils getSizeOfString:str ofFont:font withMaxWidth:maxWidth];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(TitleOffsetX, 16, 120, labelSize.height + 1)];
    title.text = str;
    
    UIButton *spreadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    spreadButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 16 + 12 + CGRectGetHeight(title.frame));
    [self.brandStoryView addSubview:spreadButton];
    [spreadButton setBackgroundColor:[UIColor clearColor]];
    [spreadButton addTarget:self action:@selector(showBrandImages:) forControlEvents:UIControlEventTouchUpInside];
    [spreadButton addSubview:title];
    self.brandHeadButton = spreadButton;
    
    UIImage *spreadImage = [UIImage imageNamed:@"spread2.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:spreadImage];
    imageView.frame = CGRectMake(self.view.frame.size.width - spreadImage.size.width - 15, (spreadButton.frame.size.height - spreadImage.size.height) / 2.0, spreadImage.size.width, spreadImage.size.height);
    [spreadButton addSubview:imageView];
    self.brandSpreadImageView = imageView;
    
    CGRect frame = self.brandStoryView.frame;
    frame.size.height = CGRectGetMaxY(title.frame) + 10;
    self.brandStoryView.frame = frame;
    
    //默认展开
    [self showBrandImages:spreadButton];
}

- (void)showBrandImages:(UIButton *)button
{
    NSDictionary *brandStoryInfo = [self.productInfo objectForKey:@"brandInfo"];
    CGFloat gap = 5;
    CGFloat origianlY = CGRectGetMaxY(self.brandHeadButton.frame) + gap;
    if ([brandStoryInfo count] > 0) {
        UIView *lastImageView;
        if (!_brandStorySpreaded) {
            _brandStorySpreaded = YES;
            self.brandSpreadImageView.image = [UIImage imageNamed:@"spread.png"];
            [self addLineLabelWithView:self.brandHeadButton upOrDown:1];
            CGFloat maxWidth = CGRectGetWidth(self.view.frame) - 2 * offsetX;
            UIImage *defaultImage = [UIImage imageNamed:@"loading.png"];
            
            id imageUrls = [brandStoryInfo objectForKey:@"image"];
            if (![imageUrls isKindOfClass:[NSArray class]] && imageUrls != nil) {
                imageUrls = @[imageUrls];
            }
            for (int i = 0; i < [imageUrls count]; ++i) {
                NSString *url = [imageUrls objectAtIndex:i];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, origianlY, maxWidth, defaultImage.size.height)];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                [imageView addGestureRecognizer:tap];
                imageView.image = defaultImage;
                [self.brandImageViews addObject:imageView];
                [self.brandStoryView addSubview:imageView];
                imageView.tag = BrandStoryBaseTag + i;
                origianlY = CGRectGetMaxY(imageView.frame) + gap;
                [self getImagesOfImageURL:[self convertToRealUrl:url ofsize:[self getIMageWidth]] forImageView:imageView];
                lastImageView = imageView;
            }
            // add title
            NSString *title = [brandStoryInfo objectForKey:@"title"];
            if (title != nil && ![title isEqualToString:@""]) {
                UIFont *titleFont = [UIFont systemFontOfSize:16];
                CGSize size = [Utils getSizeOfString:title ofFont:titleFont withMaxWidth:CGRectGetWidth(self.view.frame) - 2 * offsetX];
                UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, origianlY, CGRectGetWidth(self.view.frame) - 2 * offsetX, size.height + 1)];
                titelLabel.text = title;
                titelLabel.font = titleFont;
                titelLabel.tag = [imageUrls count] + BrandStoryBaseTag;
                titelLabel.textAlignment = NSTextAlignmentCenter;
                lastImageView = titelLabel;
                [self.brandStoryView addSubview:titelLabel];
            }
            //end adding title
            
            //add context
            NSString *content = [brandStoryInfo objectForKey:@"content"];
            if (content != nil && ![content isEqualToString:@""]) {
                UIFont *contentFont = [UIFont systemFontOfSize:14];
                CGSize size = [Utils getSizeOfString:content ofFont:contentFont withMaxWidth:CGRectGetWidth(self.view.frame) - 2 * offsetX];
                UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 5 + CGRectGetMaxY(lastImageView.frame), CGRectGetWidth(self.view.frame) - 2 * offsetX, size.height + 1)];
                contentLabel.text = content;
                contentLabel.font = contentFont;
                contentLabel.textColor = [UIColor colorWithWhite:68/255.0 alpha:1];
                contentLabel.tag = [imageUrls count] + 1 + BrandStoryBaseTag;
                contentLabel.textAlignment = NSTextAlignmentLeft;
                contentLabel.numberOfLines = 0;
                contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
                lastImageView = contentLabel;
                [self.brandStoryView addSubview:contentLabel];
            }
            //end adding context
            
        }
        else{
            _brandStorySpreaded = NO;
            self.brandSpreadImageView.image = [UIImage imageNamed:@"spread2.png"];
            [[self.brandHeadButton viewWithTag:TitleLabelBaseTag] removeFromSuperview];
            id imageUrls = [brandStoryInfo objectForKey:@"image"];
            if (![imageUrls isKindOfClass:[NSArray class]] && imageUrls != nil) {
                imageUrls = @[imageUrls];
            }
            for (int i = [imageUrls count] + 1; i >= 0; --i) {
                UIView *view = [self.brandStoryView viewWithTag:i + BrandStoryBaseTag];
                [view removeFromSuperview];
            }
            lastImageView = self.brandHeadButton;
        }
        
        if (lastImageView) {
            CGRect frame = self.brandStoryView.frame;
            frame.size.height = CGRectGetMaxY(lastImageView.frame) + 10;
            self.brandStoryView.frame = frame;
        }
        [self.view setNeedsLayout];
    }
}

@end

@implementation ProductInfoViewController (MaintenanceImageView)

- (void)setUpMaintanenceView
{
    NSArray *array = [self.productInfo objectForKey:@"maintenanceTips"];
    if ([array count] == 0) {
        return;
    }
    UIView *lastView;
    if (self.washingTipsView){
        lastView = self.washingTipsView;
    }
    else if(self.sizeTableView){
        lastView = self.sizeTableView;
    }
    else if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView){
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame), CGRectGetWidth(self.view.frame), 500)];
    self.maintanenceView = view;
    view.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [Utils getSizeOfString:@"保养说明" ofFont:font withMaxWidth:100];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(TitleOffsetX, 16, 100, size.height + 1)];
    label.font = font;
    label.text = @"保养说明";
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 16 + 12 + CGRectGetHeight(label.frame));
    [view addSubview:headButton];
    [headButton addSubview:label];
    [headButton addTarget:self action:@selector(showMaintanenceImages:) forControlEvents:UIControlEventTouchUpInside];
    self.maintanenceButton = headButton;
    
    UIImage *spreadImage = [UIImage imageNamed:@"spread2.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:spreadImage];
    imageView.frame = CGRectMake(self.view.frame.size.width - spreadImage.size.width - 15, (headButton.frame.size.height - spreadImage.size.height) / 2.0, spreadImage.size.width, spreadImage.size.height);
    [headButton addSubview:imageView];
    self.maintanenceSpreadImageView = imageView;
}

- (void)showMaintanenceImages:(UIButton *)button
{
    NSArray *maintanenceTips = [self.productInfo objectForKey:@"maintenanceTips"];
    if ([maintanenceTips count] == 0) {
        return;
    }
    CGFloat marginX = 5;
    UIView *lastView = nil;
    if (_maintanenceSpreaded) {
        _maintanenceSpreaded = NO;
        self.maintanenceSpreadImageView.image = [UIImage imageNamed:@"spread2.png"];
        for (int i = 0; i < [maintanenceTips count]; ++i) {
            UIView *view = [self.maintanenceView viewWithTag:MaintenanceBaseTag + i];
            [view removeFromSuperview];
        }
        [[self.maintanenceView viewWithTag:100] removeFromSuperview];
        lastView = self.maintanenceButton;
    }
    else{
        _maintanenceSpreaded = YES;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, CGRectGetHeight(self.maintanenceButton.frame), CGRectGetWidth(self.view.frame) - offsetX, 0.5)];
        [self.maintanenceView addSubview:lineView];
        lineView.tag = 100;
        lineView.backgroundColor = [UIColor colorWithWhite:171/255.0 alpha:1];
        
        self.maintanenceSpreadImageView.image = [UIImage imageNamed:@"spread.png"];
        UIImage *image = [UIImage imageNamed:@"loading.png"];
        for (int i = 0; i < [maintanenceTips count]; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            if (lastView == nil) {
                imageView.frame = CGRectMake(marginX, CGRectGetMaxY(self.maintanenceButton.frame), CGRectGetWidth(self.view.frame) - 2 * marginX, image.size.height);
            }
            else{
                imageView.frame = CGRectMake(marginX, CGRectGetMaxY(lastView.frame), CGRectGetWidth(self.view.frame) - 2 * marginX, image.size.height);
            }
            imageView.tag = MaintenanceBaseTag + i;
            [self.maintanenceView addSubview:imageView];
            lastView = imageView;
            NSString *imageUrl = [maintanenceTips objectAtIndex:i];
            [self getImagesOfImageURL:[self convertToRealUrl:imageUrl ofsize:[self getIMageWidth]] forImageView:imageView];
        }
    }
    
    if (lastView) {
        CGRect frame = self.maintanenceView.frame;
        frame.size.height = CGRectGetMaxY(lastView.frame);
        self.maintanenceView.frame = frame;
    }
    [self.view setNeedsLayout];
}

@end


@implementation ProductInfoViewController (Recommendation)

//get the recommended products, and display them to users if any.
- (void)getRecommenedProducts
{
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak ProductInfoViewController *weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=goods&method=recommend&v=1.0&client=iphone&source=staticProduct&productId=%@", self.productID];
    NSString *compatibelURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session startConnectionToURL:compatibelURL completion:^(NSData *data, NSError *error) {
        typeof(self) stongSelf = weakSelf;
        if (error == nil) {
            if (data) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                        if ([[jsonResponse objectForKey:@"result"] isEqualToString:@"sucess"]) {
                            NSString *str = [jsonResponse objectForKey:@"info"];
                            //NSLog(@"%@", str);
                            NSString *strippedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
                            //NSLog(@"%@", strippedStr);
                            NSData *data = [strippedStr dataUsingEncoding:NSUTF8StringEncoding];
                            NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                            stongSelf.recommendedProducts = jsonArray;
                            if (jsonArray.count > 0) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [stongSelf setUpRecommendedViewWith];
                                });
                            }
                        }
                    }
                }
                else{
                    NSLog(@"parsing recommened data error");
                }
            }
            else{
                NSLog(@"no recommended products");
            }
        }
        else{
            NSLog(@"geting recommend data error");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view setNeedsLayout];
        });
    }];
}

- (void)setUpRecommendedViewWith
{
    //areaType, imgUrl, productId, orgCode, productName, marketPrice, secooPrice
    if (![self.recommendedProducts isKindOfClass:[NSArray class]]) {
        return;
    }
    
    UIView *lastView;
    if (self.brandStoryView) {
        lastView = self.brandStoryView;
    }
    else if (self.brandStoryView){
        lastView = self.brandStoryView;
    }
    else if (self.washingTipsView){
        lastView = self.washingTipsView;
    }
    else if (self.sizeTableView){
        lastView = self.sizeTableView;
    }
    else if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView){
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame), self.view.frame.size.width, 120)];
    [self.scrollView addSubview:view];
    self.recommendationView = view;
    view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    NSString *str = @"相关推荐 ";
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _TITLT_LABEL_HEIGHT_)];
    title.text = str;
    title.textColor = [UIColor lightGrayColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.recommendationView addSubview:title];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, title.frame.size.height/2.0, SCREEN_WIDTH/3.0, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [title addSubview:lineLabel];
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2.0/3.0, title.frame.size.height/2.0, SCREEN_WIDTH/3.0, 0.5)];
    lineLabel2.backgroundColor = [UIColor lightGrayColor];
    [title addSubview:lineLabel2];

    CGFloat height = 80;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), CGRectGetWidth(self.view.frame), height)];
    [self.recommendationView addSubview:scrollView];
    self.recommendationScrollView = scrollView;
    
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    CGFloat gap = 5;
    NSInteger proCount = [self.recommendedProducts count];
    
    scrollView.contentSize = CGSizeMake((gap + height) * proCount + gap, height);
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"place_holder_160" ofType:@"png"]];
    
    for (int i = 0; i < proCount; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(gap * (i + 1) + i * height, 0, height, height)];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [imageView addGestureRecognizer:tap];
        imageView.image = image;
        imageView.tag = ScrollImageViewTag + i;
        [tap addTarget:self action:@selector(recommendButtonPressed:)];
        [scrollView addSubview:imageView];
    }
    
    
    CGRect frame = self.recommendationView.frame;
    frame.size.height = CGRectGetMaxY(scrollView.frame) + 23;
    self.recommendationView.frame = frame;
    [self getImageForVisibleCell];
}

- (void)recommendButtonPressed:(UIGestureRecognizer *)tap
{
    UIView *sender = tap.view;
    NSInteger tag = sender.tag - ScrollImageViewTag;
    if (tag < [self.recommendedProducts count]) {
        NSDictionary *dict = [self.recommendedProducts objectAtIndex:tag];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductInfoViewController *productVC = [storyboard instantiateViewControllerWithIdentifier:@"ProductInfoViewController"];
        productVC.productID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"productId"]];
        productVC.title = @"商品详情";
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

- (void)getImageForVisibleCell
{
    CGFloat x = self.recommendationScrollView.contentOffset.x;
    CGFloat height = 80;
    CGFloat gap = 20;
    
    int minIndex = floorf(x / (height + gap));
    int maxIndex = floorf((x + self.view.frame.size.width - 5) / (height + gap)) + 1;
    for (int i =  minIndex; i <= maxIndex; ++i) {
        UIImageView *imageView = (UIImageView *)[self.recommendationScrollView viewWithTag:i + ScrollImageViewTag];
        if (imageView && (i < [self.recommendedProducts count])) {
            NSDictionary *dict = [self.recommendedProducts objectAtIndex:i];
            NSString *imageUrl = [dict objectForKey:@"imgUrl"];
            [self getImagesOfImageURL:[self convertToRealUrl:imageUrl ofsize:160] forImageView:imageView];
        }
    }
    
}

#pragma mark --
#pragma mark --

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.recommendationScrollView && decelerate == NO) {
        [self getImageForVisibleCell];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.recommendationScrollView) {
        [self getImageForVisibleCell];
    }
}

@end

@implementation ProductInfoViewController (ProductService)

- (void)setUpProductServiceView
{
    UIView *lastView;
    if (self.recommendationView) {
        lastView = self.recommendationView;
    }
    else if (self.brandStoryView){
        lastView = self.brandStoryView;
    }
    else if (self.maintanenceView) {
        lastView = self.maintanenceView;
    }
    else if (self.washingTipsView){
        lastView = self.washingTipsView;
    }
    else if (self.sizeTableView){
        lastView = self.sizeTableView;
    }
    else if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView){
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    
    ProductServiceView *productServiceView = [[ProductServiceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame)+10, SCREEN_WIDTH, 100)];
    productServiceView.backgroundColor = [UIColor whiteColor];
    self.productServiceView = productServiceView;
    [self.scrollView addSubview:productServiceView];
}

- (void)setProductServiceViewFrame
{
    UIView *lastView;
    if (self.recommendationView) {
        lastView = self.recommendationView;
    }
    else if (self.brandStoryView){
        lastView = self.brandStoryView;
    }
    else if (self.maintanenceView) {
        lastView = self.maintanenceView;
    }
    else if (self.washingTipsView){
        lastView = self.washingTipsView;
    }
    else if (self.sizeTableView){
        lastView = self.sizeTableView;
    }
    else if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView){
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    
    CGRect rect = self.productServiceView.frame;
    rect.origin.y = CGRectGetMaxY(lastView.frame) + 10;
    self.productServiceView.frame = rect;
}

@end

@implementation ProductInfoViewController (InteractionWithJS)

- (void)showLogInViewControllerWithData:(id)data withDelegate:(id)delegate
{/*
    NSArray *array = [data componentsSeparatedByString:@"$_$"];
    if ([array count] == 4) {
        if ([[array objectAtIndex:0] isEqualToString:@"objc:sendUpkInfo"] && ([[array objectAtIndex:1] isEqualToString:@"Product_AddToFavorite"] || [[array objectAtIndex:1] isEqualToString:@"Product_AddToCart"])) {
            if ([[array objectAtIndex:2] isEqualToString:@"false"]) {
                NSString *url = [array objectAtIndex:3];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LogInViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
                loginVC.url = url;
                loginVC.delegate = delegate;
                UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [naviVC.navigationBar customNavBar];
                [self presentViewController:naviVC animated:YES completion:nil];
            }
            else if ([[array objectAtIndex:2] isEqualToString:@"true"]){
                NSString *upKey = [array objectAtIndex:3];
                [UserInfoManager setUserUpKey:upKey];
                [UserInfoManager setLogState:YES];
                [ManagerDefault standardManagerDefaults].userLogin = YES;
                [self addProductToFavorite];
            }
        }
    }*/
}

#pragma mark - 去购物车页面
- (void)gotoProductCartWrap
{
    [self tappedCancel];
    [self.navigationController setToolbarHidden:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CartViewController *cartVC = [storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark - 加入购物车
- (void)addProductToCart
{
    //友盟统计
    [MobClick event:@"iOS_gouwuche_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_gouwuche_uv"];
    
    int num = [[CartItemAccessor sharedInstance] numberOfCartItemsForProductId:self.productID] + 1;
    if (_inventoryNumber > 0 && _inventoryNumber < num) {
        [MBProgressHUD showError:@"对不起，库存不足，不能添加" toView:self.view];
        return;
    }
    
    if ((self.colorView && !self.colorImageUrl) || (self.sizeView && !self.sizePid)) {
        //弹出
        [self showColorAndSizeView];
    } else {
        [self tappedCancel];
        [self.addToCartButton setTitle:@"连接中..." forState:UIControlStateNormal];
        NSString *level = [self.productInfo objectForKey:@"level"];
        NSString *secooPrice = [self.productInfo objectForKey:@"secooPrice"];
        NSString *refPrice = [self.productInfo objectForKey:@"refPrice"];
        NSString *cod = [self.productInfo objectForKey:@"productCode"];
        NSString *areaType = [self.productInfo objectForKey:@"areaType"];
        
        if (!self.colorView && !self.sizeView) {
            //add to cart with native technology
            // iphone.secoo.com/appservice/iphone/cart_cartGet.action?productInfo=&upkey=&areaType=
            NSString *pname = [NSString stringWithFormat:@"%@", [self.productInfo objectForKey:@"productName"]];
            NSString *pid = [NSString stringWithFormat:@"%@", [self.productInfo objectForKey:@"productId"]];
            NSString *imgURL = [self convertToRealUrl:[self.showImagesUrls firstObject] ofsize:80];
            [self insertToPersistentStoreWithProductName:pname productID:pid imageURL:imgURL levle:level secooPrice:secooPrice refPrice:refPrice cod:cod areaType:areaType color:nil size:nil];
        } else {
            if (self.colorView && !self.sizeView) {
                NSString *pname = [NSString stringWithFormat:@"%@", [self.productInfo objectForKey:@"productName"]];
                NSString *pid = [NSString stringWithFormat:@"%@", [self.productInfo objectForKey:@"productId"]];
                NSString *imgURL = [self convertToRealUrl:self.colorImageUrl ofsize:80];
                
                NSString *color = nil;
                if (self.selectColorIndex >= 0 && self.colorArray) {
                    color = [[self.colorArray objectAtIndex:self.selectColorIndex] objectForKey:@"specvalue"];
                }
                
                [self insertToPersistentStoreWithProductName:pname productID:pid imageURL:imgURL levle:level secooPrice:secooPrice refPrice:refPrice cod:cod areaType:areaType color:color size:nil];
            }
            else if (self.sizeView) {
                NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/query_goods.action?productId=%@", self.sizePid];
                LGURLSession *session = [[LGURLSession alloc] init];
                __weak ProductInfoViewController *weakSelf = self;
                [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
                    if (!error) {
                        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                        if (!error) {
                            NSDictionary *rp_result = [dictionary objectForKey:@"rp_result"];
                            NSString *pname = [NSString stringWithFormat:@"%@", [rp_result objectForKey:@"productName"]];
                            NSString *pid = [NSString stringWithFormat:@"%@",[rp_result objectForKey:@"productId"]];
                            NSString *imgURL = nil;
                            if (weakSelf.colorView) {
                                imgURL = [weakSelf convertToRealUrl:weakSelf.colorImageUrl ofsize:80];
                            } else {
                                imgURL = [weakSelf convertToRealUrl:[[rp_result objectForKey:@"showPicture"] firstObject] ofsize:80];
                            }
                            
                            NSString *color = nil, *size = nil;
                            if (self.selectColorIndex >= 0 && self.colorArray) {
                                color = [[self.colorArray objectAtIndex:self.selectColorIndex] objectForKey:@"specvalue"];
                            }
                            
                            if (self.selectSizeIndex >= 0 && self.sizeArray) {
                                size = [[self.sizeArray objectAtIndex:self.selectSizeIndex] objectForKey:@"specvalue"];
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf insertToPersistentStoreWithProductName:pname productID:pid imageURL:imgURL levle:level secooPrice:secooPrice refPrice:refPrice cod:cod areaType:areaType color:color size:size];
                            });
                        }
                    }
                }];
                
            } else {
                NSLog(@"add to product cartwarp error!");
            }
        }
    }
}

- (void)showColorAndSizeView
{//弹出尺码和颜色
    if (!self.backgroundView) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.toolBar.bounds.size.height)];
        self.backgroundView = backgroundView;
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [backgroundView addGestureRecognizer:tapGesture];
        
        UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 130)];
        self.showView = showView;
        showView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
        [showView addGestureRecognizer:gesture];
        [backgroundView addSubview:showView];
        
        //添加颜色和尺码
        if (self.colorView) {
            NSArray *cArray = self.colorView.colorArray;
            ProductColorAndSizeView *cView = [[ProductColorAndSizeView alloc] initWithFrame:CGRectMake(10,10,SCREEN_WIDTH-20,130) colorArray:cArray delegate:self selectIndex:self.selectColorIndex];
            self.colorView2 = cView;
            [showView addSubview:cView];
        }
        
        if (self.sizeView) {
            NSArray *sArray = self.sizeView.sizeArray;
            ProductColorAndSizeView *sView = [[ProductColorAndSizeView alloc] initWithFrame:CGRectMake(10, self.colorView2?(CGRectGetMaxY(self.colorView2.frame)+15):10, SCREEN_WIDTH-20, 130) sizeArray:sArray delegate:self selectIndex:self.selectSizeIndex];
            self.sizeView2 = sView;
            [showView addSubview:sView];
        }
        
        CGRect frame = showView.frame;
        if (self.sizeView2) {
            frame.size.height = CGRectGetMaxY(self.sizeView2.frame) + 10;
        } else if (self.colorView2) {
            frame.size.height = CGRectGetMaxY(self.colorView2.frame) + 10;
        }
        showView.frame = frame;
        
        [UIView animateWithDuration:.3f animations:^{
            CGRect rect = showView.frame;
            rect.origin.y = SCREEN_HEIGHT - rect.size.height - self.toolBar.bounds.size.height;
            showView.frame = rect;
        }];
        
        [[[[UIApplication sharedApplication] delegate] window].rootViewController.view addSubview:backgroundView];
    }
}

- (void)tappedCancel
{
    self.colorView2 = nil;
    self.sizeView2 = nil;
    if (self.backgroundView) {
        [UIView animateWithDuration:.3f animations:^{
            [self.showView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.backgroundView removeFromSuperview];
            }
        }];
    }
}


- (void)insertToPersistentStoreWithProductName:(NSString *)pname productID:(NSString *)pid imageURL:(NSString *)imgURL levle:(NSString *)level secooPrice:(NSString *)secooPrice refPrice:(NSString *)refPrice cod:(NSString *)cod areaType:(NSString *)areaType color:(NSString *)color size:(NSString *)size
{
    NSString *proInfo = [Utils cartProductInfo];
    //proInfo = [proInfo stringByAppendingString:@",\"aid\":\"1\""];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/cart_cartAdd.action?productInfo=%@&areaType=%@&productId=%@", [proInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], areaType, pid];
    if ([UserInfoManager getUserUpKey] && [UserInfoManager didSignIn]) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&upkey=%@", [UserInfoManager getUserUpKey]]];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    LGURLSession *session = [[LGURLSession alloc] init];
    __weak typeof(ProductInfoViewController *) weakSelf = self;
    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (weakSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.addToCartButton setTitle:@"加入购物袋" forState:UIControlStateNormal];
            });

            if (error == nil) {
                NSError *jsonError;
                id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError == nil) {
                    NSDictionary *dict = [jsonResponse objectForKey:@"rp_result"];
                    if ([[dict objectForKey:@"recode"] integerValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //加入购物车
                            [MBProgressHUD showSuccess:@"成功加入购物车" toView:weakSelf.view];
                            [[CartItemAccessor sharedInstance] addItemWithID:pid productName:pname price:[[weakSelf.productInfo objectForKey:@"refPrice"] integerValue] areaType:[areaType integerValue] level:level color:color size:size upKey:nil type:0];
                        });
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //加入购物车
                            [MBProgressHUD showSuccess:[dict objectForKey:@"errMsg"] toView:weakSelf.view];
                        });
                    }
                }
            }
            else{
                NSLog(@"add to cart error");
            }
        }
    }];
}


#pragma mark --------------InteractingViewControllerDelegate ----------------
- (void)didLogInFrom:(NSString*)event
{
    //NSLog(@"did log in");
    if ([event isEqualToString:@"Product_AddToFavorite"]) {
        [self addProductToFavorite];
    }
}


@end


@implementation ProductInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectSizeIndex = -1;
    self.selectColorIndex = -1;
    _notAailable = NO;
    _isFavorite = NO;
    _productDetailedViewSpreaded = NO;
    _maintanenceSpreaded = NO;
    _brandStorySpreaded = NO;
    _sizeTableSpreaded = NO;
    _specificationSpreaded = NO;
    _washingButtonSpreaded = NO;
    _rotationNumber = 0;
    _inventoryNumber = -1;
    [self getInventoryNumberAndRealTimePrice: self.productID];
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCartButtonTitle:) name:ORDER_NUMBER_NOTIFACATION object:nil];
    self.delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    [self setUpToolBar];
    
    //设置返回按钮
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = back;
    
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_prodDetail"] style:UIBarButtonItemStyleBordered target:self action:@selector(shareMethod:)];
    self.navigationItem.rightBarButtonItem = shareBarButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self startActivityView];

//    NSString *url = [NSString stringWithFormat:@"http://192.168.200.145:8082/appservice/iphone/query_goods.action?productId=%@", self.productID];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/query_goods.action?productId=%@", self.productID];

    ProductURLSession *productSession = [[ProductURLSession alloc] init];
    productSession.delegate = self;
    [productSession startConnectionToURL:url];
    _productOrigin = ProductOriginNone;
    [self setUpIntroView];
    
    [self getSpecilaProductInfo];
    [self checkFavorite];
    _imageBrowsType = ImageBrowserNone;
    self.scrollView.delegate = self;
    _originalOffsetY = -64;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    //add button to scroll to top
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - arrowImage.size.width - 20, CGRectGetHeight(self.view.frame) - arrowImage.size.height - 20 - 44, arrowImage.size.width, arrowImage.size.height)];
//    [self.view addSubview:button];
//    button.backgroundColor = [UIColor clearColor];
//    [self.view bringSubviewToFront:button];
//    self.scrollToTopButton = button;
//
//    [button setImage:_IMAGE_WITH_NAME(@"backtotop") forState:UIControlStateNormal];
//
//    button.alpha = 0.0;
//    //[button setImage:arrowImage forState:UIControlStateNormal];
//
//    [button addTarget:self action:@selector(scrollToBack:) forControlEvents:UIControlEventTouchUpInside];
//    
    //友盟统计 到达详情页
    [MobClick event:@"iOS_item_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_item_uv"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setToolbarHidden:NO];
    
    //TODO:delete when upgrade
    [ManagerDefault standardManagerDefaults].productInfoViewController = self;
    
    //友盟统计
    [MobClick beginLogPageView:@"prodDetail"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setToolbarHidden:YES];
    [self.activityIndicatorView removeFromSuperview];
    
    //友盟统计
    [MobClick endLogPageView:@"prodDetail"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.productInfo) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setProductDetailedInfoViewFrame];
            [self setSpecificationViewFrame];
            
            [self setSizeTableFrame];//尺寸说明
            [self setWashingTipsViewFrame];//洗涤
            [self setUpMaintanenceFrames];//养护服务
            [self setFramesOfBrandImages];//品牌故事
            
            [self setFrameOfRecommendationView];//相关推荐
            [self setProductServiceViewFrame];//正 7 保 鉴
        }];
        
        CGSize contentSize = self.scrollView.contentSize;
        contentSize.height = CGRectGetMaxY(self.productServiceView.frame) + 10;
        self.scrollView.contentSize = contentSize;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //NSLog(@"dealloc product info view controller");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ORDER_NUMBER_NOTIFACATION object:nil];
    for (NSString *url in self.downloadingImages) {
        [[ImageDownloaderManager sharedInstance] cancelSession:url];
    }
    self.scrollView.delegate = nil;
    self.recommendationScrollView.delegate = nil;
}

- (void)startActivityView
{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    activityIndicatorView.frame = CGRectMake(0, 0, 60, 60);
    activityIndicatorView.layer.cornerRadius = 5;
    activityIndicatorView.center = self.view.center;
    [activityIndicatorView startAnimating];
    activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView = activityIndicatorView;
    [self.view addSubview:activityIndicatorView];
    [self.view bringSubviewToFront:activityIndicatorView];
}

- (void)scrollToBack:(UIButton *)button
{
    [self.scrollView setContentOffset:CGPointMake(0, _originalOffsetY) animated:YES];
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    //[self.navigationController.toolbar setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

- (void)showStatusBar
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (BOOL)prefersStatusBarHidden
{
    if (self.cycleScrollVC) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark - set toolBar
- (void)setUpToolBar
{
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64, self.view.frame.size.width, 64)];//self.navigationController.toolbar;
    if (!_IOS_7_LATER_) {
        toolView.frame = CGRectMake(0, self.view.frame.size.height - 64 - 44, self.view.frame.size.width, 64);
    }
    [self.view addSubview:toolView];
    toolView.backgroundColor = [UIColor whiteColor];
    self.toolBar = toolView;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(toolView.frame), 1)];
    [toolView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithWhite:171.0 / 255.0 alpha:1.0];
//    UIView *backgroundView = [[UIView alloc] initWithFrame:toolView.bounds];
//    backgroundView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
//    [toolView addSubview:backgroundView];
    
    NSString *orderNumber = [ManagerDefault standardManagerDefaults].orderNumber;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, (CGRectGetHeight(toolView.frame) - 40) / 2.0, 44, 40);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    UIImage *image = _IMAGE_WITH_NAME(@"cart");
    button.titleEdgeInsets = UIEdgeInsetsMake(-image.size.width/2.6, -image.size.width/1.75, 0.0, 0.0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -button.titleLabel.bounds.size.width);
    
    if ([orderNumber isEqualToString:@"0"] || [orderNumber isEqualToString:@""] || !orderNumber) {
        image = _IMAGE_WITH_NAME(@"cart1");
        [button setTitle:nil forState:UIControlStateNormal];
    } else {
        image = _IMAGE_WITH_NAME(@"cart");
        [button setTitle:orderNumber forState:UIControlStateNormal];
    }
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoProductCartWrap) forControlEvents:UIControlEventTouchUpInside];
    self.cartButton = button;
    [toolView addSubview:button];
    
    //UIBarButtonItem *cartWarpBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //UIBarButtonItem *flexibleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(SCREEN_WIDTH-220, (CGRectGetHeight(toolView.frame) - 40) / 2.0, 100, 40);
    [button1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button1 setBackgroundColor:MAIN_YELLOW_COLOR];
    button1.layer.cornerRadius = 5;
    [button1 setTitle:@"加入购物袋" forState:UIControlStateNormal];
    [button1 setTitle:@"已售罄" forState:UIControlStateDisabled];
    if (_notAailable == YES) {
        button1.enabled = NO;
        button1.alpha = 0.0;
    }
    self.addToCartButton = button1;
    [button1 addTarget:self action:@selector(addProductToCart) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:button1];
    //UIBarButtonItem *addToCartWrapBarButton = [[UIBarButtonItem alloc] initWithCustomView:button1];
    //[self setToolbarItems:@[cartWarpBarButton, flexibleBarButton, addToCartWrapBarButton]];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.cartVersion == 2) {
        button1.frame = CGRectMake(SCREEN_WIDTH-110, (CGRectGetHeight(toolView.frame) - 40) / 2.0, 100, 40);
        return;
    }
    
    UIButton *buyNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyNowButton.frame = CGRectMake(SCREEN_WIDTH-110, (CGRectGetHeight(toolView.frame) - 40) / 2.0, 100, 40);
    [buyNowButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [buyNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyNowButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [buyNowButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [buyNowButton setBackgroundColor:[UIColor colorWithRed:215/255.0 green:44/255.0 blue:42/255.0 alpha:1]];
    buyNowButton.layer.cornerRadius = 5;
    [buyNowButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyNowButton setTitle:@"已售罄" forState:UIControlStateDisabled];
    self.buyNowButton = buyNowButton;
    if (_notAailable == YES) {
        buyNowButton.enabled = NO;
    }
    [buyNowButton addTarget:self action:@selector(handleBuyImmediately) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:buyNowButton];
}

- (void)handleBuyImmediately
{
    //友盟统计
    [MobClick event:@"iOS_lijiGouMai_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_lijiGouMai_uv"];
    
    if ([UserInfoManager didSignIn]) {
        
        if ((self.colorView && !self.colorImageUrl) || (self.sizeView && !self.sizePid)) {
            //弹出
            [self showColorAndSizeView];
        } else {
            [self tappedCancel];
            [self buyImmediately];
        }
        
    } else {
        _currentState = 1;//点击立即购买
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginTableViewController *logInVC = [storyBoard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
        logInVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logInVC];
        [nav.navigationBar customNavBar];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)changeCartButtonTitle:(NSNotification *)note
{
    NSLog(@"note: %@", note);
    NSString *orderNumber = [ManagerDefault standardManagerDefaults].orderNumber;
    if ([orderNumber isEqualToString:@"0"] || [orderNumber isEqualToString:@""] || !orderNumber) {
        [self.cartButton setImage:_IMAGE_WITH_NAME(@"cart1") forState:UIControlStateNormal];
        [self.cartButton setTitle:nil forState:UIControlStateNormal];
    } else {
        [self.cartButton setImage:_IMAGE_WITH_NAME(@"cart") forState:UIControlStateNormal];
        [self.cartButton setTitle:orderNumber forState:UIControlStateNormal];
    }
}

#pragma mark - ProductColorAndSizeDelegate Method
- (void)upDateSizeViewWithProductId:(NSString *)productID imageUrl:(NSString *)imgUrl selectColor:(int)index
{
    if (self.sizeView) {
        NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/appservice/iphone/query_goods.action?productId=%@", productID];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        __weak ProductInfoViewController *weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            if (error) {
                return;
            }
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                return;
            }
            NSArray *sizeArray = [[[dictionary objectForKey:@"rp_result"] objectForKey:@"productSpec"] objectForKey:@"size"];
            weakself.sizeArray = sizeArray;
            if (sizeArray) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakself.sizeView2) {
                        CGRect frame = weakself.sizeView2.frame;
                        ProductColorAndSizeView *sizeView2 = [[ProductColorAndSizeView alloc] initWithFrame:frame sizeArray:sizeArray delegate:weakself selectIndex:weakself.selectSizeIndex];
                        [weakself.sizeView2 removeFromSuperview];
                        weakself.sizeView2 = sizeView2;
                        [weakself.showView addSubview:sizeView2];
                    } else {
                        CGRect frame = weakself.sizeView.frame;
                        ProductColorAndSizeView *sizeView = [[ProductColorAndSizeView alloc] initWithFrame:frame sizeArray:sizeArray delegate:weakself selectIndex:weakself.selectSizeIndex];
                        [weakself.sizeView removeFromSuperview];
                        weakself.sizeView = sizeView;
                        [weakself.colorAndSizeView addSubview:sizeView];
                        
                        CGRect rect = weakself.colorAndSizeView.frame;
                        rect.size.height = CGRectGetMaxY(weakself.sizeView.frame)+20;
                        weakself.colorAndSizeView.frame = rect;
                    }
                });
            }
        });
    }
    self.colorImageUrl = imgUrl;
    self.selectColorIndex = index;
    
    if (self.colorView2 && self.colorView) {
        UIImageView *imageView = (UIImageView *)[self.colorView viewWithTag:_IMG_TAG_+index+1];
        imageView.layer.borderColor = MAIN_YELLOW_COLOR.CGColor;
        for (UIView *view in [self.colorView subviews]) {
            if (![view isEqual:imageView]) {
                view.layer.borderColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor;
            }
        }
    }
}

- (void)selectProductSizeWithProductID:(NSString *)pid selectSize:(int)index
{
    [self getInventoryNumberAndRealTimePrice:pid];
    self.sizePid = pid;
    self.selectSizeIndex = index;
    if (self.sizeView2 && self.sizeView) {
        UILabel *label = (UILabel *)[self.sizeView viewWithTag:_LABEL_TAG_+index+1];
        label.layer.borderColor = MAIN_YELLOW_COLOR.CGColor;
        for (UIView *view in [self.sizeView subviews]) {
            if (![view isEqual:label]) {
                view.layer.borderColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor;
            }
        }
    }
}

- (void)cancleSelectColor
{
    self.colorImageUrl = nil;
    self.selectColorIndex = -1;
}

- (void)cancleSelectSize
{
    self.sizePid = nil;
    self.selectSizeIndex = -1;
}

#pragma mark - 点击收藏
- (void)addToFavorte:(UIButton *)button
{
    [MobClick event:@"iOS_shoucang_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_shoucang_uv"];
    //    [self.webView stringByEvaluatingJavaScriptFromString:@"iosGetUpk('Product_AddToFavorite')"];
    
    if ([UserInfoManager didSignIn]) {
        if (_isFavorite) {
            [self removeFromFavorite];
        } else {
            [self addProductToFavorite];
        }
    } else {
        _currentState = 0;//点击收藏
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginTableViewController *logInVC = [storyBoard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
        logInVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logInVC];
        [nav.navigationBar customNavBar];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark
#pragma mark --ProductInfoDelegate--
- (void)getProductInfo:(NSDictionary *)productInfo
{
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView removeFromSuperview];

    if (productInfo == nil) {
        return;
    }
    
    self.productInfo = productInfo;
    self.showImagesUrls = [self.productInfo objectForKey:@"showPicture"];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self saveTheShareInfo];

    //downloading image
    [self downloadTopImage];
    [self setLogoImage];
    
    NSInteger areaType = [[self.productInfo objectForKey:@"areaType"] integerValue];
    if (areaType == 0) {
        //it is from mainland
        _productOrigin = ProductOriginChina;
    }
    else if (areaType == 2){
        //it is from america
        _productOrigin = ProductOriginAmerica;
    }
    else{
        _productOrigin = ProductOriginOthers;
    }
    
    //setup views
    [self addNameLabel];
    [self addPriceView];
    [self addProductColorAndSizeView];
    [self addDetailLabelView];
    [self setImageNumbers];
    
    [self setUpProductDetailedInformationView];
    [self addProductSpecifications];
    [self setSizeTableView];
    [self setUpWashingTipsView];
    [self setUpMaintanenceView];
    [self setUpBrandStoryView];
    [self getRecommenedProducts];
    [self setUpProductServiceView];
}

- (void)setImageNumbers
{
    NSInteger total = [self.showImagesUrls count];
    UIFont *labelFont = [UIFont systemFontOfSize:14];
    CGSize size = [Utils getSizeOfString:@"1" ofFont:labelFont withMaxWidth:160];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.introImageView.frame) - size.height - 2, self.introImageView.frame.size.width / 2.0, size.height + 1)];
    label.text = @"1/";
    label.font = labelFont;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    [self.introImageView addSubview:label];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.introImageView.frame.size.width / 2.0 + 1, CGRectGetHeight(self.introImageView.frame) - size.height - 2, self.introImageView.frame.size.width / 2.0, size.height + 1)];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.text = [NSString stringWithFormat:@"%d", total];
    totalLabel.textAlignment = NSTextAlignmentLeft;
    totalLabel.font = [UIFont systemFontOfSize:12];
    [self.introImageView addSubview:totalLabel];
}

- (void)setLogoImage
{
    NSString *iconUrl = [self.productInfo objectForKey:@"brandicon"];
    
    if (iconUrl) {
        [self setLogoImageWithImageURL:iconUrl];
    } else {
        [self.logoImageView setImage:nil];
        NSString *englishtName = [self.productInfo objectForKey:@"brandEnName"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.logoImageView.bounds.size.width-16.0, self.logoImageView.bounds.size.height-16.0)];
        label.layer.cornerRadius = label.frame.size.width / 2.0;
        [label.layer setMasksToBounds:YES];
        label.layer.borderColor = [UIColor clearColor].CGColor;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:10];
        label.textColor = [UIColor blackColor];
        label.text = [englishtName uppercaseString];
        [self.logoImageView addSubview:label];
        //[self rotateLogoImage];
    }
}

- (void)rotateLogoImage
{
    if (_rotationNumber == 4) {
        return;
    }
    _rotationNumber ++;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.delegate = self;
    CATransform3D final = CATransform3DMakeRotation(3.0, 0, 1, 0);
    CATransform3D start = CATransform3DMakeRotation(0.0, 0, 1, 0);
    if (_rotationNumber % 2 == 0) {
        final = CATransform3DMakeRotation(0.0, 0, 1, 0);
        start = CATransform3DMakeRotation(3.0, 0, 1, 0);
    }
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:start];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:final];
    rotationAnimation.duration = 0.15;
    [self.logoImageView.layer addAnimation:rotationAnimation forKey:@"transform"];
    self.logoImageView.layer.transform = final;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag) {
        //[self rotateLogoImage];
    }
}

- (void)setLogoImageWithImageURL:(NSString *)imgURL
{
    __block ProductInfoViewController *weakSelf = self;
    [[ImageDownloaderManager sharedInstance] addImageDowningTask:imgURL cached:NO completion:^(NSString *url, UIImage *image, NSError *error) {
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.logoImageView.image = image;
                //[weakSelf rotateLogoImage];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.logoImageView setImage:nil];
                NSString *englishtName = [weakSelf.productInfo objectForKey:@"brandEnName"];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, weakSelf.logoImageView.bounds.size.width-16.0, weakSelf.logoImageView.bounds.size.height-16.0)];
                label.layer.cornerRadius = label.frame.size.width / 2.0;
                [label.layer setMasksToBounds:YES];
                label.layer.borderColor = [UIColor clearColor].CGColor;
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.numberOfLines = 0;
                label.adjustsFontSizeToFitWidth = YES;
                label.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:10];
                label.textColor = [UIColor blackColor];
                label.text = [englishtName uppercaseString];
                [weakSelf.logoImageView addSubview:label];
                //[weakSelf rotateLogoImage];
            });
        }
    }];
}
/*
 #define ImageBaseTag                       44444
 #define MaintenanceBaseTag                 55555
 #define WashingBaseTag                     66666
 #define SizeTableBaseTag                   77777
 #define BrandStoryBaseTag                  99999
 */

- (NSInteger)getNumberOfDetailImages
{
    NSInteger total = 0;
    NSArray *array = [self.productInfo objectForKey:@"detailDesc"];
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"type"] integerValue] == 1) {
            total ++;
        }
    }
    return total;
}

- (void)handleTap:(UITapGestureRecognizer *)tap;
{
    UIImageView *view = (UIImageView *)tap.view;
    NSInteger tag = view.tag;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger currentIndex = 0;
    UIImage *defaultImage = [UIImage imageNamed:@"loading.png"];
    if (tag >= ImageBaseTag && tag < MaintenanceBaseTag) {
        currentIndex = tag - ImageBaseTag;
        NSInteger contentImageNumber = [self getNumberOfDetailImages];
        if (currentIndex != 0) {
            currentIndex = currentIndex + [self.showImagesUrls count] - contentImageNumber - 1;
        }
        NSArray *urls = self.showImagesUrls;
        if (currentIndex < [urls count]) {
            for (NSString *url in urls) {
                NSString *imageUrl = [self convertToRealUrl:url ofsize:[self getIMageWidth]];
                UIImageView *cycImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                cycImageView.image = defaultImage;
                [self getImagesOfImageURL:imageUrl forImageView:cycImageView];
                [array addObject:cycImageView];
            }
        }
        _imageBrowsType = ImageBrowserProductInfo;
    }
    else if (tag >= MaintenanceBaseTag && tag < WashingBaseTag){
        currentIndex = tag - MaintenanceBaseTag;
        NSArray *urls = [self.productInfo objectForKey:@"maintenanceTips"];
        if (currentIndex < [urls count]) {
            for (NSString *url in urls) {
                NSString *imageUrl = [self convertToRealUrl:url ofsize:[self getIMageWidth]];
                UIImageView *cycImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                cycImageView.image = defaultImage;
                [self getImagesOfImageURL:imageUrl forImageView:cycImageView];
                [array addObject:cycImageView];
            }
        }
    }
    else if (tag >= WashingBaseTag && tag < SizeTableBaseTag){
        currentIndex = tag - WashingBaseTag;
        NSArray *urls = [self.productInfo objectForKey:@"washingTips"];
        if (currentIndex < [urls count]) {
            for (NSString *url in urls) {
                NSString *imageUrl = [self convertToRealUrl:url ofsize:[self getIMageWidth]];
                UIImageView *cycImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                cycImageView.image = defaultImage;
                [self getImagesOfImageURL:imageUrl forImageView:cycImageView];
                [array addObject:cycImageView];
            }
        }
    }
    else if (tag >= SizeTableBaseTag && tag < BrandStoryBaseTag){
        currentIndex = tag - SizeTableBaseTag;
        _imageBrowsType = ImageBrowserSizeTable;
        NSArray *urls = [self.productInfo objectForKey:@"sizeTableUrl"];
        id txt = [self.productInfo objectForKey:@"sizeTableTxt"];
        if ([txt count] == 0) {
            if ([self.productInfo objectForKey:@"sizeTable"]) {
                urls = @[[NSString stringWithFormat:@"http://iphone.secoo.com/%@", [self.productInfo objectForKey:@"sizeTable"]]];
            }
            else{
                urls = nil;
            }
        }

        if (currentIndex < [urls count]) {
            for (NSString *url in urls) {
                NSString *imageUrl = [self convertToRealUrl:url ofsize:[self getIMageWidth]];
                UIImageView *cycImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                cycImageView.image = defaultImage;
                [self getImagesOfImageURL:imageUrl forImageView:cycImageView];
                [array addObject:cycImageView];
            }
        }
    }
    else if (tag >= BrandStoryBaseTag){
        _imageBrowsType = ImageBrowserBrandStory;
        currentIndex = tag - BrandStoryBaseTag;
        id urls = [[self.productInfo objectForKey:@"brandInfo"] objectForKey:@"image"];
        if (![urls isKindOfClass:[NSArray class]] && urls != nil) {
            urls = @[urls];
        }
        if (currentIndex < [urls count]) {
            for (NSString *url in urls) {
                NSString *imageUrl = [self convertToRealUrl:url ofsize:[self getIMageWidth]];
                UIImageView *cycImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                cycImageView.image = defaultImage;
                [self getImagesOfImageURL:imageUrl forImageView:cycImageView];
                [array addObject:cycImageView];
            }
        }
    }
    
    if (view.image) {
        UIView *flashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        flashView.backgroundColor = [UIColor clearColor];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:flashView];
        
        CGRect originRect = view.frame;
        CGRect frame = [view convertRect:view.frame toView:delegate.window];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x - originRect.origin.x, frame.origin.y - originRect.origin.y, frame.size.width, frame.size.height)];
        imageView.image = view.image;
        [flashView addSubview:imageView];
        
        CGRect finalRect;
        UIImage *image = view.image;
        finalRect = [Utils adjustImageViewToSize:image.size inSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [UIView animateWithDuration:0.5 animations:^{
            imageView.frame = finalRect;
            flashView.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            [self presentImageBrowserWithImageArray:array currentIndex:currentIndex completion:^{
                [flashView removeFromSuperview];
            }];
        }];
    }
    else{
        [self presentImageBrowserWithImageArray:array currentIndex:currentIndex completion:NULL];
    }
}

- (void)presentImageBrowserWithImageArray:(NSArray *)array currentIndex:(NSInteger)currentIndex completion:(void (^)(void))completion
{
    if (_cycleScrollVC == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CycleScrollViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CycleScrollViewController"];
        _cycleScrollVC = vc;
        CycleScrollView *cycleScrollView = (CycleScrollView *)vc.view;
        cycleScrollView.currentPageIndex = currentIndex;
        [self presentViewController:vc animated:NO completion:completion];
        cycleScrollView.delegate = self;
        cycleScrollView.views = array;
    }
}


#pragma mark -------------cycleScorllViewDelegate-------------------
- (void)didTapOnCycleScrollView:(CycleScrollView *)view At:(NSInteger)index
{
    UIView *flashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    flashView.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [view.views objectAtIndex:index];
    UIImageView *flashImageView = [[UIImageView alloc] initWithFrame:imageView.frame];
    flashImageView.image = imageView.image;
    [flashView addSubview:flashImageView];
    [self.view addSubview:flashView];
    [self.cycleScrollVC dismissViewControllerAnimated:NO completion:^{
        [UIView animateWithDuration:0.3 animations:^{
            flashView.backgroundColor = [UIColor clearColor];
            //flashImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            flashImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [flashView removeFromSuperview];
        }];
    }];
    self.cycleScrollVC = nil;
    [self showStatusBar];
}

- (void)getImageFromURL:(NSString *)imageUrl
{
    NSArray *imageViews = [self.imageViewsForURL objectForKey:imageUrl];
    for (UIImageView *view in imageViews) {
        UIImage *image = [self.images objectForKey:imageUrl];
        view.image = image;
        if (self.cycleScrollVC) {
            CycleScrollView *cycView = (CycleScrollView *)self.cycleScrollVC.view;
            NSArray *views = cycView.views;
            NSInteger index = [views indexOfObject:view];
            if (index != NSNotFound) {
                CGRect rightRect = [Utils adjustImageViewToSize:image.size inSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
                view.frame = rightRect;
            }
        }
        if (view.tag >= ImageBaseTag + 1) {
            CGRect frame = view.frame;
            CGFloat width = self.productDetailedInfoView.frame.size.width;
            frame.origin.x = (width - image.size.width) / 2.0;
            frame.size = image.size;
            view.frame = frame;
        }
    }
    //layout will display the imageView accordingly
    [self.view setNeedsLayout];
    [self.imageViewsForURL removeObjectForKey:imageUrl];
}

#pragma mark --
#pragma mark -- Layout --

- (void)setProductDetailedInfoViewFrame
{
    if (self.productDetailedInfoView == nil) {
        return;
    }
    
    //NSArray *array = [self.productInfo objectForKey:@"detailDesc"];
    UIView *lastView = self.productDetailedHeadButton;
    for (int i = 0; i < ([self.mutilMediaArray count]); ++i) {
        UIView *subView = [self.productDetailedInfoView viewWithTag:[[self.mutilMediaArray objectAtIndex:i] integerValue]];
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)subView;
            CGFloat originY = CGRectGetMaxY(lastView.frame) + 5;
            UIImage *image = imageView.image;
            if (image) {
                lastView = imageView;
                CGSize size = image.size;
                CGRect frame = imageView.frame;
                CGFloat width = self.productDetailedInfoView.frame.size.width;
                if (size.width <= width - 2 * offsetX) {
                    frame.origin.x = (width - image.size.width) / 2.0;
                    frame.origin.y = originY;
                    frame.size = size;
                    imageView.frame = frame;
                }
                else{
                    frame.origin.x = offsetX;
                    frame.origin.y = originY;
                    CGFloat imageWidth = (self.productDetailedInfoView.frame.size.width - 2 * offsetX);
                    CGFloat height = imageWidth / size.width * size.height;
                    CGSize smallSize = CGSizeMake(imageWidth, height);
                    frame.size = smallSize;
                    imageView.frame = frame;
                }
            }
            lastView = imageView;
        }
        else if(subView){
            //webview
            CGFloat originY = CGRectGetMaxY(lastView.frame) + 5;
            CGRect frame = subView.frame;
            frame.origin.y = originY;
            subView.frame = frame;
            
            lastView = subView;
        }
    }
    
    if (lastView) {
        CGRect frame = self.productDetailedInfoView.frame;
        if (self.introductionView) {
            frame.origin.y = CGRectGetMaxY(self.introductionView.frame) + 10;
        }
        frame.size.height = CGRectGetMaxY(lastView.frame) + 10;
        self.productDetailedInfoView.frame = frame;
    }
}

- (void)setSpecificationViewFrame
{
    if (self.specificationView == nil) {
        return;
    }
    UIView *lastView = self.productDetailedInfoView;
    if (lastView == nil) {
        lastView = self.introductionView;
    }
    
    CGRect frame = self.specificationView.frame;
    frame.origin.y = CGRectGetMaxY(lastView.frame) + 10;
    self.specificationView.frame = frame;
}

- (void)setSizeTableFrame
{
    if (self.sizeTableView == nil) {
        return;
    }
    
    UIView *lastView;
    if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView) {
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    
    CGRect labelFrame = self.sizeTableView.frame;
    labelFrame.origin.y = CGRectGetMaxY(lastView.frame) + 10;
    self.sizeTableView.frame = labelFrame;
    
    NSArray *array = [self.productInfo objectForKey:@"sizeTableUrl"];
    id txt = [self.productInfo objectForKey:@"sizeTableTxt"];
    if ([txt count] == 0) {
        if ([self.productInfo objectForKey:@"sizeTable"]) {
            array = @[[NSString stringWithFormat:@"http://iphone.secoo.com/%@", [self.productInfo objectForKey:@"sizeTable"]]];
            //array = @[[self.productInfo objectForKey:@"sizeTable"]];
        }
        else{
            array = nil;
        }
    }
    
    UIView *lastImageView = self.sizeTableTitle;
    for (int i = 0; i < [array count]; ++i) {
        UIImageView *imageView = (UIImageView *)[self.sizeTableView viewWithTag:SizeTableBaseTag + i];
        if (imageView) {
            CGFloat originY;
            if (i == 0 ) {
                originY = CGRectGetMaxY(self.sizeTableTitle.frame) + 5;
            }
            else{
                UIView *view = [self.sizeTableView viewWithTag:SizeTableBaseTag + i - 1];
                originY = CGRectGetMaxY(view.frame) + 5;
            }
            
            UIImage *image = imageView.image;
            if (image == nil) {
                image = [UIImage imageNamed:@"loading.png"];
            }
            lastImageView = imageView;
            CGSize size = image.size;
            CGRect frame = imageView.frame;
            CGFloat width = self.sizeTableView.frame.size.width;
            if (size.width <= width - 2 * offsetX) {
                frame.origin.x = (width - image.size.width) / 2.0;
                frame.origin.y = originY;
                frame.size = size;
                imageView.frame = frame;
            }
            else{
                frame.origin.x = offsetX;
                frame.origin.y = originY;
                CGFloat imageWidth = (self.sizeTableView.frame.size.width - 2 * offsetX);
                CGFloat height = imageWidth / size.width * size.height;
                CGSize smallSize = CGSizeMake(imageWidth, height);
                frame.size = smallSize;
                imageView.frame = frame;
            }
        }
    }
    if (self.sizeTableTexView) {
        if (_sizeTableSpreaded) {
            CGRect frame = self.sizeTableTexView.frame;
            frame.origin.y = CGRectGetMaxY(lastImageView.frame) + 5;
            self.sizeTableTexView.frame = frame;
            lastImageView = self.sizeTableTexView;
        }
    }
    
    if (self.sizeTableParameterView) {
        if (_sizeTableSpreaded) {
            CGRect frame = self.sizeTableParameterView.frame;
            frame.origin.y = CGRectGetMaxY(lastImageView.frame) + 5;
            self.sizeTableParameterView.frame = frame;
            lastImageView = self.sizeTableParameterView;
        }
    }
    
    if (lastImageView) {
        CGRect frame = self.sizeTableView.frame;
        frame.size.height = CGRectGetMaxY(lastImageView.frame);
        self.sizeTableView.frame = frame;
    }
}

- (void)setWashingTipsViewFrame
{
    if (self.washingTipsView == nil) {
        return;
    }
    UIView *lastView;
    if (self.sizeTableView != nil) {
        lastView = self.sizeTableView;
    }
    else if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView){
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    
    CGRect frame = self.washingTipsView.frame;
    frame.origin.y = CGRectGetMaxY(lastView.frame) + 10;
    self.washingTipsView.frame = frame;
    
    NSArray *array = [self.productInfo objectForKey:@"washingTips"];
    UIView *lastImageView = self.washingHeadButton;
    for (int i = 0; i < [array count]; ++i) {
        UIImageView *imageView = (UIImageView *)[self.washingTipsView viewWithTag:WashingBaseTag + i];
        if (imageView) {
            CGFloat originY;
            if (i == 0 ) {
                originY = CGRectGetMaxY(self.washingHeadButton.frame) + 5;
            }
            else{
                UIView *view = [self.washingTipsView viewWithTag:WashingBaseTag + i - 1];
                originY = CGRectGetMaxY(view.frame) + 5;
            }
            
            UIImage *image = imageView.image;
            if (image == nil) {
                image = [UIImage imageNamed:@"loading.png"];
                imageView.image = image;
            }
            lastImageView = imageView;
            CGSize size = image.size;
            CGRect frame = imageView.frame;
            CGFloat width = self.washingTipsView.frame.size.width;
            if (size.width <= width - 2 * offsetX) {
                frame.origin.x = (width - image.size.width) / 2.0;
                frame.origin.y = originY;
                frame.size = size;
                imageView.frame = frame;
            }
            else{
                frame.origin.x = offsetX;
                frame.origin.y = originY;
                CGFloat imageWidth = (self.washingTipsView.frame.size.width - 2 * offsetX);
                CGFloat height = imageWidth / size.width * size.height;
                CGSize smallSize = CGSizeMake(imageWidth, height);
                frame.size = smallSize;
                imageView.frame = frame;
            }
        }
    }
    
    if (lastImageView) {
        CGRect frame = self.washingTipsView.frame;
        frame.size.height = CGRectGetMaxY(lastImageView.frame);
        self.washingTipsView.frame = frame;
    }
}

- (void)setFramesOfBrandImages
{
    if (self.brandStoryView == nil) {
        return;
    }
    CGRect labelFrame = self.brandStoryView.frame;
    CGFloat gap = 10;
    if (self.maintanenceView) {
        labelFrame.origin.y = CGRectGetMaxY(self.maintanenceView.frame) + gap;
    }
    else if (self.washingTipsView){
        labelFrame.origin.y = CGRectGetMaxY(self.washingTipsView.frame) + gap;
    }
    else if (self.sizeTableView) {
        labelFrame.origin.y = CGRectGetMaxY(self.sizeTableView.frame) + gap;
    }
    else if (self.specificationView){
        labelFrame.origin.y = CGRectGetMaxY(self.specificationView.frame) + gap;
    }
    else if (self.productDetailedInfoView){
        labelFrame.origin.y = CGRectGetMaxY(self.productDetailedInfoView.frame) + gap;
    }
    else{
        labelFrame.origin.y = CGRectGetMaxY(self.introductionView.frame) + gap;
    }
    self.brandStoryView.frame = labelFrame;
    
    id array = [[self.productInfo objectForKey:@"brandInfo"] objectForKey:@"image"];
    if (![array isKindOfClass:[NSArray class]] && array != nil) {
        array = @[array];
    }
    UIView *lastView = self.brandHeadButton;
    for (int i = 0; i < [array count]; ++i) {
        UIImageView *imageView = (UIImageView *)[self.brandStoryView viewWithTag:BrandStoryBaseTag + i];
        if (imageView) {
            CGFloat originY;
            if (i == 0 ) {
                originY = CGRectGetMaxY(self.brandHeadButton.frame) + 5;
            }
            else{
                UIView *view = [self.brandStoryView viewWithTag:BrandStoryBaseTag + i - 1];
                originY = CGRectGetMaxY(view.frame) + 5;
            }
            
            UIImage *image = imageView.image;
            if (image == nil) {
                image = [UIImage imageNamed:@"loading.png"];
                imageView.image = image;
            }
            lastView = imageView;
            CGSize size = image.size;
            CGRect frame = imageView.frame;
            CGFloat width = self.brandStoryView.frame.size.width;
            if (size.width <= width - 2 * offsetX) {
                frame.origin.x = (width - image.size.width) / 2.0;
                frame.origin.y = originY;
                frame.size = size;
                imageView.frame = frame;
            }
            else{
                frame.origin.x = offsetX;
                frame.origin.y = originY;
                CGFloat imageWidth = (self.brandStoryView.frame.size.width - 2 * offsetX);
                CGFloat height = imageWidth / size.width * size.height;
                CGSize smallSize = CGSizeMake(imageWidth, height);
                frame.size = smallSize;
                imageView.frame = frame;
            }
        }
    }
    
    for (int i = 0; i < 2; ++i) {
        UIView *label = [self.brandStoryView viewWithTag:BrandStoryBaseTag + [array count] + i];
        if (label) {
            CGRect frame = label.frame;
            frame.origin.y = CGRectGetMaxY(lastView.frame) + 5;
            label.frame = frame;
            lastView = label;
        }
    }
    
    if (lastView) {
        CGRect frame = self.brandStoryView.frame;
        frame.size.height = CGRectGetMaxY(lastView.frame);
        self.brandStoryView.frame = frame;
    }
}

- (void)setUpMaintanenceFrames
{
    if (self.maintanenceView == nil) {
        return;
    }
    CGFloat marginX = 5;
    UIView *lastView;
    if (self.washingTipsView) {
        lastView = self.washingTipsView;
    }
    else if (self.sizeTableView){
        lastView = self.sizeTableView;
    }
    else if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView){
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    
    CGRect labelFrame = self.maintanenceView.frame;
    CGFloat y = CGRectGetMaxY(lastView.frame);
    labelFrame.origin.y = y + 10;
    self.maintanenceView.frame = labelFrame;
    
    NSArray *array = [self.productInfo objectForKey:@"maintenanceTips"];
    UIView *lastImageView = self.maintanenceButton;
    for (int i = 0; i < [array count]; ++i) {
        UIImageView *imageView = (UIImageView *)[self.maintanenceView viewWithTag: MaintenanceBaseTag + i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;

        if (imageView) {
            CGFloat originY;
            if (i == 0 ) {
                originY = CGRectGetMaxY(self.maintanenceButton.frame) + 5;
            }
            else{
                UIView *view = [self.maintanenceView viewWithTag:MaintenanceBaseTag + i - 1];
                originY = CGRectGetMaxY(view.frame) + 5;
            }
            
            UIImage *image = imageView.image;
            if (image == nil) {
                image = [UIImage imageNamed:@"loading.png"];
            }
            lastImageView = imageView;
            CGSize size = image.size;
            CGRect frame = imageView.frame;
            CGFloat width = self.maintanenceView.frame.size.width;
            if (size.width <= width - 2 * marginX) {
                frame.origin.x = (width - image.size.width) / 2.0;
                frame.origin.y = originY;
                frame.size = size;
                imageView.frame = frame;
            }
            else{
                frame.origin.x = marginX;
                frame.origin.y = originY;
                CGFloat imageWidth = (self.maintanenceView.frame.size.width - 2 * marginX);
                CGFloat height = imageWidth / size.width * size.height;
                CGSize smallSize = CGSizeMake(imageWidth, height);
                frame.size = smallSize;
                imageView.frame = frame;
            }
        }
    }
    
    if (lastImageView) {
        CGRect frame = self.maintanenceView.frame;
        frame.size.height = CGRectGetMaxY(lastImageView.frame);
        self.maintanenceView.frame = frame;
    }

}

- (void)setFrameOfRecommendationView
{
    UIView *lastView;
    if (self.brandStoryView) {
        lastView = self.brandStoryView;
    }
    else if (self.maintanenceView){
        lastView = self.maintanenceView;
    }
    else if (self.washingTipsView){
        lastView = self.washingTipsView;
    }
    else if (self.sizeTableView){
        lastView = self.sizeTableView;
    }
    else if (self.specificationView){
        lastView = self.specificationView;
    }
    else if (self.productDetailedInfoView){
        lastView = self.productDetailedInfoView;
    }
    else{
        lastView = self.introductionView;
    }
    
    CGRect frame = self.recommendationView.frame;
    frame.origin.y = CGRectGetMaxY(lastView.frame);
    self.recommendationView.frame = frame;
}

#pragma mark --
#pragma mark --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        //NSLog(@"offset:%f", scrollView.contentOffset.y);
        CGFloat offsetY = self.scrollView.contentOffset.y;
        if (offsetY - _originalOffsetY > 40) {
            [UIView animateWithDuration:1.0 animations:^{
                self.scrollToTopButton.alpha = 1.0;
            }];
        }
        else{
            [UIView animateWithDuration:1.0 animations:^{
                self.scrollToTopButton.alpha = 0.0;
            }];
        }
    }
}


#pragma mark - 存储分享的信息
- (void)saveTheShareInfo
{
    NSString *brandCnName = [self.productInfo objectForKey:@"brandCnName"];
    NSString *productName = [self.productInfo objectForKey:@"productName"];
    NSString *categoryName = [self.productInfo objectForKey:@"categoryName"];
    NSString *refPrice = [self.productInfo objectForKey:@"refPrice"];
    NSString *shareURL = [self.productInfo objectForKey:@"shareurl"];
    //FIXME:
    NSString *shareImageURL = [self.showImagesUrls firstObject];
    if (![shareImageURL hasPrefix:@"http://"]) {
        shareImageURL = [NSString stringWithFormat:@"http://pic.secoo.com/product/80/80/%@", shareImageURL];
    }
    
    ManagerDefault *manager = [ManagerDefault standardManagerDefaults];
    
    manager.shareImageURL = shareImageURL;
    manager.shareURL = shareURL;
    manager.shareDescription = [NSString stringWithFormat:@"我在寺库发现了仅售%@元的 %@", refPrice, productName];
    
    manager.shareTitle = [NSString stringWithFormat:@"%@%@ 仅售%@元,赶紧来看看吧",brandCnName, categoryName, refPrice];
    manager.shareTitle2 = [NSString stringWithFormat:@"我在寺库发现了仅售%@元的%@ %@,赶紧来看看吧", refPrice, brandCnName, categoryName];
    
    NSString *info = [NSString stringWithFormat:@"%@$_$%@$_$%@$_$%@$_$%@",manager.shareTitle,manager.shareTitle2,manager.shareDescription,manager.shareURL,manager.shareImageURL];
    [[ManagerDefault standardManagerDefaults] saveShareInformationWithJSUrl:info];
}

#pragma mark - 分享
- (void)shareMethod:(UIBarButtonItem *)sender
{
    NSArray *shareButtonTitleArray = @[@"微信",@"朋友圈",@"短信"];
    NSArray *shareButtonImageNameArray = @[@"sns_icon_1", @"sns_icon_2", @"sns_icon_3"];
    LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

#pragma mark - LXActivityDelegate
- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    //友盟统计分享
    [MobClick event:@"iOS_fenxiang_pv"];
    [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_fenxiang_uv"];
    
    if (2 == (int)imageIndex) {
        //分享到短信
        [self showSMSPicker];
    } else if (1 == (int)imageIndex) {
        //分享到微信朋友圈
        [self.delegate changeScene:WXSceneTimeline];
        [self.delegate sendLinkContent];
    } else if (0 == (int)imageIndex) {
        //分享给微信好友
        [self.delegate changeScene:WXSceneSession];
        [self.delegate sendLinkContent];
    }
}
- (void)didClickOnCancelButton
{
}
#pragma mark - 短信分享调用的方法
- (void)showSMSPicker
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        } else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"设备不支持短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *smsBody = [NSString stringWithFormat:@"%@ %@", [ManagerDefault standardManagerDefaults].shareTitle2, [ManagerDefault standardManagerDefaults].shareURL];
    picker.body = smsBody;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //NSLog(@"%s", __FUNCTION__);
    switch(result) {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: SMS faild");
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --
#pragma mark --getter and setter--

- (NSMutableArray *)downloadingImages
{
    if (_downloadingImages == nil) {
        _downloadingImages = [[NSMutableArray alloc] init];
    }
    return _downloadingImages;
}

- (NSMutableDictionary *)images
{
    if (_images == nil) {
        _images = [[NSMutableDictionary alloc] init];
    }
    return _images;
}

- (NSMutableDictionary *)imageViewsForURL
{
    if (_imageViewsForURL == nil) {
        _imageViewsForURL = [[NSMutableDictionary alloc] init];
    }
    return _imageViewsForURL;
}

- (NSMutableArray *)imageViews
{
    if (_imageViews == nil) {
        _imageViews = [[NSMutableArray alloc] init];
    }
    return _imageViews;
}

- (NSMutableArray *)brandImageViews
{
    if (_brandImageViews == nil) {
        _brandImageViews = [[NSMutableArray alloc] init];
    }
    return _brandImageViews;
}

- (NSMutableArray *)maintanenceViews
{
    if (_maintanenceViews == nil) {
        _maintanenceViews = [[NSMutableArray alloc] init];
    }
    return _maintanenceViews;
}

- (NSMutableArray *)sizeTableViews
{
    if (_sizeTableViews == nil) {
        _sizeTableViews = [[NSMutableArray alloc] init];
    }
    return _sizeTableViews;
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        AppDelegate *delegte = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _webView = delegte.webView;
    }
    return _webView;
}

- (NSMutableArray *)mutilMediaArray
{
    if (_mutilMediaArray == nil) {
        _mutilMediaArray = [[NSMutableArray alloc] init];
    }
    return _mutilMediaArray;
}

- (void)addProductToFavorite
{
    NSString *upKey = [UserInfoManager getUserUpKey];
    NSString *productCode = [self.productInfo objectForKey:@"productCode"];
    NSString *price = [NSString stringWithFormat:@"%ld", [[self.productInfo objectForKey:@"secooPrice"] longValue]];
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=/favorite/myfavorite.jsp&v=1.0&client=iphone&vo.upkey=%@&method=secoo.user.addConcernedCommodity&vo.productCode=%@&vo.price=%@", upKey, productCode, price];
    NSString *compatibleURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    LGURLSession *favoriteSession = [[LGURLSession alloc] init];
    [favoriteSession startConnectionToURL:compatibleURL completion:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSError *jsonError;
            id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *result = [jsonDict valueForKey:@"rp_result"];
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        int recode = [[result valueForKey:@"recode"] integerValue];
                        if (recode == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
                                _isFavorite = YES;
                                [self.favoriteButton setImage:_IMAGE_WITH_NAME(@"collect1") forState:UIControlStateNormal];
                            });
                        }
                        else{
                            NSString *errorMsg = [result valueForKey:@"errMsg"];
                            if (errorMsg) {
                                NSLog(@"errMsg: %@", errorMsg);
                            }
                            else{
                                NSLog(@"there is something wrong with the network when getting detailed products list");
                            }
                        }
                    }
                }
                
            }
        }
    }];
}

#pragma mark - LoginTableViewController Delegate
- (void)didLogin
{
    if (0 == _currentState) {
        //点击收藏
        [self addToFavorte:self.favoriteButton];
        
    } else if (1 == _currentState) {
        //点击立即购买
        [self handleBuyImmediately];
    }
}

@end
