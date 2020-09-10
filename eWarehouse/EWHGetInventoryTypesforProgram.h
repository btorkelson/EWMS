//
//  EWHGetInventoryTypesforProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 10/16/14.
//
//

#import "EWHRequestAF.h"
#import "EWHInventoryType.h"

@interface EWHGetInventoryTypesforProgram : EWHRequestAF

- (void)getInventoryTypesforProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
