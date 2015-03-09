//
//  EWHSelectInventoryTypeViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 10/16/14.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHGetInventoryTypesforProgram.h"
#import "EWHSelectStorageLocationViewController.h"
#import "EWHInventoryType.h"

@interface EWHSelectInventoryTypeViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *inventoryTypes;
@property (nonatomic, strong) EWHCatalog *catalog;

@end
