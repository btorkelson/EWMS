//
//  EWHShipmentDetailsControllerNEW.h
//  eWarehouse
//
//  Created by Brian Torkelson on 6/6/13.
//
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHShipment.h"
#import "EWHShipmentDetail.h"
#import "EWHLocation.h"
#import "EWHGetShipmentDetailsforPickingRequestNEW.h"
#import "EWHSelectLocationController.h"
#import "EWHPickShipmentScanLocationController.h"
#import "EWHGetPartDetailsController.h"
#import "EWHGetSerializedPartDetailsController.h"

@interface EWHShipmentDetailsControllerNEW : UITableViewController <DTDeviceDelegate>

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHShipment *shipment;
@property (nonatomic, strong) NSMutableArray *shipmentDetails;
@property (nonatomic, strong) EWHLocation *location;
@property (nonatomic, strong) NSString *storagelocation;

@end
