//
//  EWHTransferQuantitySerials.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/25/17.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHQuantityTextField.h"
#import "EWHCatalog.h"
#import "EWHTransferScanNewLocation.h"

@interface EWHTransferQuantitySerials : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) EWHCatalog *catalog;
@property (strong, nonatomic) IBOutlet UILabel *lblPartNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblBulk;
@property (strong, nonatomic) IBOutlet EWHQuantityTextField *txtQuantity;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalQty;
@end
