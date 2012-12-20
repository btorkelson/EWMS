//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"

@interface EWHLoginRequest : EWHRequest
{

}

- (void)loginUser:(NSString *)username withPassword:(NSString *)password;

@end