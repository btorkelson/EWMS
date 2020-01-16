//
//  EWHCatalog.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHCatalog.h"

@implementation EWHCatalog

@synthesize CatalogId;
@synthesize ItemNumber;
@synthesize Description;
@synthesize UOMId;
@synthesize IsBulk;
@synthesize IsSerial;
@synthesize ProgramId;
@synthesize CustomAttributeCatalogs;
@synthesize InventoryTypeId;
@synthesize UOMs;
@synthesize ProgramName;
@synthesize DetailsByStatus;
@synthesize InventoryTypeName;
@synthesize InventoryStatusName;
@synthesize Qty;
@synthesize PartNumber;
@synthesize LocationId;
@synthesize InventoryStatusId;
@synthesize QuantityScanned;

//+ (Class)EWHUOM_class {
//    return [EWHCatalog class];
//}



- (EWHCatalog *)initWithDictionary:(NSDictionary *)dictionary {
    CatalogId = [[dictionary objectForKey:@"CatalogId"] intValue];
    ItemNumber = [dictionary objectForKey:@"ItemNumber"];
    PartNumber = [dictionary objectForKey:@"PartNumber"];
    Description = [dictionary objectForKey:@"Description"];
    UOMId = [[dictionary objectForKey:@"UomId"] intValue];
    IsBulk = [[dictionary objectForKey:@"IsBulk"] boolValue];
    IsSerial = [[dictionary objectForKey:@"IsSerial"] boolValue];
    ProgramId = [[dictionary objectForKey:@"ProgramId"] intValue];
    CustomAttributeCatalogs = [dictionary objectForKey:@"CACList"];
    InventoryTypeId = [[dictionary objectForKey:@"InventoryTypeId"] intValue];
    ProgramName = [dictionary objectForKey:@"ProgramName"];
    DetailsByStatus = [dictionary objectForKey:@"DetailsByStatus"];
    InventoryTypeName =[dictionary objectForKey:@"InventoryTypeName"];
    InventoryStatusName =[dictionary objectForKey:@"InventoryStatusName"];
    Qty = [[dictionary objectForKey:@"Quantity"] intValue];
    QuantityScanned = [[dictionary objectForKey:@"QuantityScanned"] intValue];
    LocationId = [[dictionary objectForKey:@"LocationId"] intValue];
    InventoryStatusId = [[dictionary objectForKey:@"InventoryStatusId"] intValue];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSDictionary *uomList = ([dictionary objectForKey:@"UOMList"] != [NSNull null] ? [dictionary objectForKey:@"UOMList"] : nil);
//    uomList = [dictionary objectForKey:@"UOMList"];
    for (NSDictionary *dict in uomList) {
        EWHUOM *uom = [[EWHUOM alloc] initWithDictionary:dict];
        [items addObject:uom];
    }
//    self.items = [items copy];
    
    UOMs = [items copy];
    return [super init];
}

@end
