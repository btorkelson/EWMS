//
//  EWHProcessCycleCountDetailByLocation.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/14/20.
//

#import "EWHRequest.h"
#import "EWHCycleCountCatalogbyLocation.h"
#import "EWHResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHProcessCycleCountDetailByLocation : EWHRequest

- (void)processCycleCountDetailByLocation:(NSMutableArray *)details user:(EWHUser *)user;
@end

NS_ASSUME_NONNULL_END
