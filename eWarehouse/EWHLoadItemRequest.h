//
//  EWHLoadItemRequest.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHShipmentDetail.h"
#import "EWHLocation.h"
#import "EWHResponse.h"

@interface EWHLoadItemRequest : EWHRequestAF
{
}

-(void)loadItem:(EWHShipmentDetail *)shipmentDetail warehouse:(NSInteger)warehouseId location:(EWHLocation *)location quantity:(NSInteger)quantity user:(EWHUser *)user;

@end
