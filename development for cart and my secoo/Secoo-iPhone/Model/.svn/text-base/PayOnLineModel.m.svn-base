//
//  PayOnLineModel.m
//  ShowLocalSecooHtml
//
//  Created by zhangchaoqun on 13-8-12.
//  Copyright (c) 2013年 zhangchaoqun. All rights reserved.
//

#import "PayOnLineModel.h"
#import "PayOnlineOrder.h"
#import "PayOnlineHelp.h"
#import "HttpClient.h"
#import "JSONKit.h"
#import "DataSigner.h"
#import "DataVerifier.h"
//支付宝钱包支付
#define PayOnLine_AlixPay @"AlixPay"

//支付宝快捷支付
#define PayOnLine_SafePay @"SafePay"

//银联支付
#define PayOnLine_UnionPay @"UnionPay"


@implementation PayOnLineModel


//1、返回当前支持的在线支付方式
+(NSDictionary *)supportedPayModesType
{
    NSMutableArray * modes = [NSMutableArray array];
    [modes addObject:PayOnLine_AlixPay];
    [modes addObject:PayOnLine_SafePay];
    [modes addObject:PayOnLine_UnionPay];
    
    NSMutableDictionary * modeDic = [NSMutableDictionary dictionary];
    NSString * safety = @"safepay://alipayclient/";
    NSString * alixPay = @"alipay://alipayclient/";
    
    NSURL *safepayUrl = [NSURL URLWithString:safety];
    NSURL *alipayUrl = [NSURL URLWithString:alixPay];
    
    [modeDic setValue:@"0" forKey:PayOnLine_AlixPay];
    [modeDic setValue:@"0" forKey:PayOnLine_SafePay];
    
    [modeDic setValue:@"1" forKey:PayOnLine_UnionPay];
    if ([[UIApplication sharedApplication] canOpenURL:alipayUrl])
    {
        [modeDic setValue:@"1" forKey:PayOnLine_AlixPay];
    }
    if ([[UIApplication sharedApplication] canOpenURL:safepayUrl])
    {
        [modeDic setValue:@"1" forKey:PayOnLine_SafePay];
    }
    return modeDic;
}

//2、调用当前的在线支付
-(BOOL)startNavivePayType:(NSString *)type withData:(id)data
{
    NSDictionary * dic = [[self class] supportedPayModesType];
    NSString * value = [dic valueForKey:type];
    if (!value||![value isEqualToString:@"1"])
    {
        return NO;
    }
    
    if ([type isEqualToString:PayOnLine_UnionPay])//银联支付
    {
        PayOnlineHelp * help =[PayOnlineHelp defaultPayOnlineHelp];
        //对TN进行请求
        NSString * orderId = [data valueForKey:@"orderid"];
        NSString * uuid =[data valueForKey:@"userid"];
//        NSDictionary * dic = nil;
        help.callBackFunc = [data  valueForKey:@"callBack"];
        PayOnlineOrder * order = [[PayOnlineOrder alloc] init];
        order.uuid = uuid;
        order.orderId = orderId;
        order.orderOt = @"1";
        order.amount = @"10000";
        NSString * tn = [[self class] payOnLineTNFromOrderNumData:order];
        [order release];
        
        if (!tn) {
            return NO;
        }
        
        return  [help payOnlineWithTn:tn];
    }
    return TRUE;
}


//通过订单号获取TN值
+(NSString *)payOnLineTNFromOrderNumData:(id)data;
{
    NSString * forSign = [data stringForSign];
    id<DataSigner> sign = CreateMD5DataSigner();
    NSString * signStr = [sign signString:forSign];
    
    NSString * totalStr = [data description];
    NSString * postStr = [NSString stringWithFormat:@"%@&%@=%@",totalStr,@"sign",signStr];
    
    NSMutableString * urlStr =[NSMutableString string];
    //检查网络连接
    [urlStr appendString:@"http://pay.secoo.com/b2c/wap/unionpay/unionpay.jsp"];
    [urlStr appendFormat:@"?%@",postStr];
    HttpClient *client=[[[HttpClient alloc] init] autorelease];
    
    NSError * error = nil;
    NSString * result = [client postRequestFromUrl:urlStr error:&error];
    
    //由结果中读取
//    NSLog(@"%@ %@",result,error);
    
    NSString * errorStr = nil;
    NSString * resultTN = nil;
    
    if(error)
    {
        errorStr = error.domain;
    }else
    {
        NSDictionary * dic = [result objectFromJSONString];
        resultTN =[dic valueForKey:@"tn"];
        NSString * signStr = [dic valueForKey:@"sign"];
        id<DataVerifier> check = CreateMD5DataVerifier();
        BOOL verifier = [check verifyString:resultTN withSign:signStr];
        NSLog(@"验签结果%d",verifier);
        
        if (!verifier)
        {
            resultTN = nil;
        }
        
        if (!resultTN)
        {
            errorStr =[dic valueForKey:@"respMsg"];     
        }

    }
    if (errorStr)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:errorStr
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }

    NSLog(@"payOnLineTNFromOrderNum %@ %@",resultTN,errorStr);
    
    return resultTN;
}



@end

