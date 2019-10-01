//
//  EWHAddSortJobDetails.h
//  eWarehouse
//
//  Created by Brian Torkelson on 8/29/19.
//

#import "EWHRequest.h"
#import "EWHResponse.h"
#import "EWHUOM.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHAddSortJobDetails : EWHRequest

- (void)addSortJobDetails:(NSInteger)sortJobId partNumbers:(NSMutableArray *)partNumbers user:(EWHUser *)user ;

@end

NS_ASSUME_NONNULL_END
