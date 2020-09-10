//
//  EWHGetCycleCountJobDetails.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import "EWHRequestAF.h"
#import "EWHCycleCountJobDetail.h"


@interface EWHGetCycleCountJobDetails : EWHRequestAF

- (void)getCycleCountJobDetails:(NSInteger)cyclecountJobId cyclecountJobTypeId:(NSInteger)cyclecountJobTypeId withAuthHash:(NSString *)authHash;
@end
