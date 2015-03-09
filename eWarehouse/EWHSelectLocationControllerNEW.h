//
//  EWHSelectLocationControllerNEW.h
//  eWarehouse
//
//  Created by Brian Torkelson on 6/3/13.
//
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHShipment.h"
#import "EWHShipmentDetail.h"
#import "EWHLocation.h"
#import "EWHGetLocationsforPickingRequestNEW.h"
#import "EWHSelectLocationController.h"
#import "EWHPickShipmentScanLocationController.h"
#import "EWHGetPartDetailsController.h"
#import "EWHGetSerializedPartDetailsController.h"
#import "EWHShipmentDetailsControllerNEW.h"



@interface EWHSelectLocationControllerNEW : UITableViewController <DTDeviceDelegate>

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHShipment *shipment;
@property (nonatomic, strong) NSMutableArray *shipmentLocations;
@property (nonatomic, strong) EWHLocation *location;
@end
