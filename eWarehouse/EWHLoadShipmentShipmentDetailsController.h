//
//  EWHLoadShipmentShipmentDetailsController.h
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
#import "EWHGetShipmentDetailsForLoadingRequest.h"
#import "EWHLoadShipmentSelectLocationController.h"
#import "EWHLoadShipmentGetPartDetailsController.h"
#import "EWHLoadShipmentGetSerializedPartDetailsController.h"

@interface EWHLoadShipmentShipmentDetailsController : UITableViewController <DTDeviceDelegate>

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHShipment *shipment;
@property (nonatomic, strong) NSMutableArray *shipmentDetails;
@property (nonatomic, strong) EWHLocation *location;

@end
    