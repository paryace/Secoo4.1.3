//
//  MyScannerViewController.h
//  TestZbar3
//
//  Created by apple on 14-2-17.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface MyScannerViewController : UIViewController< ZBarReaderViewDelegate >

@property (nonatomic, strong) UIImageView    * line;
@property (nonatomic, strong) ZBarReaderView *readerView;

@end
