//
//  EWHUser.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EWHWarehouse : NSObject {
    NSInteger Id;
    NSString *Name;
    NSMutableArray *binLocations;
}
@property (assign, nonatomic) NSInteger Id;
@property (nonatomic, retain) NSString *Name;
@property (strong, nonatomic) NSMutableArray *binLocations;
- (EWHWarehouse *)initWithDictionary:(NSDictionary *)dictionary;
@end