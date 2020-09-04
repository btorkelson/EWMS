//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHReceiptDetail.h"

@interface EWHGetReceiptDetailByPartNumberRequest : EWHRequestAF
{
}

- (void)getReceiptDetailByPartNumber:(NSString *)partNumber receiptId:(NSInteger) receiptId withAuthHash:(NSString *)authHash;

@end
