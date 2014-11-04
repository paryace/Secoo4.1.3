//
//  NSString+Encoding.m
//  MakePoem
//
//  Created by jian zhang on 12-5-23.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import "NSString+Encoding.h"
@implementation NSString (OAURLEncodingAdditions)

#pragma mark -
#pragma mark UTF8 、GB2312  URLEncoding

- (NSString *)URLEncodedUTF8Str
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&amp;=+$,/?%#[] "),
                                            kCFStringEncodingUTF8));
//    [result autorelease];
    return result;
}

- (NSString*)URLDecodedUTF8Str
{
    NSString *result = (NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString *)URLEncodedGB2312Str{
    NSString *result = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&amp;=+$,/?%#[] "),
                                            kCFStringEncodingGB_18030_2000);
    [result autorelease];
    return result;
}

- (NSString *)URLDecodedGB2312Str
{
    NSString *result = (NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            kCFStringEncodingGB_18030_2000);
    [result autorelease];
    return result;

}

#pragma mark -
#pragma mark UTF8 to GB2312 , GB2312 to UTF8
+ (NSString*)UTF8_To_GB2312:(NSString*)utf8string
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [utf8string dataUsingEncoding:encoding];
    return [[[NSString alloc] initWithData:gb2312data encoding:encoding] autorelease];
}

+ (NSString*)GB2312_To_UTF8:(NSString*)gb2312string
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSData* utf8data = [gb2312string dataUsingEncoding:encoding];
    return [[[NSString alloc] initWithData:utf8data encoding:encoding] autorelease];
}


#pragma mark -
#pragma mark Encode Chinese to ISO8859-1 in URL
+(NSString *)EncodeUTF8Str:(NSString *)encodeStr{
	CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");        
	NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingUTF8);        
	NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8) autorelease];
	[preprocessedString release];
	return newStr;        
}

#pragma mark -
#pragma mark Encode Chinese to GB2312 in URL
+(NSString *)EncodeGB2312Str:(NSString *)encodeStr{
	CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");        
	NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000);        
	NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000) autorelease];
	[preprocessedString release];
	return newStr;        
}

@end
