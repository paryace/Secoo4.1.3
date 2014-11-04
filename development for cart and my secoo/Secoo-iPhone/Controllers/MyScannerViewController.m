//
//  MyScannerViewController.m
//  TestZbar3
//
//  Created by apple on 14-2-17.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "MyScannerViewController.h"
#import "ManagerDefault.h"

@interface MyScannerViewController ()<ZBarReaderDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}

@end

@implementation MyScannerViewController
@synthesize readerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    CGRect rect = CGRectMake(10, 100, 300, 300);
    ZBarReaderView * read = [[ZBarReaderView alloc] init];
    read.torchMode = 0;
    read.frame = rect;
    readerView = read;
    self.view = read;
    readerView.readerDelegate = self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor grayColor];
    
	UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(100, 420, 120, 40);
    [scanButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 290, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 91, 318, 318)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(20, 101, 280, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear:animated];
    [readerView start];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear:animated];
    [readerView stop];
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(20, 101+2*num, 280, 2);
        if (2*num == 298) {
            upOrdown = YES;
        }
    } else {
        num --;
        _line.frame = CGRectMake(20, 101+2*num, 280, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

#pragma mark 条码扫描
- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    NSString * dataStr = nil;
    for(ZBarSymbol *sym in syms) {
        dataStr = sym.data;
        break;
    }
    NSString *scanInfo = [NSString stringWithFormat:@"objc_getScanInfo(\"%@\")",dataStr];
    NSLog(@"scanInfo %@",scanInfo);
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
        [[[ManagerDefault standardManagerDefaults] currentWebView] stringByEvaluatingJavaScriptFromString:scanInfo];
    }];
}

-(void)cancelButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
