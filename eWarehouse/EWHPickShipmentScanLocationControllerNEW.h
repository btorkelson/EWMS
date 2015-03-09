//
//  EWHPickShipmentScanLocationControllerNEW.h
//  eWarehouse
//
//  Created by Brian Torkelson on 6/11/13.
//
//

#import <Foundation/Foundation.h>
#import "DTDevices.h"
#import "EWHRootViewController.h"
#import "EWHShipmentDetailsControllerNEW.h"

@interface EWHPickShipmentScanLocationControllerNEW : UITableViewController <DTDeviceDelegate>
{
    IBOutlet UIButton* btnScanLocation;
    IBOutlet UILabel *scannerMsg;
    IBOutlet UIImageView *battery;
    IBOutlet UILabel *voltageLabel;
}

@property (nonatomic, strong) EWHShipment *shipment;
@property (nonatomic, strong) EWHShipmentDetail *shipmentDetail;
@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHLocation *location;
@property (nonatomic) NSInteger quantity;
@property (nonatomic, strong) NSString *serialNumbers;
@end
