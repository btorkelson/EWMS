//
//  EWHUser.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EWHResponse : NSObject {
    BOOL Processed;
    NSString *Message;
    NSString *Number;
}
@property (assign, nonatomic) BOOL Processed;
@property (nonatomic, retain) NSString *Message;
@property (assign, nonatomic) NSInteger Id;
@property (nonatomic, retain) NSString *Number;

- (EWHResponse *)initWithDictionary:(NSDictionary *)dictionary;
@end