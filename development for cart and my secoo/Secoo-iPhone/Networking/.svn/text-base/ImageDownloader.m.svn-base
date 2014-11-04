//
//  ImageDownloader.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "ImageDownloader.h"
#import "LGURLSession.h"
#import <CommonCrypto/CommonDigest.h>
#import "ImageDownloaderManager.h"
#import "DiskCachedImageManager.h"

@interface ImageDownloader ()

@property(nonatomic, strong) NSString *pathToImage;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) LGURLSession *lgsession;
@end

@implementation ImageDownloader

- (ImageDownloader *)init
{
    self = [super init];
    if (self) {
//        static int i = 0;
//        ++i;
//        NSLog(@"init downloader: %d", i);
    }
    return self;
}

- (void)dealloc
{
//    static int i = 0;
//    ++i;
//    NSLog(@"dealloc downloader: %d", i);
}

- (void)startDownloadImageFromURL:(NSString *)url cached:(BOOL)cached completionHandler:(ImageDownloaderCompletionHandler)completionHandler
{
    self.name = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    if (cached) {
        [self getImage:^(UIImage *image) {
            if (image) {
                completionHandler(url, image, nil);
                //NSLog(@"reading web image successfully");
            }
            else{
               // NSLog(@"reading web image successfully without image");
                dispatch_async(dispatch_get_main_queue(), ^{
                    LGURLSession *session = [[LGURLSession alloc] init];
                    self.lgsession = session;
                    [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
                        if (data) {
                            UIImage *image = [UIImage imageWithData:data];
                            completionHandler(url, image, error);
                            if (image && error == nil) {
                                [self writeImageToDisk:image];
                            }
                        }
                        else{
                            completionHandler(url, nil, error);
                        }
                    }];
                });
            }
        }];
    }
    else{
        LGURLSession *session = [[LGURLSession alloc] init];
        self.lgsession = session;
        [session startConnectionToURL:url completion:^(NSData *data, NSError *error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                completionHandler(url, image, error);
            }
            else{
                completionHandler(url, nil, error);
            }
        }];
    }
}

- (void)cancel
{
    [self.lgsession cancel];
}

+ (NSString *)pathToDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *folder = [documentsPath stringByAppendingPathComponent:@"LGWebImageCache"];
    
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir] || !isDir){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"create directory failed");
            return nil;
        }
    }
    return folder;
}

- (NSString *)pathToImage
{
    if (_pathToImage == nil) {
        NSString *folder = [ImageDownloader pathToDirectory];
        NSString *imageName = [NSString stringWithFormat:@"%@", _name];
        _pathToImage = [folder stringByAppendingPathComponent:imageName];
    }
    return _pathToImage;
}

#pragma mark ---------------------get/write image from/to disk -------------------------------

- (void)writeImageToDisk:(UIImage *)image
{
    if (image == nil) {
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    dispatch_async(queue, ^{
        if ([imageData writeToFile:self.pathToImage atomically:NO]) {
            //NSLog(@"write successfully");
        }
        else{
            NSLog(@"write error:%@", self.pathToImage);
        }
    });
}

- (void)getImage:(void (^)(UIImage *image))completionHandler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.pathToImage isDirectory:&isDir] && !isDir) {
        NSError *error;
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.pathToImage error:&error];
        if (error == nil) {
            NSDate *date  = [attributes fileModificationDate];
            //NSLog(@"image downloader reading image %f hour ago", ([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]) / 3600);
            if (([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]) > 2 * 86400) {
                [[NSFileManager defaultManager] removeItemAtPath:self.pathToImage error:nil];
                dispatch_async(queue, ^{
                    completionHandler(nil);
                });
                return;
            }
        }
        NSString *path = self.pathToImage;
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfFile:path];
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                //NSLog(@"read successfully");
                completionHandler(image);
            }
            else{
                //NSLog(@"read without image");
                completionHandler(nil);
            }
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil);
        });
    }
}

- (NSString *) stringFromMD5:(NSString *)str
{
    if(self == nil || [str length] == 0){
        return nil;
    }
    const char *value = [str UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

@end
