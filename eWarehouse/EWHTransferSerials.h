//
//  EWHTransferSerials.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/30/17.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHCatalog.h"
#import "EWHTransferScanNewLocation.h"

@interface EWHTransferSerials : UITableViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) EWHCatalog *catalog;
//@property (strong, nonatomic) IBOutlet UILabel *lblPartNumber;
//@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
//@property (strong, nonatomic) IBOutlet UILabel *lblBulk;
@property (strong, nonatomic) IBOutlet UITextField *txtInputSerial;
@property (strong, nonatomic) IBOutlet UIView *viewSerialTextbox;
@end
