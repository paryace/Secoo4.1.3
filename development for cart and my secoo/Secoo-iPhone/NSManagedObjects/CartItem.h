//
//  CartItem.h
//  Secoo-iPhone
//
//  Created by Tan Lu on 10/26/14.
//  Copyright (c) 2014 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CartItem : NSManagedObject

@property (nonatomic) NSTimeInterval addDate;
@property (nonatomic) int16_t areaType;
@property (nonatomic) int16_t availableAmount;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic) int16_t inventoryStatus;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic) int16_t quantity;
@property (nonatomic) double refPrice;
@property (nonatomic) float returnValue;
@property (nonatomic, retain) NSString * size;
@property (nonatomic) int32_t type;
@property (nonatomic, retain) NSString * upKey;

@end
