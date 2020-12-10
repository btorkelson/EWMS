//
//  EWHAddCatalogCustomAttributesViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 12/9/20.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHProgram.h"
#import "EWHNewReceiptDataObject.h"
#import "EWHCustomAttributeCatalog.h"
#import "EWHAppDelegateProtocal.h"
#import "EWHCellforTextTableViewCell.h"
#import "EWHCellforTextLabelTableViewCell.h"
#import "EWHCellforCheckboxTableViewCell.h"
#import "DTDevices.h"


@interface EWHAddCatalogCustomAttributesViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *CATableView;
@property (weak, nonatomic) UITextField *currentTextField;
@property (nonatomic, strong) NSArray *visibleCustomAttributes;
@property (nonatomic, strong) NSIndexPath *dropdownIndexPath;
@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, strong) EWHCatalog *catalog;

@end

