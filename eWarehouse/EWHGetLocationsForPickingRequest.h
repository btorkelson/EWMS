//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHLocation.h"

@interface EWHGetLocationsForPickingRequest : EWHRequestAF
{
}

- (void)getLocationsForPickingRequest:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
