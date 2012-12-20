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
#import "EWHPutAwayContainerRequest.h"
#import "EWHGetReceiptDetailsRequest.h"

@interface EWHContainerDetailsController : UITableViewController
{
    IBOutlet UILabel *lblReceiptNumber;
    IBOutlet UILabel *lblContainerNumber;
}

@property (nonatomic, strong) EWHReceipt *receipt;
@property (nonatomic, strong) EWHReceiptDetail *receiptDetails;
@property (nonatomic, strong) EWHWarehouse *warehouse;

@end
