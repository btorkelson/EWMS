//
//  EWHGetDestinationsByProgramWarehouse.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHRequest.h"
#import "EWHDestination.h"

@interface EWHGetDestinationsByProgramWarehouse : EWHRequest
{
}

- (void)getDestinationsByProgramWarehouse:(NSInteger)programId warehouseId:(NSInteger)warehouseId locationId:(NSInteger)locationId withAuthHash:(NSString *)authHash;



@end
