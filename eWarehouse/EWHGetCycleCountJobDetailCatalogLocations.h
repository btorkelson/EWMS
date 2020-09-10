//
//  EWHGetCycleCountJobDetailCatalogLocations.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/16/20.
//

#import "EWHRequestAF.h"
#import "EWHUser.h"
#import "EWHCycleCountCatalogbyLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHGetCycleCountJobDetailCatalogLocations : EWHRequestAF

- (void)getCycleCountJobDetailCatalogLocations:(NSInteger)cyclecountJobId catalogId:(NSInteger)catalogId user:(EWHUser *)user;
@end

NS_ASSUME_NONNULL_END
