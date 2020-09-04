//
//  EWHLoginClass.h
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
#import "EWHLocation.h"
#import "EWHPickContainerRequest.h"
#import "EWHPickItemRequest.h"
#import "EWHPickSerializedItemRequest.h"
#import "EWHGetShipmentDetailsForPickingRequest.h"
#import "EWHSelectLocationControllerNEW.h"

@class EWHSelectShipmentController;
@class EWHShipmentDetailsController;

@interface EWHPickShipmentScanLocationController : UITableViewController <DTDeviceDelegate>
{
    IBOutlet UIBarButtonItem *btnPick;
    IBOutlet UIButton* btnScanLocation;
    IBOutlet UILabel *scannerMsg;
    IBOutlet UIImageView *battery;
    IBOutlet UILabel *voltageLabel;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnPick;
@property (nonatomic, strong) EWHShipment *shipment;
@property (nonatomic, strong) EWHShipmentDetail *shipmentDetail;
@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHLocation *location;
@property (nonatomic) NSInteger quantity;
@property (nonatomic, strong) NSString *serialNumbers;
@property (nonatomic, strong) NSString *storagelocation;
@end
