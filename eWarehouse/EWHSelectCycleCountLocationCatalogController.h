//
//  EWHSelectCycleCountLocationCatalogController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/24/18.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHLocation.h"
#import "EWHWarehouse.h"
#import "EWHCycleCountJob.h"
#import "EWHGetCycleCountJobDetailLocationCatalogs.h"

@interface EWHSelectCycleCountLocationCatalogController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHCycleCountJob *cyclecountJob;
@property (nonatomic,strong) EWHLocation *location;

@end
