//
//  EWHUser.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHReceipt.h"

@implementation EWHReceipt

@synthesize ReceiptId;
@synthesize ReceiptNumber;
@synthesize ProgramName;
@synthesize Message;
@synthesize ReceivedDate;
@synthesize isContainer;
@synthesize WarehouseId;
@synthesize ProgramId;
@synthesize ProjectId;
@synthesize ProjectNumber;
@synthesize ProjectSequenceNumber;
@synthesize CarrierInfoId;
@synthesize CarrierId;
@synthesize CarrierTrackingNumber;
@synthesize VendorInfoId;
@synthesize VendorId;
@synthesize VendorInvoiceNumber;
@synthesize OriginId;
@synthesize DestinationId;
@synthesize ShippingMethod;
@synthesize VendorName;
@synthesize CarrierName;
@synthesize OriginName;
@synthesize DestinationName;
@synthesize ShipMethodName;
@synthesize InventoryTypeId;
@synthesize PromptInventoryType;
@synthesize ScanPartNumber;
@synthesize CustomControlSettings;
@synthesize InboundCustomAttributes;
@synthesize ScanLocation;




- (EWHReceipt *)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
    ReceiptId = [[dictionary objectForKey:@"ReceiptId"] intValue];
    ReceiptNumber = [dictionary objectForKey:@"ReceiptNumber"];
        ProgramName =[dictionary objectForKey:@"ProgramName"];
//        ReceivedDate = [EWHUtils mfDateFromDotNetJSONString:[dictionary objectForKey:@"ReceivedDate"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
        
//        ReceivedDate = [formatter dateFromString:@"1/23/2015 4:22:33"];
        ReceivedDate = [formatter dateFromString:[dictionary objectForKey:@"ReceivedDate"]];
    isContainer = [[dictionary objectForKey:@"isContainer"] boolValue];
    WarehouseId = [[dictionary objectForKey:@"WarehouseId"] intValue];
    ProgramId = [[dictionary objectForKey:@"ProgramId"] intValue];
    ProjectId = [[dictionary objectForKey:@"ProjectId"] intValue];
    ProjectNumber =[dictionary objectForKey:@"ProjectNumber"];
    CarrierInfoId = [[dictionary objectForKey:@"CarrierInfoId"] intValue];
    CarrierId = [[dictionary objectForKey:@"CarrierId"] intValue];
    CarrierTrackingNumber = [dictionary objectForKey:@"CarrierTrackingNumber"];
    VendorInfoId = [[dictionary objectForKey:@"VendorInfoId"] intValue];
    VendorId = [[dictionary objectForKey:@"VendorId"] intValue];
    VendorInvoiceNumber = [dictionary objectForKey:@"VendorInvoiceNumber"];
    OriginId = [[dictionary objectForKey:@"OriginId"] intValue];
    DestinationId  = [[dictionary objectForKey:@"DestinationId"] intValue];
    ShippingMethod  = [[dictionary objectForKey:@"ShippingMethod"] intValue];
    DeliveryDateTime = [EWHUtils mfDateFromDotNetJSONString:[dictionary objectForKey:@"DeliveryDateTime"]];
    VendorName = [dictionary objectForKey:@"VendorName"];
    CarrierName = [dictionary objectForKey:@"CarrierName"];
    OriginName = [dictionary objectForKey:@"OriginName"];
    DestinationName = [dictionary objectForKey:@"DestinationName"];
        ShipMethodName = [dictionary objectForKey:@"ShipMethodName"];
        InventoryTypeId  = [[dictionary objectForKey:@"InventoryTypeId"] intValue];
        PromptInventoryType = [[dictionary objectForKey:@"PromptInventoryType"] boolValue];
        ScanPartNumber  = [[dictionary objectForKey:@"ScanPartNumber"] intValue];
        CustomControlSettings = [dictionary objectForKey:@"CustomControlSettings"];
        ScanLocation  = [[dictionary objectForKey:@"ScanLocation"] intValue];
        
        NSMutableArray* inboundCAs = [[NSMutableArray alloc] init];
        for (NSDictionary* element in [dictionary objectForKey:@"InboundCustomAttributes"]) {
            EWHInboundCustomAttribute* ca = [[EWHInboundCustomAttribute alloc] initWithDictionary:element];
            [inboundCAs addObject:ca];
        }
        InboundCustomAttributes = inboundCAs;
    }
return self;
    //return [super init];
}

- (EWHReceipt *) init {
    VendorInvoiceNumber = @"";
    ProjectNumber = nil;
    CarrierId = nil;
    CarrierName = nil;
    return self;
}
@end
