//
//  EWHSortScanPartsController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 8/29/19.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHSortJob.h"
#import "EWHAddSortJobDetails.h"
#import "DTDevices.h"


NS_ASSUME_NONNULL_BEGIN

@interface EWHSortScanPartsController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHSortJob *sortJob;
@property (nonatomic, strong) NSMutableArray *partNumbers;
@property (weak, nonatomic) IBOutlet UITextField *txtPartNumber;

@end

NS_ASSUME_NONNULL_END
