//
//  EWHUser.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHUser.h"

@implementation EWHUser
@synthesize UserId;
@synthesize FirstName;
@synthesize LastName;
@synthesize AuthHash;
@synthesize Message;

- (EWHUser *)initWithDictionary:(NSDictionary *)dictionary {
    UserId = [[dictionary objectForKey:@"UserId"] intValue];
    
    id first = [dictionary objectForKey:@"FirstName"];
    if(first != [NSNull null]) FirstName = [[NSString alloc] initWithString:first];
    
    id last = [dictionary objectForKey:@"LastName"];
    if(last != [NSNull null]) LastName = [[NSString alloc] initWithString:last];

    id hash = [dictionary objectForKey:@"AuthHash"];
    if(hash != [NSNull null]) AuthHash = [[NSString alloc] initWithString:hash];
    
    id msg = [dictionary objectForKey:@"Message"];
    if(msg != [NSNull null]) Message = [[NSString alloc] initWithString:msg];
    
    return [super init];
}
@end
