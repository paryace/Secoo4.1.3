//
//  HttpClient.h
//  LBShopMall
//
//  Created by 国翔 韩 on 13-4-2.
//  Copyright (c) 2013年 联龙博通在线服务中心.李成武. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


//完成对象URL请求，适用于单独逻辑的网络请求，对于同一页面多个不同请求的，可以考虑创建多个不同对象使用多线程请求
//可以与父类结合
@interface HttpClient : NSObject<ASIHTTPRequestDelegate>
{
    BOOL showWarning;

}
@property(nonatomic,retain)NSError *error;//记录请求网络错误和服务器返回的错误

//修改后的变量，可以通过error参数的有无，确定是否给与用户提示
-(NSString *)getRequestFromUrl:(NSString *)url error:(NSError **)error;
-(NSString *)postRequestFromUrl:(NSString *)url error:(NSError **)error;


-(void)cancelRequest;//取消当前HttpClient对象正在的请求

@end
