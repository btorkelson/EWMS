//
//  EWHGetRecentReceipts.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/21/21.
//

#import "EWHRequestAF.h"
#import "EWHReceipt.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHGetRecentReceipts : EWHRequestAF

- (void)getRecentReceipts:(NSInteger)warehouseId programId:(NSInteger)programId withAuthHash:(NSString *)authHash;
@end

NS_ASSUME_NONNULL_END
