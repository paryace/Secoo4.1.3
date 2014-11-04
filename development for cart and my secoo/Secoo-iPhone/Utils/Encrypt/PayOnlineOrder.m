//
//  PayOnlineOrder.m
//  IOS_SECOO_20130503
//
//  Created by zhangchaoqun on 13-8-13.
//  Copyright (c) 2013年 secoo. All rights reserved.
//

#import "PayOnlineOrder.h"

@implementation PayOnlineOrder
@synthesize orderId;
@synthesize orderOt;
@synthesize uuid;
-(void)dealloc
{
    self.orderId = nil;
    self.orderOt = nil;
    self.uuid = nil;
    [super dealloc];
}
-(NSString *)stringForSign
{
    NSMutableString * discription = [NSMutableString string];
//	[discription appendFormat:@"uid=%@", self.uuid ? self.uuid : @""];
//	[discription appendFormat:@"|oid=%@", self.orderId ? self.orderId : @""];
//	[discription appendFormat:@"|ot=%@", self.orderOt ? self.orderOt : @""];
    [discription appendFormat:@"%@", self.uuid ? self.uuid : @""];
	[discription appendFormat:@"|%@", self.orderId ? self.orderId : @""];
	[discription appendFormat:@"|%@", self.orderOt ? self.orderOt : @""];
    
    return discription;
}

-(NSString *)description
{
    NSMutableString * discription = [NSMutableString string];
	[discription appendFormat:@"uid=%@", self.uuid ? self.uuid : @""];
	[discription appendFormat:@"&oid=%@", self.orderId ? self.orderId : @""];
	[discription appendFormat:@"&ot=%@", self.orderOt ? self.orderOt : @""];
    [discription appendFormat:@"&amount=%@", self.amount ? self.amount : @""];
	return discription;
}


@end
