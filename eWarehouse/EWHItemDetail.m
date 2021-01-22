//
//  EWHItemDetail.m
//  eWarehouse
//
//  Created by Brian Torkelson on 12/17/20.
//

#import "EWHItemDetail.h"

@implementation EWHItemDetail

@synthesize ItemNumber;
@synthesize InventoryStatusName;
@synthesize ProgramName;
@synthesize LocationName;
@synthesize ItemScan;
@synthesize Quantity;


- (EWHItemDetail *)initWithDictionary:(NSDictionary *)dictionary {
    ItemNumber = [dictionary objectForKey:@"PartNumber"];
    InventoryStatusName = [dictionary objectForKey:@"InventoryStatusName"];
    ProgramName = [dictionary objectForKey:@"ProgramName"];
    LocationName = [dictionary objectForKey:@"LocationName"];
    ItemScan = [dictionary objectForKey:@"ItemScan"];
    Quantity = [[dictionary objectForKey:@"Quantity"] intValue];
    return [super init];
}


@end
