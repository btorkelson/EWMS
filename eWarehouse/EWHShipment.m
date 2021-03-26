//
//  EWHUser.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHShipment.h"

@implementation EWHShipment

@synthesize ShipmentId;
@synthesize ShipmentNumber;
@synthesize DeliveryDate;
@synthesize ProgramId;
@synthesize ProgramName;
@synthesize Message;
@synthesize isContainer;
@synthesize isValidateLotNumber;

- (EWHShipment *)initWithDictionary:(NSDictionary *)dictionary {
    ShipmentId = [[dictionary objectForKey:@"ShipmentId"] intValue];
    ShipmentNumber = [[NSString alloc] initWithString:[dictionary objectForKey:@"ShipmentNumber"]];
    ProgramId = [[dictionary objectForKey:@"ProgramId"] intValue];
    ProgramName = [[NSString alloc] initWithString:[dictionary objectForKey:@"ProgramName"]];
    DeliveryDate = [EWHUtils mfDateFromDotNetJSONString:[dictionary objectForKey:@"DeliveryDate"]];
    isContainer = [[dictionary objectForKey:@"isContainer"] boolValue];
    isValidateLotNumber = [[dictionary objectForKey:@"isValidateLotNumber"] boolValue];
//    NSString *msg = [dictionary objectForKey:@"Message"];
//    if(msg != nil){
//        Message = [[NSString alloc] initWithString:msg];
//    }
    return [super init];
}
@end
