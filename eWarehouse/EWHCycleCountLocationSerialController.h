//
//  EWHCycleCountLocationSerialController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/14/20.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHCycleCountJobDetail.h"
#import "EWHCycleCountCatalogbyLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHCycleCountLocationSerialController : UITableViewController

@property (nonatomic, strong) EWHCycleCountJobDetail *location;
@property (nonatomic, strong) EWHCycleCountCatalogbyLocation *catalog;
@property (weak, nonatomic) IBOutlet UITextField *txtInputSerial;

@end

NS_ASSUME_NONNULL_END
