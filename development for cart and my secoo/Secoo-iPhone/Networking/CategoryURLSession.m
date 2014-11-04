//
//  CategoryURLSession.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CategoryURLSession.h"
#import "ImageDownloaderManager.h"

@implementation CategoryURLSession

- (void)parseJsonData:(NSData *)data url:(NSString *)url error:(NSError *)error
{
    if (error) {
        return;
    }
    NSError *jsonError;
    id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    if (jsonError == nil) {
        //NSLog(@"%@", jsonDict);
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = [jsonDict valueForKey:@"rp_result"];
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSArray *categories = [result valueForKey:@"categorys"];
                [self performSelectorOnMainThread:@selector(parseCategory:) withObject:categories waitUntilDone:NO];
            }
        }
        
    }
    else{
        NSLog(@"category connection parsing error %@", jsonError.description);
    }
}

- (void)parseCategory:(NSArray *)categories
{
    int totalNum = [categories count];
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:totalNum];
    NSMutableArray *ids = [NSMutableArray arrayWithCapacity:totalNum];
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:totalNum];
    NSMutableArray *categoryIds = [NSMutableArray arrayWithCapacity:totalNum];
    NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:totalNum];
    NSMutableArray *icons = [NSMutableArray arrayWithCapacity:totalNum];
    NSMutableArray *sortkey = [NSMutableArray arrayWithCapacity:totalNum];
    NSMutableDictionary *imageDict = [NSMutableDictionary dictionaryWithCapacity:totalNum];
    __block int finished = 0;
    int i = 0;
    CategoryDataAccessor *accessor = [[CategoryDataAccessor alloc] init];
    accessor.observerViewController = _observerViewController;
    for (NSDictionary *dict in categories) {
        [sortkey addObject:[NSNumber numberWithInt:i]];
        ++i;
        NSArray *child = [dict objectForKey:@"child"];
        if (child) {
            [children addObject:child];
        }
        NSString *name = [dict objectForKey:@"name"];
        if (name) {
            [names addObject:name];
        }
        NSNumber *_id = [NSNumber numberWithInt:[[dict objectForKey:@"id"] integerValue]];
        if (_id) {
            [ids addObject:_id];
        }
        NSString *categoryId = [dict objectForKey:@"categoryId"];
        if (categoryId) {
            [categoryIds addObject:categoryId];
        }
        NSString *imageUrl = [dict objectForKey:@"imageUrl"];
        if (imageUrls) {
            [imageUrls addObject:imageUrl];
        }
        
        [[ImageDownloaderManager sharedInstance] addImageDowningTask:imageUrl cached:NO completion:^(NSString *url, UIImage *image, NSError *error) {
            if (image) {
                [imageDict setObject:image forKey:url];
            }
            else{
                NSLog(@"empty image");
            }
            finished ++;
            if (finished == totalNum) {
                for (NSString* url in imageUrls) {
                    UIImage *image = [imageDict valueForKeyPath:url];
                    if (image) {
                        [icons addObject:image];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [accessor updateCategory:names icons:icons ids:ids imageURL:imageUrls categoryIds:categoryIds sortKey:sortkey children:children];
                });
            }
        }];
    }
}

@end
