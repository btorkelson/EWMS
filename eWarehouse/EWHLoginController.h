//
//  EWHLoginClass.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHLoginRequest.h"
#import "EWHGetUserWarehouseListRequest.h"
#import "EWHSelectWarehouseController.h"
#import "DTDevices.h"

@interface EWHLoginController : UIViewController <DTDeviceDelegate>{
   
}
- (void) clearForm;

//-(void) signInCallback: (EWHUser*) user;
//-(void) getWarehouseListCallback: (NSMutableArray*) warehouses;
//-(void) errorCallback: (NSError*) error;
//-(void) accessDeniedCallback;

//@property (nonatomic, strong) EWHRootViewController *rootController;
@end
    