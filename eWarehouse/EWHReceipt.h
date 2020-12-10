//
//  EWHUser.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHUtils.h"
#import "EWHCustomControl.h"
#import "EWHInboundCustomAttribute.h"

@interface EWHReceipt : NSObject {
    NSInteger ReceiptId;
    NSString *ReceiptNumber;
    NSString *ProgramName;
    NSDate *ReceivedDate;
    BOOL isContainer;
    NSInteger WarehouseId;
    NSInteger ProgramId;
    NSInteger ProjectId;
    NSString *ProjectNumber;
    NSString *ProjectSequenceNumber;
    NSInteger CarrierInfoId;
    NSInteger CarrierId;
    NSString *CarrierTrackingNumber;
    NSInteger VendorInfoId;
    NSInteger VendorId;
    NSString *VendorInvoiceNumber;
    NSInteger OriginId;
    NSInteger DestinationId;
    NSInteger ShippingMethod;
    NSDate *DeliveryDateTime;
    NSString *VendorName;
    NSString *CarrierName;
    NSString *OriginName;
    NSString *DestinationName;
    NSString *ShipMethodName;
    NSString *Message;
    NSInteger InventoryTypeId;
    BOOL PromptInventoryType;
    NSString *Comments;
    NSInteger ScanPartNumber;
    NSMutableArray* CustomControlSettings;
    NSMutableArray* InboundCustomAttributes;
    NSInteger ScanLocation;
}

@property (assign, nonatomic) NSInteger ReceiptId;
@property (nonatomic, retain) NSString *ReceiptNumber;
@property (nonatomic, retain) NSString *ProgramName;
@property (nonatomic, retain) NSDate *ReceivedDate;
@property (nonatomic) BOOL isContainer;
@property (assign, nonatomic) NSInteger WarehouseId;
@property (assign, nonatomic) NSInteger ProgramId;
@property (assign, nonatomic) NSInteger ProjectId;
@property (nonatomic, retain) NSString *ProjectNumber;
@property (nonatomic, retain) NSString *ProjectSequenceNumber;
@property (assign, nonatomic) NSInteger CarrierInfoId;
@property (assign, nonatomic) NSInteger CarrierId;
@property (nonatomic, retain) NSString *CarrierTrackingNumber;
@property (assign, nonatomic) NSInteger VendorInfoId;
@property (assign, nonatomic) NSInteger VendorId;
@property (nonatomic, retain) NSString *VendorInvoiceNumber;
@property (assign, nonatomic) NSInteger OriginId;
@property (assign, nonatomic) NSInteger DestinationId;
@property (assign, nonatomic) NSInteger ShippingMethod;
@property (nonatomic, retain) NSDate *DeliveryDateTime;
@property (nonatomic, retain) NSString *VendorName;
@property (nonatomic, retain) NSString *CarrierName;
@property (nonatomic, retain) NSString *OriginName;
@property (nonatomic, retain) NSString *DestinationName;
@property (nonatomic, retain) NSString *ShipMethodName;
@property (nonatomic, retain) NSString *Message;
@property (assign, nonatomic) NSInteger InventoryTypeId;
@property (nonatomic) BOOL PromptInventoryType;
@property (nonatomic, retain) NSString *Comments;
@property (assign, nonatomic) NSInteger ScanPartNumber;
@property (nonatomic, retain) NSMutableArray* CustomControlSettings;
@property (nonatomic, retain) NSMutableArray* InboundCustomAttributes;
@property (assign, nonatomic) NSInteger ScanLocation;



- (EWHReceipt *)initWithDictionary:(NSDictionary *)dictionary;

@end
