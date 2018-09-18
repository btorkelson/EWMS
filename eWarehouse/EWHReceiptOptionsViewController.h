//
//  EWHReceiptVendorViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHNewReceiptDataObject.h"
#import "EWHAppDelegateProtocal.h"
#import "EWHGetVendorsByProgram.h"
#import "EWHGetCarriersByProgram.h"
#import "EWHCreateReceiptController.h"
#import "EWHGetOriginsByProgramWarehouse.h"
#import "EWHGetShipMethodsByProgram.h"
#import "EWHInboundCustomAttribute.h"


@interface EWHReceiptOptionsViewController : UITableViewController
{
}

@property (nonatomic, strong) EWHProgram *program;
@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, strong) NSString* entity;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) EWHInboundCustomAttribute *inboundCustomAttribute;

@end
