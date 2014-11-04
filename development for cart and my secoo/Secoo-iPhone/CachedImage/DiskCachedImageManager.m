//
//  DiskCachedImageManager.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/28/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "DiskCachedImageManager.h"

@interface DiskCachedImageManager ()

@property(strong, nonatomic) NSOperationQueue *readQueue;
@property(strong, nonatomic) NSOperationQueue *writeQueue;

@end

@implementation DiskCachedImageManager

+ (DiskCachedImageManager *)sharedInstance
{
    static DiskCachedImageManager *manager;
    if (manager == nil) {
        manager = [[DiskCachedImageManager alloc] init];
        NSDate *date = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastDiskDeletedDate"];
        if (([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]) > 7 * 86400) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastDiskDeletedDate"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            dispatch_async(queue, ^{
                [manager deleteAllFiles];
            });
        }
    }
    return manager;
}


- (void)addReadOperation:(NSOperation *)operation
{
    if ([_readQueue operationCount] <= 20) {
        [self.readQueue addOperation:operation];
    }
}

- (void)addWriteOperation:(NSOperation *)opertion
{
    if ([_writeQueue operationCount] <= 20) {
        [self.writeQueue addOperation:opertion];
    }
}

#pragma mark ----delete outdated file----
- (void)deleteAllFiles
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *folder = [documentsPath stringByAppendingPathComponent:@"lgImageCache"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        [[NSFileManager defaultManager] removeItemAtPath:folder error:nil];
    }
}


#pragma mark ---setter/getter--------
- (NSOperationQueue *)readQueue
{
    if (_readQueue == nil) {
        _readQueue = [[NSOperationQueue alloc] init];
        [_readQueue setMaxConcurrentOperationCount:10];
    }
    return _readQueue;
}

- (NSOperationQueue *)writeQueue
{
    if (_writeQueue == nil) {
        _writeQueue = [[NSOperationQueue alloc] init];
        [_writeQueue setMaxConcurrentOperationCount:5];
    }
    return _writeQueue;
}

- (void)printInfo
{
    NSLog(@"writing operation:%d", [_writeQueue operationCount]);
    NSLog(@"reading operation:%d", [_readQueue operationCount]);
}

@end
