//
//  EWHGetShipmentDetailsForLoadingRequest.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHShipmentDetail.h"

@interface EWHGetShipmentDetailsForLoadingRequest : EWHRequestAF
{
}

- (void)getShipmentDetailsForLoadingRequest:(NSInteger)shipmentId withAuthHash:(NSString *)authHash;

@end
