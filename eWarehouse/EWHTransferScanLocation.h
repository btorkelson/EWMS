//
//  UIViewController+EWHTransferScanLocation.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/25/17.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHTransferScanPart.h"
#import "DTDevices.h"


@interface EWHTransferScanLocation : UIViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (strong, nonatomic) IBOutlet UITextField *txtScanLocation;
@property (nonatomic, strong) EWHProgram *program;
@end
