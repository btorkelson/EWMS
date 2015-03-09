//
//  EWHUser.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EWHLocation : NSObject {
    NSInteger Id;
    NSString *Name;
    NSString *LocationTypeName;
    NSInteger LocationTypeId;
}
@property (assign, nonatomic) NSInteger Id;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *LocationTypeName;
@property (assign, nonatomic) NSInteger LocationTypeId;
- (EWHLocation *)initWithDictionary:(NSDictionary *)dictionary;
@end