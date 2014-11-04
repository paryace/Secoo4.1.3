//
//  BasicViewController.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "BasicViewController.h"
#import "UINavigationBar+CustomNavBar.h"


@interface BasicViewController ()

@end

@implementation BasicViewController

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
    [self.navigationController.navigationBar customNavBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.openNewPage = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoginDelegate
- (void)didLogin
{
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"sendLoginResult()"];
}
- (void)didCancelLogin
{
    
}

@end
