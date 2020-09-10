//
//  EWHAddReceiptHeader.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/5/14.
//
//

#import "EWHRequestAF.h"
#import "EWHReceipt.h"
#import "EWHResponse.h"
#import "EWHNewReceiptDataObject.h"

@interface EWHAddReceiptHeader : EWHRequestAF
{
}

- (void)addReceiptHeader:(EWHNewReceiptDataObject *)receipt user:(EWHUser *)user;

@end
