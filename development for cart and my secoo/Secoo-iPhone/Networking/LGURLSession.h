//
//  LGURLSession.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionHandler)(NSData *data, NSError *error);

@interface LGURLSession : NSObject

- (void)startConnectionToURL:(NSString *)url;
- (void)startConnectionToURL:(NSString *)url completion:(CompletionHandler)completion;
- (void)startConnectionToURL:(NSString *)url withData:(NSString *)json completion:(CompletionHandler)completion;
- (void)startConnectionWithRequest:(NSURLRequest *)request withData:(NSString *)json completion:(CompletionHandler)completion;

- (void)cancel;
@end
