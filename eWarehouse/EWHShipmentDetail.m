//
//  EWHUser.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHShipmentDetail.h"

@implementation EWHShipmentDetail

@synthesize ShipmentId;
@synthesize ShipmentDetailId;
@synthesize Number;
@synthesize PartNumber;
@synthesize IsSerialized;
@synthesize IsBulk;
@synthesize Quantity;
@synthesize LocationName;
@synthesize Type;
@synthesize IsScanned;
@synthesize LotNumber;

- (EWHShipmentDetail *)initWithDictionary:(NSDictionary *)dictionary {
    ShipmentId = [[dictionary objectForKey:@"ShipmentId"] intValue];
    ShipmentDetailId = [[dictionary objectForKey:@"ShipmentDetailId"] intValue];
    Number = [[NSString alloc] initWithString:[dictionary objectForKey:@"Number"]];
    PartNumber = [[NSString alloc] initWithString:[dictionary objectForKey:@"PartNumber"]];
    IsSerialized = [[dictionary objectForKey:@"IsSerialized"] boolValue];
    IsBulk = [[dictionary objectForKey:@"IsBulk"] boolValue];
    Quantity = [[dictionary objectForKey:@"Quantity"] intValue];
    LocationName = [[NSString alloc] initWithString:[dictionary objectForKey:@"LocationName"]];
    Type = [[NSString alloc] initWithString:[dictionary objectForKey:@"Type"]];
    IsScanned = NO;
    LotNumber = [[NSString alloc] initWithString:[dictionary objectForKey:@"LotNumber"]];
    return [super init];
}
@end
