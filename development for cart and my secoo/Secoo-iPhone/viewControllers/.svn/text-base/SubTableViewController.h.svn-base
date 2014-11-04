//
//  SubTableViewController.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTableViewCell.h"

typedef enum {
    SubTableViewType1,
    SubTableViewType2,
} SubTableViewType;

@protocol SubTableViewControllerDelegate <NSObject>

- (void)didSelectAt:(NSString *)type withTypeID:(NSString *)typeID cellText:(NSString *)text;

@end

@interface SubTableViewController : UITableViewController

@property(assign, nonatomic) SubTableViewState state;
@property(assign, nonatomic) SubTableViewType type;
@property(strong, nonatomic) IBOutlet UITableView *tableView;

//data source for table view
@property(nonatomic, strong) NSArray *orderFilterList;
@property(nonatomic, strong) NSArray *brandFilterList;
@property(nonatomic, strong) NSArray *categoryFilterList;

@property(nonatomic, copy) NSString *orderType;
@property(nonatomic, copy) NSString *brandType;
@property(nonatomic, copy) NSString *classificationType;

@property(nonatomic, weak) NSMutableDictionary *selectedFirstFilter;
@property(nonatomic, weak) NSMutableDictionary *selectedSecondFilter;
@property(nonatomic, weak) NSMutableDictionary *selectedThirdFilter;

@property(nonatomic, assign) id<SubTableViewControllerDelegate> delegate;

@end
