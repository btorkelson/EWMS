//
//  EWHCarrier.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import "EWHCarrier.h"

@implementation EWHCarrier
@synthesize CarrierId;
@synthesize Name;

- (EWHCarrier *)initWithDictionary:(NSDictionary *)dictionary {
    CarrierId = [[dictionary objectForKey:@"Id"] intValue];
    Name = [[NSString alloc] initWithString:[dictionary objectForKey:@"Value"]];
    return [super init];
}

@end
