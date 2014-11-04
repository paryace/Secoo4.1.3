//
//  ProductURLSession.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/25/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "ProductURLSession.h"

@implementation ProductURLSession

- (void)parseJsonData:(NSData *)data url:(NSString *)url error:(NSError *)error
{
    if (error) {
        return;
    }
    NSError *jsonError;
    id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    if (jsonError == nil) {
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = [jsonDict valueForKey:@"rp_result"];
            if ([result isKindOfClass:[NSDictionary class]]) {
                int recode = [[result valueForKey:@"recode"] integerValue];
                if (recode == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_delegate && [_delegate respondsToSelector:@selector(getProductInfo:)]) {
                            [_delegate getProductInfo:result];
                        }
                    });
                }
                else{
                    NSString *errorMsg = [result valueForKey:@"errMsg"];
                    if (errorMsg) {
                        NSLog(@"errMsg: %@", errorMsg);
                    }
                    else{
                        NSLog(@"there is something wrong with the network when getting detailed products list");
                    }
                }
            }
        }
        
    }
    else{
        NSLog(@"category connection parsing error %@", jsonError.description);
    }
}
@end
