//
//  EWHUser.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHReceiptDetail.h"

@implementation EWHReceiptDetail

@synthesize Id;
@synthesize ReceiptId;
@synthesize IsBulk;
@synthesize IsSerialized;
@synthesize LocationId;
@synthesize LocationName;
@synthesize SuggestedLocations;
@synthesize Number;
@synthesize PartNumber;
@synthesize Quantity;
@synthesize Message;

- (EWHReceiptDetail *)initWithDictionary:(NSDictionary *)dictionary {
    Id = [[dictionary objectForKey:@"Id"] intValue];
    ReceiptId = [[dictionary objectForKey:@"ReceiptId"] intValue];
    IsBulk = [[dictionary objectForKey:@"IsBulk"] boolValue];
    IsSerialized = [[dictionary objectForKey:@"IsSerialized"] boolValue];
    LocationId = [[dictionary objectForKey:@"LocationId"] intValue];
    LocationName = [[NSString alloc] initWithString:[dictionary objectForKey:@"LocationName"]];
    SuggestedLocations = [[NSString alloc] initWithString:[dictionary objectForKey:@"SuggestedLocations"]];
    Number = [[NSString alloc] initWithString:[dictionary objectForKey:@"Number"]];
    PartNumber = [[NSString alloc] initWithString:[dictionary objectForKey:@"PartNumber"]];
    Quantity = [[dictionary objectForKey:@"Quantity"] intValue];
    
    id msg = [dictionary objectForKey:@"Message"];
    if(msg != [NSNull null]) Message = [[NSString alloc] initWithString:msg];
    return [super init];
}
@end
