//
//  AllBrand.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 9/4/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AllBrand : NSManagedObject

@property (nonatomic) int32_t brandId;
@property (nonatomic, retain) NSString * cap;
@property (nonatomic, retain) NSString * cname;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * ename;
@property (nonatomic) int16_t height;
@property (nonatomic) int16_t order;
@property (nonatomic, retain) NSData * others;
@property (nonatomic) int16_t width;

@end
