//
//  EWHGetSavedReceipt.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/5/14.
//
//

#import "EWHRequest.h"
#import "EWHReceipt.h"

@interface EWHGetSavedReceipt : EWHRequest
{
}

- (void)getSavedReceipt:(NSInteger)programId warehouseId:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
