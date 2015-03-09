//
//  EWHGetInventoryTypesforProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 10/16/14.
//
//

#import "EWHRequest.h"
#import "EWHInventoryType.h"

@interface EWHGetInventoryTypesforProgram : EWHRequest

- (void)getInventoryTypesforProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
