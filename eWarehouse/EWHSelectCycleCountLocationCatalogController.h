//
//  EWHSelectCycleCountLocationCatalogController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/24/18.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHCycleCountJobDetail.h"
#import "EWHWarehouse.h"
#import "EWHCycleCountJob.h"
#import "EWHGetCycleCountJobDetailLocationCatalogs.h"
#import "EWHCycleCountLocationBulkController.h"
#import "EWHCycleCountLocationSerialController.h"
#import "EWHCycleCountCatalogbyLocation.h"
#import "EWHProcessCycleCountDetailByLocation.h"
#import "EWHFinichCycleCountJobDetail.h"
#import "DTDevices.h"

@interface EWHSelectCycleCountLocationCatalogController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHCycleCountJob *cyclecountJob;
@property (nonatomic,strong) EWHCycleCountJobDetail *location;
@property (nonatomic) NSInteger cyclecountJobDetailId;
@property (nonatomic, strong) NSMutableArray *cyclecountCatalogs;

@end
