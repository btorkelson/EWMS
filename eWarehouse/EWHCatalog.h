//
//  EWHCatalog.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import <Foundation/Foundation.h>
#import "EWHUOM.h"
#import "EWHCustomAttributeCatalog.h"

@interface EWHCatalog : NSObject {
    NSInteger CatalogId;
    NSString *ItemNumber;
    NSString *Description;
    NSInteger UOMId;
    BOOL IsBulk;
    BOOL IsSerial;
    NSInteger ProgramId;
    NSMutableArray *CustomAttributeCatalogs;
    NSInteger InventoryTypeId;
    NSMutableArray *UOMs;
}
@property (assign, nonatomic) NSInteger CatalogId;
@property (nonatomic, retain) NSString *ItemNumber;
@property (nonatomic, retain) NSString *PartNumber;
@property (nonatomic, retain) NSString *Description;
@property (assign, nonatomic) NSInteger UOMId;
@property (nonatomic) BOOL IsBulk;
@property (nonatomic) BOOL IsSerial;
@property (assign, nonatomic) NSInteger ProgramId;
@property (nonatomic, retain) NSMutableArray *CustomAttributeCatalogs;
@property (assign, nonatomic) NSInteger InventoryTypeId;
@property (nonatomic, retain) NSMutableArray *UOMs;
@property (nonatomic, retain) NSString *ProgramName;
@property (nonatomic, retain) NSMutableArray *DetailsByStatus;
@property (nonatomic, retain) NSString *InventoryTypeName;
@property (nonatomic, retain) NSString *InventoryStatusName;
@property (assign, nonatomic) NSInteger Qty;
@property (assign, nonatomic) NSInteger LocationId;
@property (assign, nonatomic) NSInteger InventoryStatusId;
@property (assign, nonatomic) NSInteger QuantityScanned;
@property (nonatomic, retain) NSMutableArray *ScannedSerials;

- (EWHCatalog *)initWithDictionary:(NSDictionary *)dictionary;



@end
