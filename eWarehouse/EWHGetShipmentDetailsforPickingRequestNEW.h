//
//  EWHGetShipmentDetailsforPickingRequestNEW.h
//  eWarehouse
//
//  Created by Brian Torkelson on 6/6/13.
//
//

#import "EWHRequestAF.h"
#import "EWHShipmentDetail.h"

@interface EWHGetShipmentDetailsforPickingRequestNEW : EWHRequestAF
{
}

- (void)getShipmentDetailsForPickingRequestNEW:(NSInteger)shipmentId location:(NSString *)location withAuthHash:(NSString *)authHash;

@end
