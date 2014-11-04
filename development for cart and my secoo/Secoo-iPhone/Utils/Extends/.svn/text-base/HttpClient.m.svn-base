//
//  HttpClient.m
//  LBShopMall
//
//  Created by 国翔 韩 on 13-4-2.
//  Copyright (c) 2013年 联龙博通在线服务中心.李成武. All rights reserved.
//

#import "HttpClient.h"

@interface HttpClient ()
{
    BOOL _isFinished;
}

@property(nonatomic,retain)ASIHTTPRequest *currentRequest;//全局的请求，用于取消请求

-(NSString *)requestFromUrl:(NSString *)url method:(NSString *)method error:(NSError **)error;

@end

@implementation HttpClient

@synthesize currentRequest;
@synthesize error=_error;

-(NSString *)requestFromUrl:(NSString *)sendURL method:(NSString *)method error:(NSError **)errorPath
{
    
    NSString * url = sendURL;
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    showWarning = errorPath?NO:YES;
    
    NSLog(@"组合的url=%@",url);
    
    if([method isEqualToString:@"GET"])
    {
        self.currentRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    }
    else {
        NSArray *urlist=[url componentsSeparatedByString:@"?"];
        NSString *paramsString=nil;
        if([urlist count]>1)
        {
            paramsString=[urlist objectAtIndex:1];
        }
        self.currentRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlist objectAtIndex:0]]];
        
        NSMutableData *postData = [NSMutableData dataWithData:[paramsString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        [currentRequest setPostBody:postData];
    }
    [currentRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
//    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",[postData length]]];
//    [request addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"%d",[postData length]]];
    self.error = nil;
    
    [currentRequest setDelegate:self];
    [currentRequest setTimeOutSeconds:60.0f];
    [currentRequest setRequestMethod:method];
    [currentRequest startAsynchronous];
    
    while (!_isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
//    NSError * oldError = currentRequest.error;
    if (errorPath)
    {
        *errorPath = currentRequest.error;
    }
    
    return currentRequest.responseString;
}

-(void)dealloc
{
    self.error=nil;
    [currentRequest clearDelegatesAndCancel];
    self.currentRequest=nil;
    [super dealloc];
}

-(void)cancelRequest
{
    [self.currentRequest clearDelegatesAndCancel];
    _isFinished=YES;
}

#pragma mark - private method

-(NSString *)getRequestFromUrl:(NSString *)url error:(NSError **)error
{
    return [self requestFromUrl:url method:@"GET" error:error];
}

-(NSString *)postRequestFromUrl:(NSString *)url error:(NSError **)error
{
    return [self requestFromUrl:url method:@"POST" error:error];
}

#pragma mark - asirequest delegate
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished %@",request.responseString);
    _isFinished=YES;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.error = request.error;
    NSLog(@"failed[%d 1为提示] %@",showWarning,request.error);

    //处理网络错误
    if(self.currentRequest.error.code == 1){
//        [Utils alertWithTitle:@"提示" message:@"网络连接失败"];
    //        ASIConnectionFailureErrorType = 1,请求失败
    //        ASIRequestTimedOutErrorType = 2,请求超时
    //        ASIAuthenticationErrorType = 3,请求证书错误

        if (showWarning)
        {
//            [noticeWithText:@"网络连接失败"];
        }

    }
    //进行网络请求失败提示
    _isFinished=YES;
}
@end
