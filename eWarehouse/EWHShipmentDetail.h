//
//  EWHUser.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHUtils.h"

@interface EWHShipmentDetail : NSObject {
    NSInteger ShipmentId;
    NSInteger ShipmentDetailId;
    NSString *Number;
    NSString *PartNumber;
    BOOL IsSerialized;
    BOOL IsBulk;
    NSInteger Quantity;
    NSString *LocationName;
    NSString *Type;
    BOOL IsScanned;
    NSString *LotNumber;
}

@property (assign, nonatomic) NSInteger ShipmentId;
@property (assign, nonatomic) NSInteger ShipmentDetailId;
@property (nonatomic, retain) NSString *Number;
@property (nonatomic, retain) NSString *PartNumber;
@property (nonatomic) BOOL IsSerialized;
@property (nonatomic) BOOL IsBulk;
@property (nonatomic) NSInteger Quantity;
@property (nonatomic, retain) NSString *LocationName;
@property (nonatomic, retain) NSString *Type;
@property (nonatomic) BOOL IsScanned;
@property (nonatomic, retain) NSString *LotNumber;

- (EWHShipmentDetail *)initWithDictionary:(NSDictionary *)dictionary;
@end
