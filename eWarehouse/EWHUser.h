//
//  EWHUser.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EWHUser : NSObject {
    NSInteger UserId;
    NSString *FirstName;
    NSString *LastName;
    NSString *AuthHash;
    NSString *Message;
    BOOL EWAdmin;
}
@property (assign, nonatomic) NSInteger UserId;
@property (nonatomic, retain) NSString *FirstName;
@property (nonatomic, retain) NSString *LastName;
@property (nonatomic, retain) NSString *AuthHash;
@property (nonatomic, retain) NSString *Message;
@property (nonatomic) BOOL EWAdmin;


- (EWHUser *)initWithDictionary:(NSDictionary *)dictionary;
@end
