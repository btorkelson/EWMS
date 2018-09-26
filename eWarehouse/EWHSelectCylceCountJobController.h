//
//  EWHSelectCylceCountJobController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHCycleCountJob.h"
#import "EWHGetCycleCountJobs.h"
#import "EWHSelectCycleCountLocationController.h"

@interface EWHSelectCylceCountJobController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSMutableArray *cyclecountJobs;

@end