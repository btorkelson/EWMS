//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"
#import "EWHReceiptDetail.h"
#import "EWHResponse.h"

@interface EWHPutAwayContainerRequest : EWHRequest
{
}

- (void)putAwayContainer:(EWHReceiptDetail *)receiptDetail location:(NSString *)locationName user:(EWHUser *)user;

@end