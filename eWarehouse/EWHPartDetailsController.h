//
//  EWHLoginClass.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHReceipt.h"
#import "EWHReceiptDetail.h"
#import "EWHPutAwayPartRequest.h"
#import "EWHGetReceiptDetailsRequest.h"

@interface EWHPartDetailsController : UITableViewController
{
    IBOutlet UILabel *lblReceiptNumber;
    IBOutlet UILabel *lblPartNumber;
    IBOutlet UITextField *txtQuantity;
    IBOutlet UILabel *lblQuantity;
    IBOutlet UIStepper *stepper;
}

@property (nonatomic, strong) EWHReceipt *receipt;
@property (nonatomic, strong) EWHReceiptDetail *receiptDetails;
@property (nonatomic, strong) EWHWarehouse *warehouse;

@end
