//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"
#import "EWHWarehouse.h"

@interface EWHGetUserWarehouseListRequest : EWHRequest
{
}

- (void)getUserWarehouseListRequest:(NSInteger)userId withAuthHash:(NSString *)authHash;

@end