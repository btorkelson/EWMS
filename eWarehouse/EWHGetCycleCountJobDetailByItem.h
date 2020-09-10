//
//  EWHGetCycleCountJobDetailByItem.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/17/20.
//

#import "EWHRequestAF.h"
#import "EWHUser.h"
#import "EWHCycleCountCatalogbyLocation.h"

@interface EWHGetCycleCountJobDetailByItem : EWHRequestAF

- (void)getCycleCountJobDetailItemCatalogs:(NSInteger)cyclecountJobId locationId:(NSInteger)locationId user:(EWHUser *)user;
@end
