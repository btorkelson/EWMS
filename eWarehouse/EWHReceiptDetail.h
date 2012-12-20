//
//  EWHUser.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWHUtils.h"

@interface EWHReceiptDetail : NSObject {
    NSInteger Id;
    NSInteger ReceiptId;
    BOOL IsBulk;
    BOOL IsSerialized;
    NSInteger LocationId;    
    NSString *LocationName;
    NSString *SuggestedLocations;
    NSString *Number;
    NSString *PartNumber;
    NSInteger Quantity;
    NSString *Message;
}

@property (nonatomic) NSInteger Id;
@property (nonatomic) NSInteger ReceiptId;
@property (nonatomic) BOOL IsBulk;
@property (nonatomic) BOOL IsSerialized;
@property (nonatomic) NSInteger LocationId;
@property (nonatomic, retain) NSString *LocationName;
@property (nonatomic, retain) NSString *SuggestedLocations;
@property (nonatomic, retain) NSString *Number;
@property (nonatomic, retain) NSString *PartNumber;
@property (nonatomic) NSInteger Quantity;
@property (nonatomic, retain) NSString *Message;

- (EWHReceiptDetail *)initWithDictionary:(NSDictionary *)dictionary;
@end