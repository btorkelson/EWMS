//
//  EWHSelectCycleCountLocationController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHCycleCountJob.h"
#import "EWHLocation.h"
#import "EWHGetCycleCountJobDetails.h"
#import "EWHSelectCycleCountLocationCatalogController.h"

@interface EWHSelectCycleCountLocationController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHCycleCountJob *cyclecountJob;
@property (nonatomic, strong) NSMutableArray *cyclecountLocations;
@end
