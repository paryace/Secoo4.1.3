//
//  SearchDisplayView.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-24.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "SearchDisplayView.h"
#import "RootViewController.h"

@implementation SearchDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SearchDisplayViewDelegate>)viewController
{
    self = [self initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_tableView];
        self.delegate = viewController;
    }
    return self;
}


- (void)handDataSouceWithArray:(NSArray *)array
{
    self.dataArray = array;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDatasouce Delegate Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CELL_ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasSelectOneMsg:)]) {
        [self.delegate hasSelectOneMsg:cell.textLabel.text];
        if ([self.delegate isKindOfClass:[RootViewController class]]) {
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate) {
        if ([self.delegate isKindOfClass:[RootViewController class]]) {
            RootViewController *rootVC = (RootViewController *)self.delegate;
            [rootVC.searchBar resignFirstResponder];
        }
    }
}

@end
