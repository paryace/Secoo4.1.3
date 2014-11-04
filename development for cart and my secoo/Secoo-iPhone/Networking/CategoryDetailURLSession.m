//
//  CategoryDetailURLSession.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CategoryDetailURLSession.h"

@implementation CategoryDetailURLSession

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
                    NSArray *products = [result valueForKey:@"productlist"];
                    NSArray *filterList = [result valueForKey:@"filterlist"];
                    int maxPage = [[result valueForKey:@"maxPage"] integerValue];
                    int currPage = [[result valueForKey:@"currPage"] integerValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_delegate && [_delegate respondsToSelector:@selector(getProducts:filterList:maxPage:currPage:)]) {
                            [_delegate getProducts:products filterList:filterList maxPage:maxPage currPage:currPage];
                        }
                    });
                }
                else{
                    NSString *errorMsg = [result valueForKey:@"errMsg"];
                    if (errorMsg) {
                        NSLog(@"%@", errorMsg);
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
