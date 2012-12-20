//
//  EWHUser.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHUtils.h"

@interface EWHReceipt : NSObject {
    NSInteger ReceiptId;
    NSString *ReceiptNumber;
    NSString *ProgramName;
    NSDate *ReceivedDate;
    BOOL isContainer;
    NSString *Message;
}

@property (assign, nonatomic) NSInteger ReceiptId;
@property (nonatomic, retain) NSString *ReceiptNumber;
@property (nonatomic, retain) NSString *ProgramName;
@property (nonatomic, retain) NSDate *ReceivedDate;
@property (nonatomic) BOOL isContainer;
@property (nonatomic, retain) NSString *Message;

- (EWHReceipt *)initWithDictionary:(NSDictionary *)dictionary;
@end