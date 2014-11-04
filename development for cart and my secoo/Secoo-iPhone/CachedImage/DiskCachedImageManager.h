//
//  DiskCachedImageManager.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/28/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskCachedImageManager : NSObject

+ (DiskCachedImageManager *)sharedInstance;

- (void)addReadOperation:(NSOperation *)operation;
- (void)addWriteOperation:(NSOperation *)opertion;

- (void)printInfo;
@end
