//
//  EWHCycleCountJob.m
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import "EWHCycleCountJob.h"

@implementation EWHCycleCountJob

@synthesize CycleCountJobId;
@synthesize CycleCountJobNumber;
@synthesize DueDate;
@synthesize CycleCountJobTypeId;


- (EWHCycleCountJob *)initWithDictionary:(NSDictionary *)dictionary {
    CycleCountJobId = [[dictionary objectForKey:@"CycleCountJobId"] intValue];
    CycleCountJobNumber = [dictionary objectForKey:@"CycleCountJobNumber"];
    DueDate = [EWHUtils mfDateFromDotNetJSONString:[dictionary objectForKey:@"DueDate"]];
    CycleCountJobTypeId = [[dictionary objectForKey:@"CycleCountJobTypeId"] intValue];
    return [super init];
}

@end
