//
//  EWHUser.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHLocation.h"

@implementation EWHLocation
@synthesize Id;
@synthesize Name;
@synthesize LocationTypeName;
@synthesize LocationTypeId;

- (EWHLocation *)initWithDictionary:(NSDictionary *)dictionary {
    Id = [[dictionary objectForKey:@"Id"] intValue];
    Name = [[NSString alloc] initWithString:[dictionary objectForKey:@"Value"]];
    LocationTypeName = [dictionary objectForKey:@"LocationTypeName"];
    LocationTypeId = [[dictionary objectForKey:@"LocationTypeId"] intValue];
    return [super init];
}
@end
