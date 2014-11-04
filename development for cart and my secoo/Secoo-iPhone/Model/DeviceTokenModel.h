//
//  DeviceTokenModel.h
//  IOS_SECOO_20130503
//
//  Created by zhangchaoqun on 13-8-12.
//  Copyright (c) 2013年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
//设备令牌处理对象

@interface DeviceTokenModel : NSObject
{
    
}
@property (nonatomic,retain) NSURLConnection * deviceTokenConnetion;

//提供方法
//是否满足自身请求的条件
-(BOOL)needRequestRegisterAgainForToken;

//注册消息通知
-(void)registerForRemoteNotificationToGetToken;

//发送设备令牌
-(void)sendProviderDeviceTokenDataStr:(NSString *)tokenData;

//发送消息，告知服务器，消息计数归0
-(void)resetBadgeNumberOnProviderWithDeviceToken;

//转换获取的Data为标准的字符串
+(NSString *)normalTokenStrWithReceivedTokenData:(NSData *)data;



@end
