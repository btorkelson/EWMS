//
//  EWHUser.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHResponse.h"

@implementation EWHResponse
@synthesize Processed;
@synthesize Message;
@synthesize Id;
@synthesize Number;

- (EWHResponse *)initWithDictionary:(NSDictionary *)dictionary {
    Processed = [[dictionary objectForKey:@"Processed"] boolValue];
    Id = [[dictionary objectForKey:@"Id"] intValue];
    
    id msg = [dictionary objectForKey:@"Message"];
    if(msg != [NSNull null]) Message = [[NSString alloc] initWithString:msg];
//    Message = [dictionary objectForKey:@"Message"];
    Number = [dictionary objectForKey:@"Number"];
    
    return [super init];
}
@end
