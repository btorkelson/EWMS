//
//  EWHGetItemLocationSummarybyPart.h
//  eWarehouse
//
//  Created by Brian Torkelson on 12/17/20.
//

#import "EWHRequestAF.h"
#import "EWHItemDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHGetItemLocationSummarybyPart : EWHRequestAF

- (void)getItemLocationSummarybyPart:(NSInteger)warehouseId partNumber:(NSString *)partNumber serial:(NSString *)serial withAuthHash:(NSString *)authHash;

@end

NS_ASSUME_NONNULL_END
