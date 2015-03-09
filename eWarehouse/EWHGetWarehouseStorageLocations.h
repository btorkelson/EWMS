//
//  EWHGetWarehouseStorageLocations.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHRequest.h"
#import "EWHLocation.h"

@interface EWHGetWarehouseStorageLocations : EWHRequest
{
}

- (void)getWarehouseStorageLocations:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
