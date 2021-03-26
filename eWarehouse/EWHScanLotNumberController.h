//
//  EWHScanLotNumberController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 3/1/21.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHShipment.h"
#import "EWHShipmentDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHScanLotNumberController : UITableViewController

@property (nonatomic, strong) EWHShipment *shipment;
@property (nonatomic, strong) EWHShipmentDetail *shipmentDetail;
@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHLocation *location;
@property (nonatomic, strong) NSString *storagelocation;
@property (strong, nonatomic) IBOutlet UITextField *txtLotNumber;
@property (nonatomic, strong) NSString *serialNumbers;
@property (nonatomic) NSInteger quantity;
@end

NS_ASSUME_NONNULL_END
