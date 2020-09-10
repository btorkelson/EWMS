//
//  EWHGetDestinationsByProgramWarehouse.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHRequestAF.h"
#import "EWHDestination.h"

@interface EWHGetDestinationsByProgramWarehouse : EWHRequestAF
{
}

- (void)getDestinationsByProgramWarehouse:(NSInteger)programId warehouseId:(NSInteger)warehouseId locationId:(NSInteger)locationId withAuthHash:(NSString *)authHash;



@end
