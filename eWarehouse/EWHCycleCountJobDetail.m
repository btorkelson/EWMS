//
//  EWHCycleCountJobDetail.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/14/20.
//

#import "EWHCycleCountJobDetail.h"

@implementation EWHCycleCountJobDetail

@synthesize CycleCountJobDetailId;
@synthesize Id;
@synthesize Value;


- (EWHCycleCountJobDetail *)initWithDictionary:(NSDictionary *)dictionary {
    CycleCountJobDetailId = [[dictionary objectForKey:@"CycleCountJobDetailId"] intValue];
    Id = [[dictionary objectForKey:@"Id"] intValue];
    Value = [dictionary objectForKey:@"Value"];
    return [super init];
}


@end
