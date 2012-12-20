//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"
#import "EWHReceipt.h"

@interface EWHGetWarehouseReceiptListRequest : EWHRequest
{
}

- (void)getWarehouseReceiptListRequest:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end