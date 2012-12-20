//
//  EWHLoginClass.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHSelectActionController.h"

@interface EWHSelectWarehouseController : UITableViewController
{

}
- (IBAction)signOut:(id)sender;

@property (nonatomic, strong) NSMutableArray *warehouses;

@end
    