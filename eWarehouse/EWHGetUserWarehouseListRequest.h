//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHWarehouse.h"

@interface EWHGetUserWarehouseListRequest : EWHRequestAF
{
}

- (void)getUserWarehouseListRequest:(NSInteger)userId withAuthHash:(NSString *)authHash;

@end
