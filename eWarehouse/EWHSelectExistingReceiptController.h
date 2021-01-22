//
//  EWHSelectExistingReceiptController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/21/21.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHReceipt.h"
#import "EWHGetRecentReceipts.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHSelectExistingReceiptController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSMutableArray *receipts;
@end

NS_ASSUME_NONNULL_END
