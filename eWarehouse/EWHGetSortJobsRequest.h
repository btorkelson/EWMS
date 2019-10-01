//
//  EWHGetSortJobsRequest.h
//  eWarehouse
//
//  Created by Brian Torkelson on 8/28/19.
//

#import "EWHRequest.h"
#import "EWHSortJob.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHGetSortJobsRequest : EWHRequest

- (void)getSortJobsRequest:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;
@end

NS_ASSUME_NONNULL_END
