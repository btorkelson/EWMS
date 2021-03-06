//
//  EWHReceiptItemConfirmationViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 11/5/14.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHAddReceiptXDockItem.h"

@interface EWHReceiptItemConfirmationViewController : UITableViewController {
    
    
    IBOutlet UILabel *lblReceiptNumber;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblDestination;
    IBOutlet UILabel *lblPartNumber;
    IBOutlet UITextField *txtQuantity;
    IBOutlet UIStepper *stQuantityStepper;
    IBOutlet UITextField *txtLineNumber;
    IBOutlet UITextField *txtLotNumber;
}

@property (nonatomic, strong) EWHCatalog *catalog;
@property (nonatomic, strong) EWHLocation *location;
@property (nonatomic, strong) EWHDestination *destination;
@property (nonatomic, strong) NSMutableArray *SerialNumbers;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnAddItem;

@end
