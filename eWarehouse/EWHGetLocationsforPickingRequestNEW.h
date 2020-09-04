//
//  EWHGetLocationsforPickingRequestNEW.h
//  eWarehouse
//
//  Created by Brian Torkelson on 6/3/13.
//
//

#import "EWHRequestAF.h"
#import "EWHLocation.h"

@interface EWHGetLocationsforPickingRequestNEW : EWHRequestAF


- (void)getLocationsForPickingRequestNEW:(NSInteger)shipmentId withAuthHash:(NSString *)authHash;


@end
