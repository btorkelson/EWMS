//
//  EWHGetLocationsforPickingRequestNEW.h
//  eWarehouse
//
//  Created by Brian Torkelson on 6/3/13.
//
//

#import "EWHRequest.h"
#import "EWHLocation.h"

@interface EWHGetLocationsforPickingRequestNEW : EWHRequest


- (void)getLocationsForPickingRequestNEW:(NSInteger)shipmentId withAuthHash:(NSString *)authHash;


@end
