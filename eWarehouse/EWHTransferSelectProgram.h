//
//  EWHTransferSelectProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/26/17.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHTransferScanLocation.h"
#import "EWHGetWarehouseProgramListAll.h"

@interface EWHTransferSelectProgram : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSMutableArray *programs;
@end
 
