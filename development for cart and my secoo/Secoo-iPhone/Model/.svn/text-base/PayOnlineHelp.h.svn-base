//
//  PayOnlineHelp.h
//  ShowLocalSecooHtml
//
//  Created by zhangchaoqun on 13-8-5.
//  Copyright (c) 2013年 zhangchaoqun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPPayPluginDelegate.h"
//在线支付辅助
@interface PayOnlineHelp : NSObject<UPPayPluginDelegate>
@property (nonatomic,copy) NSString * callBackFunc;

+(PayOnlineHelp *)defaultPayOnlineHelp;

//使用TN调用插件支付
-(BOOL)payOnlineWithTn:(NSString *)tn;


@end
