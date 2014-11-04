//
//  DiskCachedImage.h
//  LazyTableImages
//
//  Created by Tan Lu on 8/19/14.
//
//

#import <Foundation/Foundation.h>

@interface DiskCachedImage : NSObject

//set image;
- (void)setDiskImage:(UIImage *)image;

//get the image; the completionHandler is executed on main thread
- (void)getImage:(void (^)(UIImage *image))completionHandler;

//release image from memory and write to disk by setting image nil
- (void)releaseImage;


@end
