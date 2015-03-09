//
//  EWHDestination.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHDestination.h"

@implementation EWHDestination

@synthesize DestinationId;
@synthesize Name;
@synthesize Address1;
@synthesize Address2;
@synthesize City;
@synthesize State;
@synthesize Zip;
@synthesize Country;

- (EWHDestination *)initWithDictionary:(NSDictionary *)dictionary {
    DestinationId = [[dictionary objectForKey:@"DestinationId"] intValue];
    Name = [[NSString alloc] initWithString:[dictionary objectForKey:@"Name"]];
    Address1 = [[NSString alloc] initWithString:[dictionary objectForKey:@"Address1"]];
    Address2 = [dictionary objectForKey:@"Address2"];
    City = [dictionary objectForKey:@"City"];
    State = [dictionary objectForKey:@"State"];
    Zip = [dictionary objectForKey:@"Zip"];
    Country = [dictionary objectForKey:@"Country"];
    return [super init];
}

@end
