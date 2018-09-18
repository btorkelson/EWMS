//
//  EWHTransferScanPart.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/25/17.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHTransferQuantitySerials.h"
#import "EWHTransferSerials.h"
#import "EWHProgram.h"
#import "DTDevices.h"

@interface EWHTransferScanPart : UIViewController

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHProgram *program;
@property (nonatomic, strong) NSString *location;
@property (strong, nonatomic) IBOutlet UITextField *txtPartNumber;
@end
