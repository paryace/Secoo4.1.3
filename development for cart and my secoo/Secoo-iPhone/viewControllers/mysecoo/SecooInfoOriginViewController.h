//
//  SecooInfoOriginViewController.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-15.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum secooInfoName {
    SecooInfoOrigin,//寺库起源
    SecooInfoHonor,//集团荣誉
    SecooInfoShopstore,//网上商城
    SecooInfoClub,//库会所
    SecooInfoAuthenticate,//鉴定中心
    SecooInfoConserve,//养护工厂
    SecooInfoSchool,//寺库商学院
}SecooInfoName;

@interface SecooInfoOriginViewController : UIViewController

@property(nonatomic, assign) SecooInfoName secooInfoName;
@end
