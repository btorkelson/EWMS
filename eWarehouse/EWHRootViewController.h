//
//  EWHViewController.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EWHUser.h"
#import "EWHLoginController.h"
#import "EWHSelectWarehouseController.h"
#import "EWHSelectShipmentController.h"
#import "EWHShipmentDetailsController.h"

@class EWHSelectReceiptController;
@class EWHScanItemController;
@class EWHLoginController;
@class EWHSelectShipmentController;
@class EWHShipmentDetailsController;

@interface EWHRootViewController : UINavigationController

- (void)signOut;
- (void)showLoading;
- (void)hideLoading;
- (void)displayAlert:(NSString *)message withTitle:(NSString *)title;

@property (nonatomic, strong) EWHUser *user;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) EWHLoginController *loginView;
@property (nonatomic, strong) EWHSelectReceiptController *selectReceiptView;
@property (nonatomic, strong) EWHScanItemController *scanItemView;
@property (nonatomic, strong) UITableViewController *selectShipmentView;
@property (nonatomic, strong) UITableViewController *shipmentDetailsView;

@end
