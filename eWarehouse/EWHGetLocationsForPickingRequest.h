//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"
#import "EWHLocation.h"

@interface EWHGetLocationsForPickingRequest : EWHRequest
{
}

- (void)getLocationsForPickingRequest:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end