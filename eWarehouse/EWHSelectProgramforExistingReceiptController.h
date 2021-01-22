//
//  EWHSelectProgramforExistingReceiptController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/21/21.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHGetProgramsforReceipt.h"
#import "EWHSelectExistingReceiptController.h"
#import "EWHNewReceiptDataObject.h"
#import "EWHAppDelegateProtocal.h"
#import "EWHGetSavedReceipt.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHSelectProgramforExistingReceiptController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSMutableArray *programs;
@end

NS_ASSUME_NONNULL_END
