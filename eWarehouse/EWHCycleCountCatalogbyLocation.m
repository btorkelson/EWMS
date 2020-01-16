//
//  EWHCycleCountCatalogbyLocation.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/14/20.
//

#import "EWHCycleCountCatalogbyLocation.h"

@implementation EWHCycleCountCatalogbyLocation

@synthesize CatalogId;
@synthesize ItemNumber;
@synthesize ProgramId;
@synthesize ProgramName;
@synthesize QuantityScanned;
@synthesize QuantityOnHand;
@synthesize ScannedSerials;
@synthesize LocationId;
@synthesize CycleCountJobId;
@synthesize CycleCountJobDetailId;
@synthesize IsBulk;
@synthesize IsSerial;
@synthesize LocationName;

- (EWHCycleCountCatalogbyLocation *)initWithDictionary:(NSDictionary *)dictionary {
    CatalogId = [[dictionary objectForKey:@"CatalogId"] intValue];
    ItemNumber = [dictionary objectForKey:@"ItemNumber"];
    ProgramId = [[dictionary objectForKey:@"ProgramId"] intValue];
    ProgramName = [dictionary objectForKey:@"ProgramName"];
    LocationName = [dictionary objectForKey:@"LocationName"];
    QuantityScanned = [[dictionary objectForKey:@"QuantityScanned"] intValue];
    QuantityOnHand = [[dictionary objectForKey:@"QuantityOnHand"] intValue];
    LocationId = [[dictionary objectForKey:@"LocationId"] intValue];
    CycleCountJobId = [[dictionary objectForKey:@"CycleCountJobId"] intValue];
    CycleCountJobDetailId = [[dictionary objectForKey:@"CycleCountJobDetailId"] intValue];
    IsBulk = [[dictionary objectForKey:@"IsBulk"] boolValue];
    IsSerial = [[dictionary objectForKey:@"IsSerial"] boolValue];
    ScannedSerials = [[NSMutableArray alloc] init];
    
    
    return [super init];
}

-(NSDictionary*) toJSON {
    return @{
             @"CatalogId": @(self.CatalogId),
             @"ItemNumber": self.ItemNumber,
             @"ProgramId": @(self.ProgramId),
             @"ProgramName": self.ProgramName,
             @"LocationName": self.LocationName,
             @"QuantityScanned": @(self.QuantityScanned),
             @"QuantityOnHand": @(self.QuantityOnHand),
             @"LocationId": @(self.LocationId),
             @"CycleCountJobId": @(self.CycleCountJobId),
             @"CycleCountJobDetailId": @(self.CycleCountJobDetailId),
             @"IsBulk": @(self.IsBulk),
             @"IsSerial": @(self.IsSerial),
             @"ScannedSerials": [ScannedSerials componentsJoinedByString:@","]
             };
}

@end
