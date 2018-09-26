//
//  EWHGetCycleCountJobDetailLocationCatalogs.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/24/18.
//
//

#import "EWHRequest.h"
#import "EWHLocation.h"
#import "EWHUser.h"

@interface EWHGetCycleCountJobDetailLocationCatalogs : EWHRequest

- (void)getCycleCountJobDetailLocationCatalogs:(NSInteger)cyclecountJobId locationId:(NSInteger)locationId isNew:(BOOL)isNew user:(EWHUser *)user;
@end
