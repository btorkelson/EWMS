//
//  EWHSelectSortJobController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 8/28/19.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHGetSortJobsRequest.h"
#import "EWHSortJob.h"
#import "EWHSortScanPartsController.h"


NS_ASSUME_NONNULL_BEGIN

@interface EWHSelectSortJobController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSMutableArray *sortjobs;
@end

NS_ASSUME_NONNULL_END
