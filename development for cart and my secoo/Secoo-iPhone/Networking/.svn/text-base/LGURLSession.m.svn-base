//
//  LGURLSession.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "LGURLSession.h"
#import "Reachability.h"

@interface LGURLSession ()

@property(nonatomic, strong) NSURLSession *session;
//@property(nonatomic, copy) CompletionHandler completionhandler;
@end

@implementation LGURLSession

- (void)startConnectionToURL:(NSString *)url withData:(NSString *)json completion:(CompletionHandler)completion
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [request setValue:version forHTTPHeaderField:@"appver"];
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    [request setValue:iosVersion forHTTPHeaderField:@"iosVersion"];
    [request setValue:[Utils deviceModelName] forHTTPHeaderField:@"deviceModel"];
    [request setValue:@"0" forHTTPHeaderField:@"product"];
    
    if (json) {
        [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
    }
    else{
        [request setHTTPMethod:@"GET"];
        [request setHTTPShouldUsePipelining:YES];
    }
    [self startConnectionWithRequest:request withData:json completion:completion];
}

- (void)startConnectionWithRequest:(NSURLRequest *)request withData:(NSString *)json completion:(CompletionHandler)completion
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return;
    }
    if ([NSURLSession class]) {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.session = session;
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (completion) {
                completion(data, error);
            }
            else{
                [self parseJsonData:data url:[[response URL] absoluteString] error:error];
            }
            
            if (error != nil) {
                NSLog(@"LGurlsession error %@", error.description);
            }
        }];
        [dataTask resume];
    }
    else{
        //NSLog(@"initial connection");
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (completion) {
                //NSLog(@"get data completion");
                completion(data, connectionError);
            }
            else{
                //NSLog(@"get data parse");
                [self parseJsonData:data url:[[response URL] absoluteString] error:connectionError];
            }
            if (connectionError != nil) {
                NSLog(@"LG connection error %@", connectionError.description);
            }
        }];
    }

}

- (void)startConnectionToURL:(NSString *)url completion:(CompletionHandler)completion
{
    [self startConnectionToURL:url withData:nil completion:completion];
}

- (void)startConnectionToURL:(NSString *)url
{
    [self startConnectionToURL:url completion:nil];
}

- (void)cancel
{
    if ([NSURLSession class]) {
        if (self.session) {
            [self.session invalidateAndCancel];
        }
    }
}

- (void)parseJsonData:(NSData *)data url:(NSString *)url error:(NSError *)error
{
    if (error == nil) {
    }
    else{
        NSLog(@"LGURLSession parson error %@", error.description);
    }
}

@end
