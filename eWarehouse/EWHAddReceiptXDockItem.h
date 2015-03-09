//
//  EWHAddReceiptItem.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHRequest.h"
#import "EWHReceiptDetail.h"
#import "EWHResponse.h"
#import "EWHUOM.h"
#import "EWHUtils.h"

@interface EWHAddReceiptXDockItem : EWHRequest
{
}

- (void)addReceiptItemforXDock:(NSInteger)warehouseId programId:(NSInteger)programId receiptId:(NSInteger)receiptId locationId:(NSInteger)locationId catalogId:(NSInteger)catalogId quantity:(NSInteger)quantity IsBulk:(BOOL)isBulk customAttributes:(NSMutableArray *)customAttributes itemScan:(NSString *)itemScan destinationId:(NSInteger)destinationId inventoryTypeId:(NSInteger)inventoryTypeId shipMethodId:(NSInteger)shipMethodId UOMs:(NSMutableArray *)UOMs deliveryDate:(NSDate*)deliveryDate user:(EWHUser *)user;

@end
