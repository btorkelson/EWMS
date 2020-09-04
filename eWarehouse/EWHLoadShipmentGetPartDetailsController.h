//
//  EWHLoadShipmentGetPartDetailsController.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHShipment.h"
#import "EWHShipmentDetail.h"
#import "EWHLoadItemRequest.h"

@interface EWHLoadShipmentGetPartDetailsController : UITableViewController
{
    IBOutlet UILabel *lblProgramName;
    IBOutlet UILabel *lblShipmentNumber;
    IBOutlet UILabel *lblReceivedDate;
    IBOutlet UILabel *lblShipmentDetailNumber;
    IBOutlet UITextField *txtQuantity;
    IBOutlet UILabel *lblQuantity;
    IBOutlet UIStepper *stepper;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnLoad;
@property (nonatomic, strong) EWHShipment *shipment;
@property (nonatomic, strong) EWHShipmentDetail *shipmentDetail;
@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHLocation *location;

@end
