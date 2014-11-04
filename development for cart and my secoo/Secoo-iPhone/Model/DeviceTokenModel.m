//
//  DeviceTokenModel.m
//  IOS_SECOO_20130503
//
//  Created by zhangchaoqun on 13-8-12.
//  Copyright (c) 2013年 secoo. All rights reserved.
//

#import "DeviceTokenModel.h"
#import "HttpClient.h"
#import "JSONKit.h"
#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5Addition.h"

#define DeviceTokenRegisteredKEY @"DeviceTokenRegisteredKEY"
#define DeviceTokenStringKEY @"DeviceTokenStringKEY"
#define DeviceTokenFirstRegistKEY @"DeviceTokenFirstRegistKEY"
#define DeviceTokenRegistNoticeIntervalDays 1

#define DeviceTokenMD5 @"BE3825DF52D3D3AD8E126618848F3C1C"
#define URL_OF_PUSH_NOTIFICATION_SERVER @"http://i.secoo.com/addAppleToken.action"
//#define URL_OF_PUSH_NOTIFICATION_SERVER @"http://192.168.2.85:8080/addAppleToken.action"
//http:
//i.secoo.com/addAppleToken?token=123&udid=asdfasdf&md5res=059AE35FD8AECFCF244422747300CF7F

@implementation DeviceTokenModel
@synthesize deviceTokenConnetion;

-(void)dealloc
{
    self.deviceTokenConnetion = nil;
    [super dealloc];
}

#pragma mark PrivateMethods

-(void)requestDeviceTokenConnectWithBody:(NSString *)body
{
    NSString *baseurl = [NSString stringWithFormat:@"%@?",URL_OF_PUSH_NOTIFICATION_SERVER];  //服务器地址
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",baseurl,body];
    //检查网络连接
//    http:
    //192.168.2.85:8080/addAppleToken?token=123&udid=asdfasdf&md5res=059AE35FD8AECFCF244422747300CF7F
//    urlStr =@"http://192.168.2.40/b2c/wap/unionpay/unionpay.jsp";
    HttpClient *client=[[[HttpClient alloc] init] autorelease];
    
    NSError * error = nil;
    NSString * result = [client postRequestFromUrl:urlStr error:&error];
    
    NSString * errorStr = nil;
    NSString * resultTN = nil;
    
    if(error)
    {
        errorStr = error.domain;
    }else
    {
//        NSDictionary * dic = [result objectFromJSONString];
//        resultTN =[dic valueForKey:@"tn"];
//        if (!resultTN)
//        {
//            errorStr =[dic valueForKey:@"respCode"];
//        }
        
    }
    NSLog(@"requestDeviceTokenConnectWithBody %@ %@",resultTN,errorStr);
    
    //NSString * rsp = nil;
    //针对消息计数通知，目前认为不需要返回值
    //在发送tokenstr时，收到true，表示tokenStr上传成功
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([@"success" isEqualToString:result])
    {
        [userDefaults setBool:YES forKey:DeviceTokenRegisteredKEY];
    }
}

//是否满足自身请求的条件
-(BOOL)needRequestRegisterAgainForToken
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double timeCount = [userDefaults doubleForKey:DeviceTokenFirstRegistKEY];
    if (timeCount==0) {
        return YES;
    }
    
    NSDate * lastestDate = [NSDate dateWithTimeIntervalSince1970:timeCount];
    double countNum = [lastestDate timeIntervalSinceNow];//该数为负值
    double noticeNum = DeviceTokenRegistNoticeIntervalDays * 24 * 60 *60;
    
    NSLog(@"DeviceTokenRegistNoticeIntervalDays %f %f",countNum,noticeNum);
    if (countNum+noticeNum<=0) {
//        return YES;
    }
    return NO;
}


#pragma mark PublicMethods

//注册消息通知
-(void)registerForRemoteNotificationToGetToken
{
    //注册Device Token, 需要注册remote notification
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    double timeCount = [userDefaults doubleForKey:DeviceTokenFirstRegistKEY];
    if (![userDefaults boolForKey:DeviceTokenRegisteredKEY])   //如果没有将令牌发送到服务器
    {//在推送令牌没有上传成功的条件下
        
        //如果获取令牌成功，但是上传没成功
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * tokenStr = [userDefaults valueForKey:DeviceTokenStringKEY];
        if (tokenStr)
        {
            [self sendProviderDeviceTokenDataStr:tokenStr];
            return;
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeSound];
        });

        NSDate * date = [NSDate date];
        [userDefaults setDouble:[date timeIntervalSince1970] forKey:DeviceTokenFirstRegistKEY];
        
    }
    
}

//发送设备令牌
-(void)sendProviderDeviceTokenDataStr:(NSString *)tokenStr
{
    NSLog(@"sendProviderDeviceTokenData %@",tokenStr);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:tokenStr forKey:DeviceTokenStringKEY];
    
//    uniqueGlobalDeviceIdentifier
    
    NSString * udid = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    NSString * md5Str = [NSString stringWithFormat:@"%@&%@&%@",tokenStr,udid,DeviceTokenMD5];
    NSString * md5Result = [md5Str stringFromMD5];
    
//    token=123&udid=asdfasdf&md5res=059AE35FD8AECFCF244422747300CF7F
    NSString *body = [NSString stringWithFormat:@"token=%@&udid=%@&md5res=%@",tokenStr,udid,md5Result];
    
    [self requestDeviceTokenConnectWithBody:body];
}

//发送消息，告知服务器，消息计数归0
-(void)resetBadgeNumberOnProviderWithDeviceToken;
{
    //此功能可以不去实现
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * tokenStr = [userDefaults valueForKey:DeviceTokenStringKEY];
    if (!tokenStr)
    {
        return;
    }
    NSString *body = [NSString stringWithFormat:@"action=setbadge&token=%@", tokenStr];
    [self requestDeviceTokenConnectWithBody:body];
}

//转换获取的Data为标准的字符串
+(NSString *)normalTokenStrWithReceivedTokenData:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    NSString * tokenString2= [deviceTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString * tokenString = [tokenString2 stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString * tokenString1 = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return tokenString1;
}

@end
