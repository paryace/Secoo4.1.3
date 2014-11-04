//
//  CategoryEntity.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 8/20/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryChild;

@interface CategoryEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * clickTimes;
@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sortkey;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSSet *child;
@end

@interface CategoryEntity (CoreDataGeneratedAccessors)

- (void)addChildObject:(CategoryChild *)value;
- (void)removeChildObject:(CategoryChild *)value;
- (void)addChild:(NSSet *)values;
- (void)removeChild:(NSSet *)values;

@end
