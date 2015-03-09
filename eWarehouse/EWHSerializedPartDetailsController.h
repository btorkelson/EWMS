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
#import "EWHPutAwaySerializedPartRequest.h"
#import "EWHGetReceiptDetailsRequest.h"

@interface EWHSerializedPartDetailsController : UITableViewController <DTDeviceDelegate>
{
//    IBOutlet UITableView *tableView;
    IBOutlet UILabel *scannerMsg;
    IBOutlet UIButton* btnScanSerialNumber;
}

@property (nonatomic, strong) EWHReceipt *receipt;
@property (nonatomic, strong) EWHReceiptDetail *receiptDetails;
@property (nonatomic, strong) EWHWarehouse *warehouse;

@end
