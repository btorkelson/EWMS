//
//  EWHAddReceiptItem.h
//  eWarehouse
//
//  Created by Brian Torkelson on 3/4/14.
//
//

#import "EWHRequest.h"
#import "EWHReceiptDetail.h"
#import "EWHResponse.h"
#import "EWHUOM.h"

@interface EWHAddReceiptItem : EWHRequest
{
}

- (void)addReceiptItem:(NSInteger)warehouseId programId:(NSInteger)programId receiptId:(NSInteger)receiptId locationId:(NSInteger)locationId catalogId:(NSInteger)catalogId quantity:(NSInteger)quantity IsBulk:(BOOL)isBulk IsSerialized:(BOOL)IsSerialized itemScan:(NSMutableArray *)itemScan user:(EWHUser *)user inventoryTypeId:(NSInteger)inventoryTypeId customAttributes:(NSMutableArray *)customAttributes UOMs:(NSMutableArray *)UOMs lineNumber:(NSString *)lineNumber lotNumber:(NSString *)lotNumber;


@end
