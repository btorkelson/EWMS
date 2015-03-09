//
//  EWHVendor.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import "EWHVendor.h"

@implementation EWHVendor
@synthesize VendorId;
@synthesize Name;

- (EWHVendor *)initWithDictionary:(NSDictionary *)dictionary {
    VendorId = [[dictionary objectForKey:@"Id"] intValue];
    Name = [[NSString alloc] initWithString:[dictionary objectForKey:@"Value"]];
    return [super init];
}


- (EWHVendor *) init {
    VendorId = nil;
    Name = nil;
    return self;
}

@end
