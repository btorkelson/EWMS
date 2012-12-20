//
//  EWHUser.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHWarehouse.h"

@implementation EWHWarehouse
@synthesize Id;
@synthesize Name;

- (EWHWarehouse *)initWithDictionary:(NSDictionary *)dictionary {
    Id = [[dictionary objectForKey:@"WarehouseId"] intValue];
    Name = [[NSString alloc] initWithString:[dictionary objectForKey:@"WarehouseName"]];
    return [super init];
}
@end
