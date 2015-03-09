//
//  EWHLoginClass.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHWarehouse.h"
#import "EWHShipment.h"
#import "EWHGetShipmentsForPickingRequest.h"
#import "EWHSelectLocationControllerNEW.h"

@interface EWHSelectShipmentController : UITableViewController <DTDeviceDelegate>
{
}

@property (nonatomic, strong) EWHWarehouse *warehouse;
@property (nonatomic, strong) NSMutableArray *shipments;

@end
    