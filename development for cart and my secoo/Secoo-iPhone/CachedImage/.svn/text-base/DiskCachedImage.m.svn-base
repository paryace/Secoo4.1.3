//
//  DiskCachedImage.m
//  LazyTableImages
//
//  Created by Tan Lu on 8/19/14.
//
//

#import "DiskCachedImage.h"
#import "DiskCachedImageManager.h"
#import "ImageDownloaderManager.h"

typedef void (^CompletionHandler)(UIImage *image);

@interface DiskCachedImage ()

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) BOOL didUpdated;
@property(nonatomic, assign) BOOL didCached;
@property(nonatomic, strong) NSString *pathToImage;
@property(nonatomic, strong) dispatch_io_t dispatchIO;

@end

@implementation DiskCachedImage

@synthesize image = _image, didCached = _didCached, didUpdated = _didUpdated, pathToImage = _pathToImage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _image = nil;
        _didUpdated = NO;
        _didCached = NO;
        _pathToImage = nil;
//        static int i = 0;
//        ++i;
//        NSLog(@"init disk image: %d", i);
    }
    return self;
}

- (void)setDiskImage:(UIImage *)image
{
    if (image == nil) {
        if (self.didUpdated) {
            if (self.image) {
                [self writeImageToDisk:self.image];
                self.didUpdated = NO;
            }
        }
        self.image = nil;
    }
    else{
        self.didUpdated = YES;
        self.image = image;
    }
}

- (void)releaseImage
{
    [self setDiskImage:nil];
}

#pragma mark ---------------------get/write image from/to disk -------------------------------

- (void)writeImageToDisk:(UIImage *)image
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    dispatch_data_t d = dispatch_data_create([imageData bytes], [imageData length], dispatch_get_main_queue(), DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    if (self.dispatchIO == nil) {
        return;
    }
    dispatch_io_write(self.dispatchIO, 0, d, queue, ^(bool done, dispatch_data_t data, int error) {
        if (done) {
            if(!error){
                //NSLog(@"succeed");
                _didCached = YES;
            }
            else{
                NSLog(@"writing failed");
            }
        }
    });
}

- (void)getImage:(void (^)(UIImage *image))completionHandler
{
    if (_image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(_image);
            //NSLog(@"disk memory image");
        });
        return;
    }
    else if (!_didCached){
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil);
            //NSLog(@"no cached image");
        });
        return;
    }
    __weak DiskCachedImage *weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.pathToImage error:nil];
    unsigned long long fileSize = [attributes fileSize];
    if (fileSize == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil);
        });
        return;
    }
    dispatch_io_read(self.dispatchIO, 0, (size_t)fileSize, queue, ^(bool done, dispatch_data_t data, int error) {
        if (!error) {
            dispatch_data_apply(data, ^bool(dispatch_data_t region, size_t offset, const void *buffer, size_t size) {
                NSData *imageData = [NSData dataWithBytes:buffer + offset length:size - offset];
                weakSelf.image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(weakSelf.image);
                    //NSLog(@"get image from disk");
                });
                return true;
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil);
                //NSLog(@"no disk image");
            });
        }
    });
}

- (dispatch_io_t)dispatchIO
{
    if (!_dispatchIO) {
        NSString *str = self.pathToImage;
        if (str == nil) {
            _dispatchIO = nil;
            return nil;
        }
        _dispatchIO = dispatch_io_create_with_path(DISPATCH_IO_RANDOM, [self.pathToImage UTF8String], O_RDWR | O_CREAT, 0, dispatch_get_main_queue(), ^(int error) {
            if (error) {
                NSLog(@"error happend when create getting dispatch io %d", error);
            }
            else{
               // NSLog(@"successfully created io");
            }
        });
    }
    return _dispatchIO;
}

- (NSString *)pathToImage
{
    if (_pathToImage == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *folder = [documentsPath stringByAppendingPathComponent:@"lgImageCache"];
        
        BOOL isDir;
        if (![[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir] || !isDir){
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSLog(@"create directory failed");
                return nil;
            }
        }
        
        NSString *imageName = [NSString stringWithFormat:@"%d%d.jpg", arc4random(), arc4random()];
        _pathToImage = [folder stringByAppendingPathComponent:imageName];
    }
    return _pathToImage;
}

- (void)dealloc
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.pathToImage]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.pathToImage error:nil];
    }
//    static int i = 0;
//    ++i;
//    NSLog(@"dealloc disk image: %d", i);
}

@end
