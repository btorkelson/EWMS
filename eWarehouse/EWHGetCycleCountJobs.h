//
//  EWHGetCycleCountJobs.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import "EWHRequest.h"
#import "EWHCycleCountJob.h"

@interface EWHGetCycleCountJobs : EWHRequest


- (void)getCycleCountJobs:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
