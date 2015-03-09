//
//  EWHViewDestinationViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 10/27/14.
//
//


#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"

@interface EWHViewDestinationViewController : UITableViewController {
    
    
    IBOutlet UILabel *lblDestination;
    IBOutlet UILabel *lblAddress1;
    IBOutlet UILabel *lblAddress2;
    IBOutlet UILabel *lblCityState;
}

@property (nonatomic, strong) EWHDestination* destination;
@property (nonatomic, strong) EWHLocation* location;
@property (nonatomic, strong) EWHCatalog* catalog;
@end
