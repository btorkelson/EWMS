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

@interface EWHAddReceiptHeader : EWHRequest
{
}

- (void)addReceiptHeader:(EWHReceipt *)receipt user:(EWHUser *)user;

@end
