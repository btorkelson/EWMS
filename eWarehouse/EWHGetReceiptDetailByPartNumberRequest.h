//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"
#import "EWHReceiptDetail.h"

@interface EWHGetReceiptDetailByPartNumberRequest : EWHRequest
{
}

- (void)getReceiptDetailByPartNumber:(NSString *)partNumber receiptId:(NSInteger) receiptId withAuthHash:(NSString *)authHash;

@end