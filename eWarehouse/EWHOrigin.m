//
//  EWHOrigin.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/4/14.
//
//

#import "EWHOrigin.h"

@implementation EWHOrigin
@synthesize OriginId;
@synthesize Name;

- (EWHOrigin *)initWithDictionary:(NSDictionary *)dictionary {
    OriginId = [[dictionary objectForKey:@"Id"] intValue];
    Name = [[NSString alloc] initWithString:[dictionary objectForKey:@"Value"]];
    return [super init];
}



@end
