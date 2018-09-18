//
//  EWHTransferScanNewLocation.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/26/17.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHCatalog.h"
#import "EWHMoveInventory.h"
#import "DTDevices.h"

@interface EWHTransferScanNewLocation : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtNewLocation;

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) EWHCatalog *catalog;
@property (nonatomic) NSInteger quantity;
@property (nonatomic, strong) NSMutableArray *serials;
@end
