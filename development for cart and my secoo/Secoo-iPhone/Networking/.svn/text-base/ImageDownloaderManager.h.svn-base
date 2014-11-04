//
//  ImageDownloaderManager.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/22/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloader.h"

@interface ImageDownloaderManager : NSObject

+(ImageDownloaderManager *)sharedInstance;

- (void)addImageDowningTask:(NSString *)url cached:(BOOL)cached completion:(ImageDownloaderCompletionHandler)completion;
- (void)setMaxTasks:(NSUInteger)num;
- (void)cancelSession:(NSString *)url;

- (void)printInfo;
@end
