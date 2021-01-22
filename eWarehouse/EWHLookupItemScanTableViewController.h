//
//  EWHLookupItemScanTableViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 12/17/20.
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHLookupItemTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHLookupItemScanTableViewController : UITableViewController
{
    
    IBOutlet UITextField *txtPartNumber;
    IBOutlet UITextField *txtSerialNumber;
}

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (strong, nonatomic) IBOutlet UITextField *txtPartNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtSerialNumber;
@property (weak, nonatomic) UITextField *currentTextField;
@end

NS_ASSUME_NONNULL_END
