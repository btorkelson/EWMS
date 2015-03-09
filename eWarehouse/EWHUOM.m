//
//  EWHUOM.m
//  eWarehouse
//
//  Created by Brian Torkelson on 10/31/14.
//
//

#import "EWHUOM.h"

@implementation EWHUOM

@synthesize UnitOfMeasureType;
@synthesize UnitOfMeasureName;
@synthesize UnitofMeasureId;
@synthesize ProgramId;
@synthesize SizeType;
@synthesize Value;


- (EWHUOM *)initWithDictionary:(NSDictionary *)dictionary {
    Value = [dictionary objectForKey:@"Value"];
    ProgramId = [[dictionary objectForKey:@"ProgramId"] intValue];
    UnitofMeasureId = [[dictionary objectForKey:@"UnitOfMeasureId"] intValue];
    UnitOfMeasureName = [dictionary objectForKey:@"UnitOfMeasureName"];
    SizeType = [[dictionary objectForKey:@"SizeType"] intValue];
    UnitOfMeasureType = [[dictionary objectForKey:@"UnitOfMeasureType"] intValue];
    return [super init];
}


@end
