//
//  EWHLoginClass.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineaSDK.h"
#import "EWHRootViewController.h"
#import "EWHReceipt.h"
#import "EWHReceiptDetail.h"
#import "EWHWarehouse.h"
#import "EWHScanItemController.h"
#import "EWHIsWarehouseLocationValidRequest.h"

@interface EWHScanLocationController : UITableViewController <LineaDelegate>
{
    IBOutlet UIButton* btnScanLocation;
    IBOutlet UILabel *scannerMsg;
    IBOutlet UIImageView *battery;
    IBOutlet UILabel *voltageLabel;
}

@property (nonatomic, strong) EWHReceipt *receipt;
@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) EWHReceiptDetail *receiptDetails;
@property (nonatomic, strong) NSMutableArray *serialNumbers;
@property (nonatomic) NSInteger quantity;

@end
