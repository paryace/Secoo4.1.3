//
//  CategoryDetailTableViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDetailURLSession.h"
#import "ImageDownloader.h"
#import "SubTableViewController.h"
#import "MBProgressHUD+Add.h"
#import "DiskCachedImageManager.h"

typedef enum : NSUInteger {
    ListCategoryType,
    ListBrandType,
    ListSearchType,
    ListWarehouseType,
} ListType;

@interface CategoryDetailTableViewController : UIViewController<DetailProductsDelegate, SubTableViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, copy) NSString* categoryId;
@property(nonatomic, copy) NSString* brandId;
@property(nonatomic, copy) NSString* keyWord;
@property(nonatomic, copy) NSString* wareHouseId;

@property(nonatomic, assign) ListType listType;
//search example         
@property(nonatomic, copy) NSString *baseURL;
@end
