//
//  EWHFinichCycleCountJobDetail.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/14/20.
//

#import "EWHRequestAF.h"
#import "EWHResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHFinichCycleCountJobDetail : EWHRequestAF

- (void)finishCycleCountJobDetail:(NSInteger)cycleCountJobDetailId cycleCountJobId:(NSInteger)cycleCountJobId user:(EWHUser *)user;
@end

NS_ASSUME_NONNULL_END
