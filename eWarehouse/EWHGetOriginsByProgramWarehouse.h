//
//  EWHGetOriginsByProgramWarehouse.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/4/14.
//
//

#import "EWHRequestAF.h"
#import "EWHOrigin.h"

@interface EWHGetOriginsByProgramWarehouse : EWHRequestAF

- (void)getOriginsByProgramWarehouse:(NSInteger)programId warehouseid:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
