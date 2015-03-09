//
//  EWHSelectProgramforReceiptController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/30/14.
//
//


#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHGetProgramsforReceipt.h"
#import "EWHCreateReceiptController.h"
#import "EWHNewReceiptDataObject.h"
#import "EWHAppDelegateProtocal.h"
#import "EWHGetSavedReceipt.h"


@interface EWHSelectProgramforReceiptController : UITableViewController
{
}

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSMutableArray *programs;

@end
