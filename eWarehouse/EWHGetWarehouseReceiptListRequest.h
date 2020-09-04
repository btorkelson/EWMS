//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHReceipt.h"

@interface EWHGetWarehouseReceiptListRequest : EWHRequestAF
{
}

- (void)getWarehouseReceiptListRequest:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
