//
//  CategoryDataAccessor.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObserverDelegate <NSObject>

@required
- (void)updateMainContext:(NSNotification *)notification;

@end

@interface CategoryDataAccessor : NSObject

@property(nonatomic, weak) UIViewController<ObserverDelegate> *observerViewController;

- (void)updateCategory:(NSArray *)names icons:(NSArray *)icons ids:(NSArray *)ids imageURL:(NSArray *)urls categoryIds:(NSArray *)categoryIds sortKey:(NSArray *)sortKeys children:(NSArray *)children;

@end
