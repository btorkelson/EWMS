//
//  EWHGetCycleCountJobDetails.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import "EWHRequest.h"
#import "EWHCycleCountJobDetail.h"


@interface EWHGetCycleCountJobDetails : EWHRequest

- (void)getCycleCountJobDetails:(NSInteger)cyclecountJobId cyclecountJobTypeId:(NSInteger)cyclecountJobTypeId withAuthHash:(NSString *)authHash;
@end
