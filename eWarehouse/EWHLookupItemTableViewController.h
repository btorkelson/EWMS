//
//  EWHLookupItemTableViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/28/14.
//
//

#import <UIKit/UIKit.h>
#import "EWHGetItemLocationSummarybyPart.h"
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHItemDetail.h"
#import "EWHTableViewCellforTransfer.h"

@interface EWHLookupItemTableViewController : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic,retain) NSString *PartNumber;
@property (nonatomic,retain) NSString *SerialNumber;
@property (nonatomic, strong) NSMutableArray *ItemArray;
@end
