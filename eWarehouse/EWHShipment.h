//
//  EWHUser.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHUtils.h"

@interface EWHShipment : NSObject {
    NSInteger ShipmentId;
    NSString *ShipmentNumber;
    NSDate *DeliveryDate;
    NSInteger ProgramId;
    NSString *ProgramName;
    BOOL isContainer;
    NSString *Message;
}

@property (assign, nonatomic) NSInteger ShipmentId;
@property (nonatomic, retain) NSString *ShipmentNumber;
@property (nonatomic, retain) NSDate *DeliveryDate;
@property (nonatomic) NSInteger ProgramId;
@property (nonatomic, retain) NSString *ProgramName;
@property (nonatomic) BOOL isContainer;
@property (nonatomic, retain) NSString *Message;

- (EWHShipment *)initWithDictionary:(NSDictionary *)dictionary;
@end