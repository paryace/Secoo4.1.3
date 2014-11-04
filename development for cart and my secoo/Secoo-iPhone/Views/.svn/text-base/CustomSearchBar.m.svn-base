//
//  CustomSearchBar.m
//  Secoo-iPhone
//
//  Created by Paney on 14-7-9.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *searchBarArray = nil;
    if (_IOS_7_LATER_) {
        searchBarArray = [[[self subviews] firstObject] subviews];
    } else {
        searchBarArray = [self subviews];
    }
    
    for (id obj in searchBarArray) {
        NSLog(@"searchBarArray obj %@", obj);
        if ([obj isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            UIView *view = (UIView *)obj;
            [view removeFromSuperview];
        } else if ([obj isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *searchField = obj;
            searchField.textColor = [UIColor grayColor];
            [searchField setBackground:[UIImage imageNamed:@"searchText.png"]];
            [searchField setBorderStyle:UITextBorderStyleNone];
        }
    }
}

@end
