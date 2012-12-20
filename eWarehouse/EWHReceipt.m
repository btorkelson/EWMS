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

- (EWHReceipt *)initWithDictionary:(NSDictionary *)dictionary {
    ReceiptId = [[dictionary objectForKey:@"ReceiptId"] intValue];
    ReceiptNumber = [[NSString alloc] initWithString:[dictionary objectForKey:@"ReceiptNumber"]];
    ProgramName = [[NSString alloc] initWithString:[dictionary objectForKey:@"ProgramName"]];
    ReceivedDate = [EWHUtils mfDateFromDotNetJSONString:[dictionary objectForKey:@"ReceivedDate"]];
    isContainer = [[dictionary objectForKey:@"isContainer"] boolValue];
//    NSString *msg = [dictionary objectForKey:@"Message"];
//    if(msg != nil){
//        Message = [[NSString alloc] initWithString:msg];
//    }
    return [super init];
}
@end
