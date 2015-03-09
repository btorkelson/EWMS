//
//  EWHPickSerializedItemRequest.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"
#import "EWHShipmentDetail.h"
#import "EWHLocation.h"
#import "EWHResponse.h"

@interface EWHPickSerializedItemRequest : EWHRequest
{
}

-(void)pickItem:(EWHShipmentDetail *)shipmentDetail warehouse:(NSInteger)warehouseId location:(EWHLocation *)location locationName:(NSString *)locationName serialNumbers:(NSString *)serialNumbers user:(EWHUser *)user;

@end