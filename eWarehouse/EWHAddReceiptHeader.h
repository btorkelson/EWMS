//
//  EWHAddReceiptHeader.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/5/14.
//
//

#import "EWHRequest.h"
#import "EWHReceipt.h"
#import "EWHResponse.h"
#import "EWHNewReceiptDataObject.h"

@interface EWHAddReceiptHeader : EWHRequest
{
}

- (void)addReceiptHeader:(EWHNewReceiptDataObject *)receipt user:(EWHUser *)user;

@end
