//
//  EWHSelectStorageLocationViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//


#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHGetWarehouseStorageLocations.h"
#import "EWHSelectDestinationViewController.h"
#import "EWHAddReceiptItem.h"
#import "EWHLocationsByType.h"

@interface EWHSelectStorageLocationViewController : UITableViewController
{
}

@property (nonatomic, strong) NSMutableArray *locations;
//@property (nonatomic, strong) NSMutableArray *uniqueLocationTypes;
@property (nonatomic, strong) EWHCatalog *catalog;
@property (strong, nonatomic) NSMutableDictionary *uniqueLocationTypes;
@property (strong, nonatomic) NSMutableArray *sortedLocationTypes;
@property (strong, nonatomic) NSMutableArray *cellSections;
@property (strong, nonatomic) NSMutableDictionary *sourceLocations;

@end
