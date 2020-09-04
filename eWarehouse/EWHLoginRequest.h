//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"

@interface EWHLoginRequest : EWHRequestAF
{

}

- (void)loginUser:(NSString *)username withPassword:(NSString *)password;

@end
