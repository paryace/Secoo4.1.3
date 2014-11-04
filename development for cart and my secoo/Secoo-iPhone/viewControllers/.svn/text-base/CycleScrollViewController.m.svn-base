//
//  CycleScrollViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/27/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "CycleScrollViewController.h"
#import "ManagerDefault.h"

@interface CycleScrollViewController (){
    BOOL _showStatusBar;
}

@end

@implementation CycleScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _showStatusBar  = NO;
    if (_IOS_7_LATER_) {
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    //友盟统计
    [MobClick beginLogPageView:@"showBigImage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _showStatusBar = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    //友盟统计
    [MobClick endLogPageView:@"showBigImage"];
}

- (BOOL)prefersStatusBarHidden
{
    return !_showStatusBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
