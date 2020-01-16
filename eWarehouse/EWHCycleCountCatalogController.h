//
//  EWHCycleCountCatalogController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/16/20.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHCycleCountJob.h"
#import "EWHCycleCountJobDetail.h"
#import "EWHGetCycleCountJobDetails.h"
#import "EWHCycleCountCatalogLocationController.h"
#import "DTDevices.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHCycleCountCatalogController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHCycleCountJob *cyclecountJob;
@property (nonatomic, strong) NSMutableArray *cyclecountCatalogs;
@end

NS_ASSUME_NONNULL_END
