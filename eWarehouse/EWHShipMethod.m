//
//  EWHShipMethod.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/4/14.
//
//

#import "EWHShipMethod.h"

@implementation EWHShipMethod
@synthesize ShipMethodId;
@synthesize Name;

- (EWHShipMethod *)initWithDictionary:(NSDictionary *)dictionary {
    ShipMethodId = [[dictionary objectForKey:@"Id"] intValue];
    Name = [[NSString alloc] initWithString:[dictionary objectForKey:@"Value"]];
    return [super init];
}



@end
