//
//  EWHScanPartController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "DTDevices.h"
#import "EWHCatalog.h"
#import "EWHGetCatalogByItemNumber.h"
#import "EWHSelectStorageLocationViewController.h"
#import "EWHAddLabelstoPrintQueue.h"
#import "EWHGetCustomAttributeCatalogViewController.h"
#import "EWHSelectInventoryTypeViewController.h"
#import "EWHGetUOMWeightViewController.h"
#import "EWHGetCatalogByProgram.h"
#import "EWHAddCatalogCustomAttributesViewController.h"


@interface EWHScanPartController : UITableViewController <DTDeviceDelegate>
{
    
    IBOutlet UIButton *btnScanPart;
    IBOutlet UITextField *txtPartNumber;
    IBOutlet UIPickerView *pvPicker;
}

    @property (nonatomic, strong) NSArray *catalogs;
@end
