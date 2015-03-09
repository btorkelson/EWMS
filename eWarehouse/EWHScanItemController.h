//
//  EWHLoginClass.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTDevices.h"
#import "EWHRootViewController.h"
#import "EWHReceipt.h"
#import "EWHReceiptDetail.h"
#import "EWHGetReceiptDetailByPartNumberRequest.h"
#import "EWHGetReceiptDetailByContainerScanRequest.h"
#import "EWHContainerDetailsController.h"
#import "EWHPartDetailsController.h"
#import "EWHSerializedPartDetailsController.h"

@interface EWHScanItemController : UITableViewController <DTDeviceDelegate>
{
    IBOutlet UIButton* btnScanItem;
    IBOutlet UILabel *scannerMsg;
    IBOutlet UIImageView *battery;
    IBOutlet UILabel *voltageLabel;
}

@property (nonatomic, strong) EWHReceipt *receipt;
@property (nonatomic, strong) EWHWarehouse *warehouse;

@end
