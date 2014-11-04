//
//  UserInfoManager.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/29/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "UserInfoManager.h"
#import "AppDelegate.h"

@implementation UserInfoManager

+ (void)setLogState:(BOOL)state
{
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"USERSIGNEDIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)didSignIn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"USERSIGNEDIN"];
}

+ (void)setUserUpKey:(NSString *)upKey
{
    [[NSUserDefaults standardUserDefaults] setObject:upKey forKey:@"USERUPKEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //TODO:测试
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWebView *webView = [((AppDelegate *)[[UIApplication sharedApplication] delegate]) webView];
        NSString *actionString = [NSString stringWithFormat:@"sendUpKeyToJS('%@','%@')", upKey,[self userPhoneNumber]];
        if (webView) {
            [webView stringByEvaluatingJavaScriptFromString:actionString];
        }
    });
}

+ (NSString *)getUserUpKey
{
    NSString *upKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERUPKEY"];
    return upKey;
}

+ (void)setUserID:(NSString *)uid
{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"USERID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserID
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERID"];
    return uid;
}

+ (NSString *)getDeviceUDID
{
    NSString *udid = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERDEVICEUDID"];
    if (udid == nil || [udid isEqualToString:@""]) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        udid = (__bridge NSString *)string;
        NSArray *array = [udid componentsSeparatedByString:@"-"];
        udid = [array componentsJoinedByString:@""];
        CFRelease(string);
        [[NSUserDefaults standardUserDefaults] setObject:udid forKey:@"USERDEVICEUDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return  udid;
}

+ (NSString *)userPhoneNumber
{
    __autoreleasing NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:_USER_ACCOUNT_];
    if ([phoneNumber isEqualToString:@""] || !phoneNumber) {
        return nil;
    }
    return phoneNumber;
}

+ (void)setUserPhoneNumber:(NSString *)phoneNumber
{
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:_USER_ACCOUNT_];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setUserPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"UserPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserPassword
{
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPassword"];
    return password;
}

//last time address id

+ (void)setLastTimeAddressID:(NSString *)addressID
{
    
    [[NSUserDefaults standardUserDefaults] setObject:addressID forKey:[NSString stringWithFormat:@"%@_lastAddress", [UserInfoManager getUserUpKey]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLastTimeAddressID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_lastAddress", [UserInfoManager getUserUpKey]]];
}

+ (void)setLastTimeDeliveryType:(NSString *)deliveryType
{
    [[NSUserDefaults standardUserDefaults] setObject:deliveryType forKey:@"lastTime_deliverType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLastTimeDeliverType
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime_deliverType"];
}

+ (void)setLastTimeWarehouse:(NSString *)warehouse
{
    [[NSUserDefaults standardUserDefaults] setObject:warehouse forKey:@"lastTime_warehouse"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLastTimeWarehouse
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime_warehouse"];
}

+ (void)setLastTimePaytype:(NSString *)payType
{
    [[NSUserDefaults standardUserDefaults] setObject:payType forKey:@"lastTime_payType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLastTimePaytype
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime_payType"];
}

+ (void)setLastTimeMobilePaytype:(NSString *)payType
{
    [[NSUserDefaults standardUserDefaults] setObject:payType forKey:@"lastTime_mobilepayType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLastTimeMobilePaytype
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime_mobilepayType"];
}

///
+ (void)setLastTimePayTaxType:(NSString *)payTaxType
{
    [[NSUserDefaults standardUserDefaults] setObject:payTaxType forKey:@"lastTime_PayTaxType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLastTimePayTaxType
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime_PayTaxType"];
}


@end
