//
//  EWHCycleCountCatalogLocationController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/16/20.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHCycleCountJobDetail.h"
#import "EWHWarehouse.h"
#import "EWHCycleCountJob.h"
#import "EWHFinichCycleCountJobDetail.h"
#import "DTDevices.h"
#import "EWHGetCycleCountJobDetailCatalogLocations.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHCycleCountCatalogLocationController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHCycleCountJob *cyclecountJob;
@property (nonatomic,strong) EWHCycleCountJobDetail *catalog;
@property (nonatomic) NSInteger cyclecountJobDetailId;
@property (nonatomic, strong) NSMutableArray *cyclecountLocations;
@end

NS_ASSUME_NONNULL_END
