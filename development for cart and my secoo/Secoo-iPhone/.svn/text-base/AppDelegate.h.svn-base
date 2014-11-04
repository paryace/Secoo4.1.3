//
//  AppDelegate.h
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "DetailViewController.h"
#import "Reachability.h"
#import <CoreData/CoreData.h>
#import "CategoryTableViewController.h"
#import "MobClick.h"
#import "ManagerDefault.h"
#import "BrandViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, WXApiDelegate, sendMsgToWeChatViewDelegate>
{
    enum WXScene _scene;
}

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) UITabBarController *tabViewController;
@property (weak, nonatomic) UIWebView *webView;

@property (assign, nonatomic) NSInteger cartVersion;

- (UINavigationController *)getNavigationVC:(NSInteger)index;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
