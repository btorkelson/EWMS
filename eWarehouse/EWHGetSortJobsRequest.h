//
//  EWHGetSortJobsRequest.h
//  eWarehouse
//
//  Created by Brian Torkelson on 8/28/19.
//

#import "EWHRequestAF.h"
#import "EWHSortJob.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHGetSortJobsRequest : EWHRequestAF

- (void)getSortJobsRequest:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;
@end

NS_ASSUME_NONNULL_END
