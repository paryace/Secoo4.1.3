//
//  Utils.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/27/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "Utils.h"
#import <sys/utsname.h>
#import <CoreText/CoreText.h>
#import "CartItemAccessor.h"
#import "Reachability.h"
#import "UserInfoManager.h"
#import "LGURLSession.h"
#import "CartItem.h"
#import "SSKeychain.h"
#import "AppDelegate.h"

@implementation Utils

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    if (CGSizeEqualToSize(size, image.size)) {
        return image;
    }
    UIImage *resizedImage = nil;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

+ (NSString *)convertToRealUrl:(NSString *)url isBig:(BOOL)isBig
{
    //http://pic.secoo.com/product/200/200/23/28/10432328.jpg
    
    if ([url hasPrefix:@"http://"]) {
        return url;
    }
    NSString *realURL;
    if (isBig) {
        realURL = [[NSString alloc] initWithFormat:@"http://pic.secoo.com/product/500/500/%@", url];
    }
    else{
        realURL = [[NSString alloc] initWithFormat:@"http://pic.secoo.com/product/200/200/%@", url];
    }
    return realURL;
}

+ (NSString *)urlEncodeValue:(NSString *)param
{
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                (CFStringRef)param, nil,
                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedValue;
}

+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    
    return (NSArray *)linesArray;
}

+ (NSString *)stringbyRmovingSpaceFromString:(NSString *)string
{
    NSArray* words = [string componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    NSString* nospacestring = [words componentsJoinedByString:@""];
    return nospacestring;
}

+ (BOOL)isValidString:(NSString *)str
{
    if (str == nil || [[Utils stringbyRmovingSpaceFromString:str] isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

+ (CGSize)getSizeOfString:(NSString *)str ofFont:(UIFont *)font withMaxWidth:(CGFloat)maxWidth
{
    CGSize constraintSize;
    constraintSize.width = maxWidth;
    constraintSize.height = MAXFLOAT;
    CGSize contentSize = [str sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    return CGSizeMake(contentSize.width + 2, contentSize.height + 2);
}

+ (CGFloat)getHeigthOfFont:(UIFont *)font
{
    CGSize constraintSize;
    constraintSize.width = 320;
    constraintSize.height = MAXFLOAT;
    CGSize contentSize = [@"我" sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    return contentSize.height + 2;
}

+ (UIImage *)takeScreenShotOfView:(UIView*)view
{
    NSString * version = [UIDevice currentDevice].systemVersion;
    CGFloat ver = version.floatValue;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (UIGraphicsBeginImageContextWithOptions != nil) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), true, 0.0);
    }
    else{
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
    }
    
    UIImage *image = nil;
    if (ver < 7.0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [view.layer renderInContext:context];
        // Retrieve the screenshot image
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    else{
        // if it is ios 7 or later, we use the snapshot function provided by the system
        BOOL isReady = [view drawViewHierarchyInRect:CGRectMake(0, 0, width, height) afterScreenUpdates: true];
        if (isReady) {
            image = UIGraphicsGetImageFromCurrentImageContext();
        }
    }
    UIGraphicsEndImageContext();
    return image;
}

+ (CGRect)adjustImageViewToSize:(CGSize)imageSize inSize:(CGSize)inSize
{
    CGRect rightRect;
    if (imageSize.width < inSize.width && imageSize.height < inSize.height) {
        rightRect.origin = CGPointMake((inSize.width - imageSize.width) / 2.0, (inSize.height - imageSize.height) / 2.0);
        rightRect.size = imageSize;
    }
    else{
        if (inSize.width / imageSize.width * imageSize.height <= inSize.height) {
            CGSize size = CGSizeMake(inSize.width, inSize.width / imageSize.width * imageSize.height);
            rightRect.size = size;
            rightRect.origin = CGPointMake(0, (inSize.height - size.height) / 2.0);
        }
        else{
            CGSize size = CGSizeMake(inSize.height / imageSize.height * imageSize.width, inSize.height);
            rightRect.size = size;
            rightRect.origin = CGPointMake((inSize.width - size.width) / 2.0, 0);
        }
    }
    
    return rightRect;
}

+ (void)updateCartBadgeNumberWithNumber:(NSInteger)number
{
    NSString *str = @"";
    if (number < 0) {
        NSInteger num = [[CartItemAccessor sharedInstance] numberOfCartItems];
        str = [NSString stringWithFormat:@"%d", num];
    }
    else if (number > 0){
        str = [NSString stringWithFormat:@"%d", number];
    }
    
    [ManagerDefault standardManagerDefaults].orderNumber = str;
}

+ (NSString *)convertToRealUrl:(NSString *)url ofsize:(NSInteger)width
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

+ (void)handleAlipayResult:(AlixPayResult *)payResult
{
    if (payResult) {
        if (payResult.statusCode == 9000) {
            NSArray *array = [payResult.resultString componentsSeparatedByString:@"&"];
            for (NSString *str in array) {
                if ([str hasPrefix:@"success"]) {
                    NSRange range = [str rangeOfString:@"true"];
                    if (range.location != NSNotFound) {
                        
                        //友盟统计
                        [MobClick event:@"iOS_zhifubao_chenggong_pv"];
                        [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_chenggong_uv"];
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        NSDate *dateNow = [NSDate date];
                        NSString *dateNowString = [formatter stringFromDate:dateNow];
                        if ([dateNowString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"registerSuccess"]]) {
                            //当天注册成功当天就支付订单
                            [MobClick event:@"iOS_newChengjiao"];
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kAlipaySuccess object:nil userInfo:nil];
                        break;
                    }
                    else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayFailed object:nil userInfo:nil];
                    }
                }
            }
        }
        else if (payResult.statusCode == 6001){
            //用户取消
            
            //友盟统计
            [MobClick event:@"iOS_zhifubao_cancel_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_cancel_uv"];
        }
        else if (payResult.statusCode == 4000){
            //订单支付失败
            [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayFailed object:nil userInfo:nil];
            
            //友盟统计
            [MobClick event:@"iOS_zhifubao_shibai_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_shibai_uv"];
        }
        else if (payResult.statusCode == 6002){
            //网络连接出问题
            [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayNetworkProblem object:nil userInfo:nil];
            //友盟统计
            [MobClick event:@"iOS_zhifubao_shibai_pv"];
            [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_shibai_uv"];
        }
    } else {
        //友盟统计
        [MobClick event:@"iOS_zhifubao_shibai_pv"];
        [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifubao_shibai_uv"];
    }
}

+ (BOOL)checkNewworkStatusAndWarning:(BOOL)willWarn toView:(UIView*)view
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if (reachability.currentReachabilityStatus == NotReachable) {
        if (willWarn) {
            [MBProgressHUD showError:@"亲，您好像没有开网络哦，请打开后重试." toView:view];
        }
        return NO;
    }
    return YES;
}

+ (void)showAlertMessage:(NSString *)message title:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

+ (BOOL)isiPhone6Plus
{
    if ([[Utils deviceModelName] isEqualToString:@"iPhone7,1"]) {
        return YES;
    }
    return NO;
}

+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machineName;
}

+ (void)updateUpkey
{
    BOOL login = [UserInfoManager didSignIn];
    if (!login) {
        return;
    }
    NSString *phoneNumber = [UserInfoManager userPhoneNumber];
    NSString *password = [UserInfoManager getUserPassword];
    
    NSString *url = [NSString stringWithFormat:@"http://iphone.secoo.com/getAjaxData.action?urlfilter=userCenter.mo&v=1.0&client=1&method=secoo.user.login&vo.userName=%@&vo.password=%@",phoneNumber, password];
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil && data) {
            NSError *jsonError;//recode, uid, upKey
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *jsonDict = [jsonResponse objectForKey:@"rp_result"];
                if ([[jsonDict objectForKey:@"recode"] integerValue] == 0) {
                    [UserInfoManager setUserUpKey:[jsonDict objectForKey:@"upKey"]];
                }
            }
        }
        else{
            NSLog(@"login error:%@ ----%@", error.description, error.debugDescription);
        }
    }];
}

+ (NSString *)cartProductInfo
{
    NSArray *array = [[CartItemAccessor sharedInstance] getAllItems];
    NSString *productInfo;
    for (CartItem *cartItem in array) {
        int16_t number = cartItem.quantity;
        NSString *proInfo = [NSString stringWithFormat:@"{\"productId\":%@,\"quantity\":%d,\"type\":%d,\"areaType\":%hd}",cartItem.productId, number, 0, cartItem.areaType];
        if (productInfo == nil) {
            productInfo = proInfo;
        }
        else{
            productInfo = [NSString stringWithFormat:@"%@,%@", productInfo, proInfo];
        }
    }
    productInfo = [NSString stringWithFormat:@"[%@]", productInfo];
    return productInfo;
}

+ (NSString *)createNewUUID {
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *str = (__bridge NSString *)string;
    CFRelease(string);
    return  str;
}

+ (NSString *)getDeviceUDID
{
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.secoo.secooApp" account:@"udid"];
    if (retrieveuuid == nil) {
        // if this is the first time app lunching , create key for device
        retrieveuuid  = [self createNewUUID];
        // save newly created key to Keychain
        [SSKeychain setPassword:retrieveuuid forService:@"com.secoo.secooApp" account:@"udid"];
    }
    return retrieveuuid;
}

#pragma mark - 返回币种
+ (NSString *)moneyTypeWithAreaType:(int)areaType price:(float)price
{
    if (0 == areaType) {
        return [NSString stringWithFormat:@"¥ %.2f", price];//人民币
    } else if (1 == areaType) {
        return [NSString stringWithFormat:@"HK$ %.2f 港币", price];//港币
    } else if (2 == areaType) {
        return [NSString stringWithFormat:@"$ %.2f 美元", price];//美元
    } else if (3 == areaType) {
        return [NSString stringWithFormat:@"¥ %.2f 日元", price];//日元
    } else if (4 == areaType) {
        return [NSString stringWithFormat:@"€ %.2f 欧元", price];//欧元
    } else if (5 == areaType) {
        return [NSString stringWithFormat:@"ƒ %.2f 法郎", price];//法郎
    }
    return [NSString stringWithFormat:@"%.2f", price];
}

+ (NSString *)intMoneyTypeWithAreaType:(int)areaType price:(float)price
{
    if (0 == areaType) {
        return [NSString stringWithFormat:@"¥ %.0f", price];//人民币
    } else if (1 == areaType) {
        return [NSString stringWithFormat:@"HK$ %.0f 港币", price];//港币
    } else if (2 == areaType) {
        return [NSString stringWithFormat:@"$ %.0f 美元", price];//美元
    } else if (3 == areaType) {
        return [NSString stringWithFormat:@"¥ %.0f 日元", price];//日元
    } else if (4 == areaType) {
        return [NSString stringWithFormat:@"€ %.0f 欧元", price];//欧元
    } else if (5 == areaType) {
        return [NSString stringWithFormat:@"ƒ %.0f 法郎", price];//法郎
    }
    return [NSString stringWithFormat:@"%.0f", price];
}

+ (void)setCartVersion
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //NSString *url = @"http://192.168.200.23:8082/appservice/iphone/edition.action";
    NSString *url = @"http://iphone.secoo.com/appservice/iphone/edition.action";
    [[[LGURLSession alloc] init] startConnectionToURL:url completion:^(NSData *data, NSError *error) {
        if (error == nil && data) {
            NSError *jsonError;
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError == nil) {
                NSDictionary *dict = [jsonResponse objectForKey:@"rp_result"];
                if ([[dict objectForKey:@"recode"] integerValue] == 0) {
                    delegate.cartVersion = [[dict objectForKey:@"cartVer"] integerValue];
                }
            }
        }
    }];
}

@end
