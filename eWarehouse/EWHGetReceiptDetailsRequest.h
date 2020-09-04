//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHReceiptDetail.h"

@interface EWHGetReceiptDetailsRequest : EWHRequestAF
{
}

- (void)getReceiptDetails:(NSInteger)receiptId withAuthHash:(NSString *)authHash;

@end
