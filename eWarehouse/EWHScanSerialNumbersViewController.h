//
//  EWHScanSerialNumbersViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/18/15.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHReceiptItemConfirmationViewController.h"

@interface EWHScanSerialNumbersViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *txtSerial;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) NSMutableArray *SerialNumbers;
@property (nonatomic, strong) EWHCatalog *catalog;
@property (nonatomic, strong) EWHLocation *location;
@end
