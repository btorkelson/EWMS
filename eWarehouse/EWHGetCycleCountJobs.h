//
//  EWHGetCycleCountJobs.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import "EWHRequestAF.h"
#import "EWHCycleCountJob.h"

@interface EWHGetCycleCountJobs : EWHRequestAF


- (void)getCycleCountJobs:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
