//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"
#import "EWHReceiptDetail.h"

@interface EWHGetReceiptDetailByContainerScanRequest : EWHRequest
{
}

- (void)getReceiptDetailByContainerScan:(NSString *)containerScan receiptId:(NSInteger) receiptId withAuthHash:(NSString *)authHash;

@end