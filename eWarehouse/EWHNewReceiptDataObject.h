//
//  EWHNewReceiptDataObject.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import <Foundation/Foundation.h>
#import "EWHAppDataObject.h"
#import "EWHProgram.h"
#import "EWHVendor.h"
#import "EWHCarrier.h"
#import "EWHWarehouse.h"
#import "EWHOrigin.h"
#import "EWHShipMethod.h"
#import "EWHDestination.h"


@interface EWHNewReceiptDataObject : EWHAppDataObject
{
    NSString*	ProjectName;
	NSData*		data1;
	NSInteger	int1;
}
@property (nonatomic, copy) NSString* ProjectName;
@property (nonatomic, retain) NSData* data1;
@property (nonatomic, retain) EWHProgram* program;
@property (nonatomic, retain) EWHWarehouse* warehouse;
@property (nonatomic, retain) EWHVendor* vendor;
@property (nonatomic, retain) EWHCarrier* carrier;
@property (nonatomic, retain) EWHOrigin* origin;
@property (nonatomic, retain) EWHShipMethod* shipmethod;
@property (assign, nonatomic) NSInteger inventorytypeId;
@property (assign, nonatomic) NSInteger ReceiptId;
@property (nonatomic, copy) NSString* ReceiptNumber;
@property (assign, nonatomic) NSInteger DestinationId;
@property (nonatomic, retain) EWHDestination* lastDestination;
@property (nonatomic) CGFloat	float1;
@property (nonatomic) BOOL PromptInventoryType;
@property (nonatomic, retain) NSDate *DeliveryDateTime;
@property (assign, nonatomic) NSInteger ScanPartNumber;

@end
