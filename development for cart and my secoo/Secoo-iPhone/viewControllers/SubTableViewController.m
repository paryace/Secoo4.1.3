//
//  SubTableViewController.m
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/21/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import "SubTableViewController.h"

#define SubCellIdentifier @"subcellIdentifier"

@interface BrandModel : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *brandID;
@end

@implementation BrandModel

@synthesize name = _name, brandID = _brandID;
@end

@interface SubTableViewController ()

@end

@implementation SubTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[SubTableViewCell class] forCellReuseIdentifier:SubCellIdentifier];
    self.tableView.rowHeight = 50;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"selectPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"selectPage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    switch (_state) {
        case SubTableViewStateRank:
            return 1;
        case SubTableViewStateBrand:
            return [_brandFilterList count];
        case SubTableViewStateClassificaton:
            return 1;
        case SubTableViewStateFilter:
            return 1;
        default:
            return 1;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (_state) {
        case SubTableViewStateRank:
            return [_orderFilterList count];
        case SubTableViewStateBrand:
            return [[_brandFilterList objectAtIndex:section] count];
        case SubTableViewStateClassificaton:
            return [_categoryFilterList count];
        case SubTableViewStateFilter:
            return 10;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubCellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(SubTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = @"LG";
    if (_state == SubTableViewStateRank) {
        str = [[_orderFilterList objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.contentLabel.text = str;
        if ([[[_orderFilterList objectAtIndex:indexPath.row
            ] valueForKey:@"id"] isEqualToString:[_selectedFirstFilter valueForKey:self.orderType]]) {
            //[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //TODO: change the color of text
            cell.contentLabel.textColor = [UIColor redColor];
        }
        else{
            cell.contentLabel.textColor = [UIColor blackColor];
        }
    }
    else if (_state == SubTableViewStateBrand){
        NSArray *array;
        BrandModel *model;
        array = [_brandFilterList objectAtIndex:indexPath.section];
        model = [array objectAtIndex:indexPath.row];
        str = model.name;
        cell.contentLabel.text = str;
        if (indexPath.row == 0) {
            cell.indexLabel.text = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
        }
        else{
            cell.indexLabel.text = nil;
        }
        
        //if user selected it before, display it as selected
        if ([model.brandID isEqualToString:[_selectedSecondFilter valueForKey:self.brandType]]) {
            //[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //NSLog(@"brandID %@, %@,", model.brandID, [_selectedSecondFilter valueForKey:self.brandType]);
            cell.contentLabel.textColor = [UIColor redColor];
        }
        else{
            cell.contentLabel.textColor = [UIColor blackColor];
        }
    }
    else if (_state == SubTableViewStateClassificaton){
        str = [[_categoryFilterList objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.contentLabel.text = str;
        if ([[[_categoryFilterList objectAtIndex:indexPath.row
               ] valueForKey:@"id"] isEqualToString:[_selectedThirdFilter valueForKey:self.classificationType]]) {
            //[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.contentLabel.textColor = [UIColor redColor];
        }
        else{
            cell.contentLabel.textColor = [UIColor blackColor];
        }
    }
    else if (_state == SubTableViewStateFilter){
        cell.contentLabel.text = nil;
    }
    [cell layoutSubviewsWithSubTableViewState:_state];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellStr = [[(SubTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] contentLabel] text];
    
    SubTableViewCell *cell = (SubTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.contentLabel.textColor = [UIColor redColor];
    //NSString *name;
    if ([_delegate respondsToSelector:@selector(didSelectAt:withTypeID:cellText:)]) {
        if (_state == SubTableViewStateRank) {
            NSDictionary *dict = [_orderFilterList objectAtIndex:indexPath.row];
            if ([[self.selectedFirstFilter objectForKey:self.orderType] isEqualToString:[dict valueForKey:@"id"]]) {
                [self.selectedFirstFilter removeAllObjects];
            }
            else{
                [self.selectedFirstFilter removeAllObjects];
                [self.selectedFirstFilter setObject:[dict valueForKey:@"id"] forKey:self.orderType];
            }
            [_delegate didSelectAt:self.orderType withTypeID:[dict valueForKey:@"id"] cellText:cellStr];
        }
        else if (_state == SubTableViewStateBrand){
            NSArray *sectionArray = [_brandFilterList objectAtIndex:indexPath.section];
            BrandModel *model = [sectionArray objectAtIndex:indexPath.row];
            
            if ([[self.selectedSecondFilter objectForKey:self.brandType] isEqualToString:model.brandID]) {
                [self.selectedSecondFilter removeAllObjects];
                //[self.selectedSecondFilter removeObjectForKey:self.brandType];
            }
            else{
                [self.selectedSecondFilter removeAllObjects];
                [self.selectedSecondFilter setObject:model.brandID forKey:self.brandType];
            }
            [_delegate didSelectAt:self.brandType withTypeID:model.brandID cellText:cellStr];
        }
        else if (_state == SubTableViewStateClassificaton){
            NSDictionary *dict = [_categoryFilterList objectAtIndex:indexPath.row];
            if ([[self.selectedThirdFilter objectForKey:self.classificationType] isEqualToString:[dict valueForKey:@"id"]]) {
                [self.selectedThirdFilter removeAllObjects];
                //[self.selectedThirdFilter removeObjectForKey:self.classificationType];
            }
            else{
                [self.selectedThirdFilter removeAllObjects];
                [self.selectedThirdFilter setObject:[dict valueForKey:@"id"] forKey:self.classificationType];
            }
            [_delegate didSelectAt:self.classificationType withTypeID:[dict valueForKey:@"id"] cellText:cellStr];
        }
        else if (_state == SubTableViewStateFilter){
        }
    }
}


- (void)setBrandFilterList:(NSArray *)brandFilterList
{
    if (_brandFilterList != brandFilterList) {
        NSMutableArray *brandModelArray = [NSMutableArray arrayWithCapacity:[brandFilterList count]];
        for (NSDictionary *dict in brandFilterList) {
            BrandModel *brandModel = [[BrandModel alloc] init];
            brandModel.name = [dict valueForKey:@"name"];
            brandModel.brandID = [dict valueForKey:@"id"];
            [brandModelArray addObject:brandModel];
        }
        
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        NSInteger highSection = [[theCollation sectionTitles] count];
        NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
        for (int i = 0; i < highSection; i++) {
            NSMutableArray *sectionArray = [NSMutableArray array];
            [sectionArrays addObject:sectionArray];
        }
        for (BrandModel *brand in brandModelArray) {
            NSInteger sect = [theCollation sectionForObject:brand collationStringSelector:@selector(name)];
            [[sectionArrays objectAtIndex:sect] addObject:brand];
        }
        NSMutableArray *sectionBrands = [NSMutableArray array];
        
        for (NSMutableArray *sectionArray in sectionArrays) {
             NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
            [sectionBrands addObject:sortedSection];
        }
        _brandFilterList = sectionBrands;
    }
}

@end
