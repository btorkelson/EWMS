//
//  EWHGetCycleCountJobDetailLocationCatalogs.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/24/18.
//
//

#import "EWHRequestAF.h"
#import "EWHUser.h"
#import "EWHCycleCountCatalogbyLocation.h"

@interface EWHGetCycleCountJobDetailLocationCatalogs : EWHRequestAF

- (void)getCycleCountJobDetailLocationCatalogs:(NSInteger)cyclecountJobId locationId:(NSInteger)locationId isNew:(BOOL)isNew user:(EWHUser *)user;
@end
