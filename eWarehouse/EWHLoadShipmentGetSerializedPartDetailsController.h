//
//  EWHLoadShipmentGetSerializedPartDetailsController.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTDevices.h"
#import "EWHRootViewController.h"
#import "EWHShipment.h"
#import "EWHShipmentDetail.h"
#import "EWHLoadSerializedItemRequest.h"

@interface EWHLoadShipmentGetSerializedPartDetailsController : UITableViewController <DTDeviceDelegate>
{
    IBOutlet UILabel *scannerMsg;
    IBOutlet UIButton* btnScanSerialNumber;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnLoad;
@property (nonatomic, strong) EWHShipment *shipment;
@property (nonatomic, strong) EWHShipmentDetail *shipmentDetail;
@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHLocation *location;

@end
