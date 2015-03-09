//
//  EWHLoginClass.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHShipment.h"
#import "EWHShipmentDetail.h"
#import "EWHLocation.h"
#import "EWHGetLocationsForPickingRequest.h"
#import "EWHScanContainerController.h"
#import "EWHShipmentDetailsController.h"

@interface EWHSelectLocationController : UITableViewController
{
}

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHShipment *shipment;
@property (nonatomic, strong) EWHShipmentDetail *shipmentDetail;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSString *storagelocation;

@end
    