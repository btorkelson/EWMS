//
//  EWHSortJob.m
//  eWarehouse
//
//  Created by Brian Torkelson on 8/28/19.
//

#import "EWHSortJob.h"

@implementation EWHSortJob

@synthesize SortJobId;
@synthesize JobDate;
@synthesize JobName;
@synthesize ProgramId;
@synthesize ProgramName;
@synthesize WarehouseId;
@synthesize WarehouseName;

- (EWHSortJob *)initWithDictionary:(NSDictionary *)dictionary {
    SortJobId = [[dictionary objectForKey:@"SortJobId"] intValue];
    JobName = [dictionary objectForKey:@"JobName"];
    JobDate = [EWHUtils mfDateFromDotNetJSONString:[dictionary objectForKey:@"JobDate"]];
    ProgramId = [[dictionary objectForKey:@"ProgramId"] intValue];
    ProgramName = [dictionary objectForKey:@"ProgramName"];
    WarehouseId = [[dictionary objectForKey:@"WarehouseId"] intValue];
    WarehouseName = [dictionary objectForKey:@"WarehouseName"];
    return [super init];
}
@end
