//
//  EWHTransferViewCatalogs.h
//  eWarehouse
//
//  Created by Brian Torkelson on 4/11/19.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHCatalog.h"
#import "EWHTableViewCellforTransfer.h"
#import "EWHTransferQuantitySerials.h"


@interface EWHTransferViewCatalogs : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) EWHCatalog *catalog;
@property (nonatomic) NSInteger quantity;
@property (nonatomic, strong) NSMutableArray *catalogs;



@end
