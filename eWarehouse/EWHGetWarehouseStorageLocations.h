//
//  EWHGetWarehouseStorageLocations.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHRequestAF.h"
#import "EWHLocation.h"

@interface EWHGetWarehouseStorageLocations : EWHRequestAF
{
}

- (void)getWarehouseStorageLocations:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
