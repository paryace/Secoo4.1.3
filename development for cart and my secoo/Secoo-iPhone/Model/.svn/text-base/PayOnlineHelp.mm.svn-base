//
//  PayOnlineHelp.m
//  ShowLocalSecooHtml
//
//  Created by zhangchaoqun on 13-8-5.
//  Copyright (c) 2013年 zhangchaoqun. All rights reserved.
//

#import "PayOnlineHelp.h"
#import "UPPayPlugin.h"
#import "AppDelegate.h"
#import "ManagerDefault.h"
#import "MobClick.h"

@implementation PayOnlineHelp
@synthesize callBackFunc;

+(PayOnlineHelp *)defaultPayOnlineHelp
{
    static PayOnlineHelp *defaultPayOnlineHelp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultPayOnlineHelp  = [[PayOnlineHelp alloc] init];
    });
    
    return defaultPayOnlineHelp;
}

//使用TN调用插件支付
-(BOOL)payOnlineWithTn:(NSString *)tn
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *controller = delegate.window.rootViewController;
    
    return [UPPayPlugin startPay:tn mode:@"00" viewController:controller delegate:self];
    return NO;
}


#pragma mark UPPayPluginDelegate
-(void)UPPayPluginResult:(NSString*)result
{
    UIWebView *web = [ManagerDefault standardManagerDefaults].currentWebView;
    NSString * resultCallString = [NSString stringWithFormat:@"%@('%@');",self.callBackFunc,result];
    [web stringByEvaluatingJavaScriptFromString:resultCallString];
    
    NSString* msg = [NSString stringWithFormat:@"支付结果:%@", result];
    NSLog(@"UPPayPluginResult %@ resultCallString %@",msg,resultCallString);
    
    //友盟统计支付结果
    if ([result isEqualToString:@"success"]) {
        [MobClick event:@"iOS_zhifuchenggong_pv"];
        [[ManagerDefault standardManagerDefaults] UMengAnalyticsUVWithEvent:@"iOS_zhifuchenggong_uv"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateNow = [NSDate date];
        NSString *dateNowString = [formatter stringFromDate:dateNow];
        if ([dateNowString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"registerSuccess"]]) {
            //当天注册成功当天就提交订单
            [MobClick event:@"iOS_newDingdan"];
        }
    }
}


@end
