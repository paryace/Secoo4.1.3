//
//  ImageDownloaderManager.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/22/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "ImageDownloaderManager.h"

@interface ImageDownloaderManager ()

@property(assign, nonatomic) NSUInteger runningTasks;
@property(assign, nonatomic) NSUInteger allowMaxTasks;
@property(strong, nonatomic) NSMutableArray *urls;
@property(strong, nonatomic) NSMutableArray *completions;
@property(strong, nonatomic) NSMutableArray *cacheds;
@property(strong, nonatomic) NSMutableDictionary *runningDownloader;
@end

@implementation ImageDownloaderManager

+(ImageDownloaderManager *)sharedInstance
{
    static ImageDownloaderManager *manager;
    if (manager == nil) {
        manager = [[ImageDownloaderManager alloc] init];
        manager.allowMaxTasks = 20;
        manager.runningTasks = 0;
        NSDate *date = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastDeletedDate"];
        if (([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]) > 7 * 86400) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastDeletedDate"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            dispatch_async(queue, ^{
                [manager deleteOutDatedFiles];
            });
        }
    }
    return manager;
}

- (void)addImageDowningTask:(NSString *)url cached:(BOOL)cached completion:(ImageDownloaderCompletionHandler)completion
{
    if (self.runningTasks < self.allowMaxTasks) {
        ImageDownloaderCompletionHandler managerHandler = ^(NSString *url, UIImage *image, NSError *error){
            if (self.runningTasks > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.runningDownloader removeObjectForKey:url];
                    self.runningTasks = self.runningTasks - 1;
                });
            }
            completion(url, image, error);
        };
        
        ImageDownloader *downloader = [[ImageDownloader alloc] init];
        [self.runningDownloader setObject:downloader forKey:url];
        [downloader startDownloadImageFromURL:url cached:cached completionHandler:managerHandler];
        _runningTasks ++;
    }
    else{
        if ([_urls count] <= 50) {
            NSString *urlStr = [url copy];
            [self.urls addObject:urlStr];
            ImageDownloaderCompletionHandler handler  = [completion copy];
            [self.completions addObject:handler];
            [self.cacheds addObject:[NSNumber numberWithBool:cached]];
        }
    }
}

- (void)cancelSession:(NSString *)url
{
    ImageDownloader *downloader = [self.runningDownloader objectForKey:url];
    if (downloader) {
        [downloader cancel];
        if (self.runningTasks > 0) {
            self.runningTasks --;
        }
        [self.runningDownloader removeObjectForKey:url];
    }
    else{
        [self.urls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *str = (NSString *)obj;
            if ([str isEqualToString:url]) {
                *stop = YES;
                [self.urls removeObjectAtIndex:idx];
                [self.completions removeObjectAtIndex:idx];
                [self.cacheds removeObjectAtIndex:idx];
            }
        }];
    }
}

#pragma mark ----delete outdated file----
- (void)deleteOutDatedFiles
{
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:[ImageDownloader pathToDirectory]];
    NSDictionary *attr = [dirEnum directoryAttributes];
    NSDate *date = [attr fileModificationDate];
    NSString *dirPath = [ImageDownloader pathToDirectory];
    if (([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]) > 2 * 86400) {
        [localFileManager removeItemAtPath:dirPath error:nil];
        return;
    }
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        NSError *error;
        NSDictionary *fileAttr = [localFileManager attributesOfItemAtPath:[dirPath stringByAppendingPathComponent:file] error:&error];
        if (error == nil) {
            NSDate *fileDate = [fileAttr fileModificationDate];
            if (([[NSDate date] timeIntervalSince1970] - [fileDate timeIntervalSince1970]) > 2 * 86400) {
                [localFileManager removeItemAtPath:file error:nil];
            }

        }
    }
}

#pragma mark ----setter and getter------

- (void)setRunningTasks:(NSUInteger)runningTasks
{
    _runningTasks = runningTasks;
    //NSLog(@"running task: %d", runningTasks);
    if (_runningTasks < _allowMaxTasks) {
        if ([_urls count] > 0) {
            NSString *url = [_urls objectAtIndex:0];
            ImageDownloaderCompletionHandler completion = [_completions objectAtIndex:0];
            BOOL cached = [[_cacheds objectAtIndex:0] boolValue];
            [self addImageDowningTask:url cached:cached completion:completion];
            [_urls removeObjectAtIndex:0];
            [_completions removeObjectAtIndex:0];
            [_cacheds removeObjectAtIndex:0];
        }
    }
}

- (NSMutableArray *)urls
{
    if (_urls == nil) {
        _urls = [[NSMutableArray alloc] init];
    }
    return _urls;
}

- (NSMutableArray *)completions
{
    if (_completions == nil) {
        _completions = [[NSMutableArray alloc] init];
    }
    return _completions;
}

- (NSMutableArray *)cacheds
{
    if (_cacheds == nil) {
        _cacheds = [[NSMutableArray alloc] init];
    }
    return _cacheds;
}

- (void)setMaxTasks:(NSUInteger)num
{
    self.allowMaxTasks = num;
}

- (NSMutableDictionary *)runningDownloader
{
    if (_runningDownloader == nil) {
        _runningDownloader = [[NSMutableDictionary alloc] init];
    }
    return _runningDownloader;
}

//debug
- (void)printInfo
{
    NSLog(@"url:%d, c:%d, cache:%d", [_urls count], [_completions count], [_cacheds count]);
    NSLog(@"running tasks:%d", [_runningDownloader count]);
}

@end
