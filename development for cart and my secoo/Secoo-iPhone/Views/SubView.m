//
//  SubView.m
//  Secoo
//
//  Created by WuYikai on 14-8-22.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "SubView.h"
#import "SubViewCell.h"

#define _SUREBUTTON_HEIGHT_ 30
#define _LEFTRIGHT_INSERT_  0
#define _UPDOWN_INSERT      5

@interface SubView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _currentLeftIndex;
    NSInteger _currentRightIndex;
}

@property(nonatomic, weak) UIButton *sureButton;
@property(nonatomic, weak) UIButton *cancleButton;

@end

@implementation SubView

static NSString *cellIdentifierLef = @"CELL_LEFT";
static NSString *cellIdentifierRig = @"CELL_RIGHT";

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SubViewDelegate>)delegate dataSource:(NSArray *)dataArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate;
        self.dataArray = dataArray;
        
        self.leftTableView = [[UITableView alloc] init];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorColor = [UIColor clearColor];
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        
        self.rightTableView = [[UITableView alloc] init];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorColor = [UIColor clearColor];
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.showsHorizontalScrollIndicator = NO;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:MAIN_YELLOW_COLOR];
        button.layer.backgroundColor = MAIN_YELLOW_COLOR.CGColor;
        button.layer.borderColor = [UIColor clearColor].CGColor;
        button.layer.cornerRadius = 10.0;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didClickSureButton:) forControlEvents:UIControlEventTouchUpInside];
        self.sureButton = button;
        
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleButton setBackgroundColor:[UIColor clearColor]];
        [cancleButton.layer setBackgroundColor:[UIColor clearColor].CGColor];
        cancleButton.layer.borderColor = [UIColor clearColor].CGColor;
        [cancleButton setTitleColor:MAIN_YELLOW_COLOR forState:UIControlStateNormal];
        [cancleButton setTitle:@"清除筛选" forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(didClickCancleButton:) forControlEvents:UIControlEventTouchUpInside];
        self.cancleButton = cancleButton;
        
        _currentLeftIndex = 0;
        _currentRightIndex = 0;
        [_leftTableView registerClass:[SubViewCell class] forCellReuseIdentifier:cellIdentifierLef];
        [_rightTableView registerClass:[SubViewCell class] forCellReuseIdentifier:cellIdentifierRig];
        [self addSubview:_leftTableView];
        [self addSubview:_rightTableView];
        [self addSubview:button];
        [self addSubview:cancleButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame delegate:nil dataSource:nil];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width - _LEFTRIGHT_INSERT_*2;
    CGFloat height = self.frame.size.height - _UPDOWN_INSERT*3 - _SUREBUTTON_HEIGHT_;
    self.leftTableView.frame = CGRectMake(_LEFTRIGHT_INSERT_, _UPDOWN_INSERT, width*0.4, height);
    self.rightTableView.frame = CGRectMake(_LEFTRIGHT_INSERT_+_leftTableView.frame.size.width, _UPDOWN_INSERT, width*0.6, height);
    self.sureButton.frame = CGRectMake(_rightTableView.frame.origin.x+20, height+_UPDOWN_INSERT*2, _rightTableView.frame.size.width-40, _SUREBUTTON_HEIGHT_);
    self.cancleButton.frame = CGRectMake(_LEFTRIGHT_INSERT_+20, height+_UPDOWN_INSERT*2, _leftTableView.frame.size.width-40, _SUREBUTTON_HEIGHT_);
}

#pragma mark - TableView Delegate & Datasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return [self.dataArray count];
    } else {
        NSDictionary *dict = [self.dataArray objectAtIndex:_currentLeftIndex];
        return [[dict objectForKey:@"value"] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
        SubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierLef];
        cell.textLabel.text = [dict valueForKey:@"name"];
        if (indexPath.row == _currentLeftIndex) {
            [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.contentView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
            cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        }
        return cell;
    } else {
        NSDictionary *dict = [self.dataArray objectAtIndex:_currentLeftIndex];
        SubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierRig];
        NSArray *valueArray = [dict valueForKey:@"value"];
        NSDictionary *subDict = [valueArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [subDict valueForKey:@"name"];
        
        NSString *type = [dict valueForKey:@"key"];
        NSString *typeID = [self.filterDict objectForKey:type];
        //NSLog(@"type:%@ id:%@  subDict:%@", type, typeID, [subDict objectForKey:@"id"]);
        if ([typeID isEqualToString: [subDict objectForKey:@"id"]]) {
           [_rightTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        
        [[tableView cellForRowAtIndexPath:indexPath].contentView setBackgroundColor:[UIColor whiteColor]];
        [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor whiteColor]];
        
        _currentLeftIndex = indexPath.row;
        [self.rightTableView setHidden:NO];
        [self.rightTableView reloadData];
    } else {
        _currentRightIndex = indexPath.row;
        [[tableView cellForRowAtIndexPath:indexPath].textLabel setTextColor:[UIColor redColor]];
        
        NSDictionary *dict = [self.dataArray objectAtIndex:_currentLeftIndex];
        NSString *type = [dict valueForKey:@"key"];
        NSString *typeID = [self.filterDict objectForKey:type];
        if (typeID) {
            NSArray *values = [dict valueForKey:@"value"];
            NSDictionary *valueDict = [values objectAtIndex:indexPath.row];
            if ([[valueDict valueForKey:@"id"] isEqualToString:typeID]) {
                [self.filterDict removeObjectForKey:type];
                [_rightTableView deselectRowAtIndexPath:indexPath animated:YES];
                //NSLog(@"already has it %@, delete it", typeID);
                [[tableView cellForRowAtIndexPath:indexPath].textLabel setTextColor:[UIColor blackColor]];
            }
            else{
                [self.filterDict setObject:[valueDict valueForKey:@"id"] forKey:type];
                //NSLog(@"dosen't have it %@, replace it", typeID);
            }
        }
        else{
            //NSLog(@"dosen't have it %@, add it", typeID);
            NSArray *values = [dict valueForKey:@"value"];
            NSDictionary *valueDict = [values objectAtIndex:indexPath.row];
            //NSLog(@"%@", self.filterDict);
            [self.filterDict setObject:[valueDict valueForKey:@"id"] forKey:type];
        }
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        [tableView cellForRowAtIndexPath:indexPath].contentView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    } else {
        [[[tableView cellForRowAtIndexPath:indexPath] textLabel] setTextColor:[UIColor blackColor]];
    }
}


#pragma mark - 点击确定按钮
- (void)didClickSureButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasSelectWithFilterDict:)]) {
        [self.delegate hasSelectWithFilterDict:self.filterDict];
    }
}

#pragma mark - 点击清除选择按钮
- (void)didClickCancleButton:(UIButton *)sender
{
    if (self.filterDict) {
        [self.filterDict removeAllObjects];
    }
    
    NSIndexPath *lefIndexPath = [NSIndexPath indexPathForRow:_currentLeftIndex inSection:0];
    NSIndexPath *rigIndexPath = [NSIndexPath indexPathForRow:_currentRightIndex inSection:0];
    
    [_leftTableView cellForRowAtIndexPath:lefIndexPath].contentView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [[_rightTableView cellForRowAtIndexPath:rigIndexPath].textLabel setTextColor:[UIColor blackColor]];
}

#pragma mark  --------getter and setter---


@end
