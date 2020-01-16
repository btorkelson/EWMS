//
//  EWHCycleCountLocationBulkController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/13/20.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHQuantityTextField.h"
#import "EWHCycleCountJobDetail.h"
#import "EWHCycleCountCatalogbyLocation.h"


@interface EWHCycleCountLocationBulkController : UITableViewController

@property (nonatomic, strong) EWHCycleCountJobDetail *location;
@property (nonatomic, strong) EWHCycleCountCatalogbyLocation *catalog;
@property (strong, nonatomic) IBOutlet EWHQuantityTextField *txtQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblPartNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblBulkSerial;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;

@end

