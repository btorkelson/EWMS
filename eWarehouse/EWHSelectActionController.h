//
//  EWHLoginClass.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHSelectReceiptController.h"
#import "EWHLoadShipmentSelectShipmentController.h"
#import "EWHSelectProgramforReceiptController.h"
#import "EWHTransferSelectProgram.h"
#import "EWHSelectCylceCountJobController.h"
#import "EWHSelectSortJobController.h"

@interface EWHSelectActionController : UIViewController
{

}
- (IBAction)signOut:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblVersion;
@property (nonatomic, strong) EWHWarehouse *warehouse;

@end
    
