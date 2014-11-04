//
//  ImageDownloader.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImageDownloaderCompletionHandler)(NSString *url, UIImage *image, NSError *error);

@interface ImageDownloader : NSObject

//the block will be executed;
- (void)startDownloadImageFromURL:(NSString *)url cached:(BOOL)cached completionHandler:(ImageDownloaderCompletionHandler)completionHandler;
- (void)cancel;

+ (NSString *)pathToDirectory;

@end
