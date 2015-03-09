//
//  EWHSelectDestinationViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//


#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHGetDestinationsByProgramWarehouse.h"
#import "EWHAddReceiptXDockItem.h"
#import "EWHDestinationsByType.h"
#import "EWHViewDestinationViewController.h"
#import "EWHReceiptItemConfirmationViewController.h"

@class EWHScanPartController;

@interface EWHSelectDestinationViewController : UITableViewController
{
}

@property (nonatomic, strong) NSMutableArray *destinations;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSMutableArray *cellSections;
@property (nonatomic, strong) EWHCatalog *catalog;
@property (nonatomic, strong) EWHLocation *location;
@property (nonatomic, strong) EWHDestination* lastdestination;


@end
