//
//  EWHInventoryType.m
//  eWarehouse
//
//  Created by Brian Torkelson on 10/16/14.
//
//

#import "EWHInventoryType.h"

@implementation EWHInventoryType


@synthesize InventoryTypeId;
@synthesize Name;

- (EWHInventoryType *)initWithDictionary:(NSDictionary *)dictionary {
    InventoryTypeId = [[dictionary objectForKey:@"Id"] intValue];
    Name = [[NSString alloc] initWithString:[dictionary objectForKey:@"Value"]];
    return [super init];
}

@end
