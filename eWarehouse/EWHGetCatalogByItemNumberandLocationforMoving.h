//
//  EWHGetCatalogByItemNumberandLocationforMoving.h
//  eWarehouse
//
//  Created by Brian Torkelson on 4/11/19.
//
//

#import "EWHRequest.h"
#import "EWHCatalog.h"


@interface EWHGetCatalogByItemNumberandLocationforMoving : EWHRequest

- (void)getCatalogByItemNumberandLocationforMoving:(NSInteger)programId warehouseId:(NSInteger)warehouseId itemNumber:(NSString *)itemnumber location:(NSString *)location withAuthHash:(NSString *)authHash;
@end
