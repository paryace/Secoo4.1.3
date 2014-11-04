//
//  Utils.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/27/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlixPayResult.h"

@interface Utils : NSObject

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label;
+ (NSString *)stringbyRmovingSpaceFromString:(NSString *)string;
+ (BOOL)isValidString:(NSString *)str;

+ (CGSize)getSizeOfString:(NSString *)str ofFont:(UIFont *)font withMaxWidth:(CGFloat)maxWidth;
+ (UIImage *)takeScreenShotOfView:(UIView*)view;
+ (CGRect)adjustImageViewToSize:(CGSize)imageSize inSize:(CGSize)inSize;

+ (void)updateCartBadgeNumberWithNumber:(NSInteger)number;
+ (NSString *)convertToRealUrl:(NSString *)url ofsize:(NSInteger)width;

+ (BOOL)checkNewworkStatusAndWarning:(BOOL)willWarn toView:(UIView*)view;
+ (void)showAlertMessage:(NSString *)message title:(NSString *)title;
+ (NSString*)deviceModelName;
+ (void)updateUpkey;

+ (NSString *)getDeviceUDID;
+ (NSString *)cartProductInfo;
+ (BOOL)isiPhone6Plus;
+ (void)setCartVersion;
//alipay
+ (void)handleAlipayResult:(AlixPayResult *)payResult;

+ (NSString *)moneyTypeWithAreaType:(int)areaType price:(float)price;
+ (NSString *)intMoneyTypeWithAreaType:(int)areaType price:(float)price;
@end
