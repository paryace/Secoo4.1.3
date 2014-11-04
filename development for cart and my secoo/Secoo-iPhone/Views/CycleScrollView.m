//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by luTan on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"

#define PageGap 10

//implementation of CycleScrollView
@interface CycleScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
/**
 content views of scrollview
 **/
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , assign) NSInteger totalPageCount;
/**
 数据源：获取总的page个数
 **/
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UILabel *indexLabel;

@end

@implementation CycleScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        [self setUpScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        [self setUpScrollView];
    }
    return self;
}

- (void)setUpScrollView
{
    //self.autoresizesSubviews = YES;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width + PageGap, SCREEN_HEIGHT);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView = scrollView;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.contentMode = UIViewContentModeCenter;
    self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.directionalLockEnabled = YES;
    [self addSubview:scrollView];
    self.currentPageIndex = 0;

    UILabel *label = [[UILabel alloc] init];
    _indexLabel = label;
    label.frame = CGRectMake((SCREEN_WIDTH - 100) / 2.0, SCREEN_HEIGHT - 40, 100, 15);
    [self addSubview:label];
    [self bringSubviewToFront:label];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial-Bold" size:12];
    label.textAlignment = NSTextAlignmentCenter;
}

#pragma mark -
#pragma mark - 私有函数

- (void)setContentView:(UIView *)contentView at:(NSInteger)index
{
    CGRect rightRect = contentView.frame;
    if ([contentView isKindOfClass:[UIImageView class]]) {
        UIImage *image = ((UIImageView *)contentView).image;
        if (image) {
//            if (self.frame.size.width / image.size.width * image.size.height <= self.frame.size.height) {
//                CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.width / image.size.width * image.size.height);
//                rightRect.size = size;
//                rightRect.origin = CGPointMake(0, (self.frame.size.height - size.height) / 2.0);
//            }
//            else{
//                CGSize size = CGSizeMake(self.frame.size.height / image.size.height * self.frame.size.width, self.frame.size.height);
//                rightRect.size = size;
//                rightRect.origin = CGPointMake((self.frame.size.width - size.width) / 2.0, 0);
//            }
            rightRect = [Utils adjustImageViewToSize:image.size inSize:self.frame.size];
        }
        else{
            //
        }
        contentView.frame = rightRect;
        CGRect frame = CGRectMake(CGRectGetWidth(self.scrollView.frame) * index, 0, self.bounds.size.width, self.scrollView.frame.size.height);
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:frame];
        subScrollView.maximumZoomScale = 3.0;
        subScrollView.contentSize = subScrollView.frame.size;
        subScrollView.delegate = self;
        [subScrollView addSubview:contentView];
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.showsVerticalScrollIndicator = NO;
        subScrollView.zoomScale = 1.0;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        tapGesture.numberOfTapsRequired = 1;
        [subScrollView addGestureRecognizer:tapGesture];
        
        UITapGestureRecognizer *aDoubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
        aDoubleTapGesture.delegate = self;
        aDoubleTapGesture.numberOfTapsRequired = 2;
        [subScrollView addGestureRecognizer:aDoubleTapGesture];
        
        [tapGesture requireGestureRecognizerToFail:aDoubleTapGesture];
        
        [self.scrollView addSubview:subScrollView];
    }
    else{
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (index), 0);
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
}

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    if (self.totalPageCount == 1) {
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        _scrollView.contentSize = self.scrollView.frame.size;
        if ([self.contentViews count] > 0) {
            UIView *contentView = [self.contentViews objectAtIndex:0];
            [self setContentView:contentView at:0];
        }
    }
    else if(self.totalPageCount == 2){
        _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
        if ([self.contentViews count] > 1) {
            UIView *contentView = [self.contentViews objectAtIndex:0];
            [self setContentView:contentView at:0];
            UIView *contentView1 = [self.contentViews objectAtIndex:1];
            [self setContentView:contentView1 at:1];
        }
    }
    else{
        NSInteger counter = 0;
        for (UIView *contentView in self.contentViews) {
            [self setContentView:contentView at:counter];
            counter++;
        }
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    if ([_views count] == 0) {
        NSLog(@"set the data source for cycScrollView");
        return;
    }
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    //if there is only on image, then the image in the contentViews is the same
    [self.contentViews addObject:_views[previousPageIndex]];
    [self.contentViews addObject:_views[_currentPageIndex]];
    [self.contentViews addObject:_views[rearPageIndex]];
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        if (self.totalPageCount > 2) {
            if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
                self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
                [self configContentViews];
            }
            if(contentOffsetX <= 0) {
                self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
                [self configContentViews];
            }
        }
        else if (self.totalPageCount == 2){
            if(contentOffsetX >= (CGRectGetWidth(scrollView.frame))) {
                self.currentPageIndex = 1;
            }
            if(contentOffsetX <= 0) {
                self.currentPageIndex = 0;
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        if (self.totalPageCount > 2) {
            [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView) {
        return _views[self.currentPageIndex];
    }
    else{
        return nil;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView) {
        UIView *view = _views[self.currentPageIndex];
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
        (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
        (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        view.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
    }
}

#pragma mark -
#pragma mark - 响应事件

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapOnCycleScrollView:At:)]) {
        [_delegate didTapOnCycleScrollView:self At:self.currentPageIndex];
    }
}

- (void) doubleTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    UIScrollView *view = (UIScrollView *) tap.view;
    CGPoint touchPoint = [tap locationInView:view];
	if (view.zoomScale > view.minimumZoomScale) {
		[view setZoomScale:view.minimumZoomScale animated:YES];
	} else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        if ([view.subviews count] > 0) {
            UIView *subview = view.subviews[0];
            width = subview.frame.size.width;
            height = subview.frame.size.height;
        }
		[view zoomToRect:CGRectMake(touchPoint.x - 1, touchPoint.y - 1 * height / width, 2, 2 * height / width) animated:YES];
	}
}

#pragma mark -
#pragma mark --setter

- (void)setViews:(NSArray *)views
{
    if (_views != views) {
        _views = views;
        self.totalPageCount = [_views count];
    }
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    self.indexLabel.text = [NSString stringWithFormat:@"%d/%d", self.currentPageIndex + 1, self.totalPageCount];
}

- (void)setTotalPageCount:(NSInteger)totalPagesCount
{
    _totalPageCount = totalPagesCount;
    self.indexLabel.text = [NSString stringWithFormat:@"%d/%d", self.currentPageIndex + 1, self.totalPageCount];
    if (_totalPageCount > 0) {
        [self configContentViews];
    }
}

@end
