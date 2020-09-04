//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHReceiptDetail.h"

@interface EWHGetReceiptDetailByContainerScanRequest : EWHRequestAF
{
}

- (void)getReceiptDetailByContainerScan:(NSString *)containerScan receiptId:(NSInteger) receiptId withAuthHash:(NSString *)authHash;

@end
