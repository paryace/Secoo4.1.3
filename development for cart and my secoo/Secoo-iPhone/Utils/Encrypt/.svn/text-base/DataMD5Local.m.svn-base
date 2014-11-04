//
//  DataMD5Local.m
//  IOS_SECOO_20130503
//
//  Created by zhangchaoqun on 13-8-12.
//  Copyright (c) 2013年 secoo. All rights reserved.
//

#import "DataMD5Local.h"
#import "NSString+MD5Addition.h"

#define MD5LOCALKey @"IT4L9XTP65N2TQFRPGM93T4X0TTNTVSQ"

@implementation DataMD5Local

- (NSString *)algorithmName {
	return @"localMD5";
}

- (NSString *)signString:(NSString *)string
{
    NSString * totalStr = [NSString stringWithFormat:@"%@|%@",string,MD5LOCALKey];
    NSString * md5Str =[totalStr stringFromMD5];
    return [md5Str uppercaseString];
	return @"";
}

- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString
{
    NSString * totalStr = [NSString stringWithFormat:@"%@|%@",string,MD5LOCALKey];
    NSString * verSign = [totalStr stringFromMD5];
    NSString * lastSign = [verSign uppercaseString];
    return [signString isEqualToString:lastSign];
}

@end
