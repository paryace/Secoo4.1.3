//
//  RootViewController.h
//  Secoo-iPhone
//
//  Created by Paney on 14-7-4.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "BasicViewController.h"
#import "SearchDisplayView.h"
#import "CustomSearchBar.h"
#import "AppDelegate.h"
#import "UserInfoManager.h"

@interface RootViewController : BasicViewController<UISearchBarDelegate, SearchDisplayViewDelegate>

@property (nonatomic, strong) UIImageView       *line;
@property (nonatomic, strong) SearchDisplayView *searchDisplayView;
@property (nonatomic, strong) CustomSearchBar   *searchBar;

//设备信息
@property(nonatomic,copy) NSString *mac;
@property(nonatomic,copy) NSString *idfa;
@property(nonatomic,copy) NSString *idfv;
@property(nonatomic,copy) NSString *from;
@property(nonatomic,copy) NSString *screenwidth;
@property(nonatomic,copy) NSString *screenheight;
@property(nonatomic,copy) NSString *phonetype;
@property(nonatomic,copy) NSString *version;
@property(nonatomic,copy) NSString *phonename;
@property(nonatomic,copy) NSString *platform;
@property(nonatomic,copy) NSString *channel;
@property(nonatomic,copy) NSString *ownername;
@property(nonatomic,copy) NSString *localizedmodel;
@property(nonatomic,copy) NSString *systemname;

- (instancetype)initWithItemIndex:(NSUInteger)itemIndex;

@end
