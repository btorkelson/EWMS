//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"
#import "EWHReceipt.h"

@interface EWHIsWarehouseLocationValidRequest : EWHRequest
{
}

- (void)isWarehouseLocationValid:(NSInteger)warehouseId locationName:(NSString *)location  withAuthHash:(NSString *)authHash;

@end