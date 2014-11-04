//
//  PayOnLineModel.h
//  ShowLocalSecooHtml
//
//  Created by zhangchaoqun on 13-8-12.
//  Copyright (c) 2013年 zhangchaoqun. All rights reserved.
//

#import <Foundation/Foundation.h>


//实现在线支付的辅助功能
@interface PayOnLineModel : NSObject
{
    
}

//1、返回当前支持的在线支付方式的状态
+(NSDictionary *)supportedPayModesType;



//2、调用当前的在线支付
-(BOOL)startNavivePayType:(NSString *)type withData:(id)data;



//通过订单号获取TN值
+(NSString *)payOnLineTNFromOrderNumData:(id )data;




@end
