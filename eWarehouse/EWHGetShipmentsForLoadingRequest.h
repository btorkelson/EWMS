//
//  EWHGetShipmentsForLoadingRequest.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHShipment.h"

@interface EWHGetShipmentsForLoadingRequest : EWHRequestAF
{
}

- (void)getShipmentsForLoadingRequest:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
